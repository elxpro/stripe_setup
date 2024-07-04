defmodule StripeSetup.Billing.CreateStripeCustomer.Impl do
  import Ecto.Query, warn: false
  alias StripeSetup.Repo
  alias StripeSetup.Accounts
  alias StripeSetup.Billing.Customers
  @stripe_service Application.compile_env(:stripe_setup, :stripe_service)

  def subscripe_on_user_created(), do: Accounts.subscribe_on_user_created()

  def create_customer(user) do
    {:ok, %{id: stripe_id, default_source: default_source}} =
      @stripe_service.Customer.create(%{email: user.email})

    {:ok, billing_customer} =
      user
      |> Ecto.build_assoc(:billing_customer)
      |> Customers.change_customer(%{stripe_id: stripe_id, default_source: default_source})
      |> Repo.insert()

    notify_subscribers(billing_customer)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(StripeSetup.PubSub, "stripe_customer_created")
  end

  def notify_subscribers(customer) do
    Phoenix.PubSub.broadcast(StripeSetup.PubSub, "stripe_customer_created", {:customer, customer})
    customer
  end
end

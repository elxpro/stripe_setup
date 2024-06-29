defmodule StripeSetup.Billing.CreateStripeCustomer.Impl do
  import Ecto.Query, warn: false
  alias StripeSetup.Repo
  alias StripeSetup.Billing.Customer
  alias StripeSetup.Accounts

  @stripe_service Application.compile_env(:stripe_setup, :stripe_service)

  def subscribe_on_user_created() do
    Accounts.subscribe_on_user_created()
  end

  def create_customer(user) do
    {:ok, %{id: stripe_id, default_source: default_source}} =
      @stripe_service.Customer.create(%{email: user.email})

    {:ok, billing_customer} =
      user
      |> Ecto.build_assoc(:billing_customer)
      |> Customer.changeset(%{stripe_id: stripe_id, default_source: default_source})
      |> Repo.insert()

    notify_subscribers(billing_customer)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(StripeSetup.PubSub, "stripe_customer_created")
  end

  def notify_subscribers(customer) do
    Phoenix.PubSub.broadcast(
      StripeSetup.PubSub,
      "stripe_customer_created",
      {:customer, customer}
    )

    customer
  end
end

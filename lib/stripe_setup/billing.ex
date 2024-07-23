defmodule StripeSetup.Billing do
  @moduledoc """
  The Billing context.
  """
  @stripe_service Application.compile_env(:stripe_setup, :stripe_service)
  alias StripeSetup.Billing.Customers
  alias StripeSetup.Billing.Products
  alias StripeSetup.Billing.Plans
  alias StripeSetup.Billing.WebhookProcessor.Event

  defdelegate list_products_by_plan(plan), to: Products

  defdelegate subscribe_process_webhook(stripe_id), to: Event, as: :subscribe

  defdelegate get_billing_customer_for_user(user_id), to: Customers

  def list_plans_for_subscription_page() do
    Plans.list_plans_for_subscription_page()
    |> Enum.group_by(&Map.get(&1, :period))
    |> Enum.reduce([], fn {period, plans}, acc ->
      plans = Enum.map(plans, fn plan -> {"#{plan.name} - #{plan.amount}", plan.id} end)
      period = String.capitalize("#{period}ly subscription")
      Enum.concat(acc, [{period, plans}])
    end)
  end

  def create_and_attach_payment_method(customer_stripe_id, payment_method_id) do
    {:ok, payment_method} =
      @stripe_service.PaymentMethod.attach(%{
        customer: customer_stripe_id,
        payment_method: payment_method_id
      })

    @stripe_service.Customer.update(customer_stripe_id, %{
      invoice_settings: %{default_payment_method: payment_method.id}
    })
  end
end

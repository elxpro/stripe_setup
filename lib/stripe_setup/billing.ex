defmodule StripeSetup.Billing do
  @moduledoc """
  The Billing context.
  """
  alias StripeSetup.Billing.Customers
  alias StripeSetup.Billing.Products
  alias StripeSetup.Billing.Plans
  alias StripeSetup.Billing.WebhookProcessor.Event

  defdelegate list_products_by_plan(plan), to: Products

  defdelegate subscribe_process_webhook(), to: Event, as: :subscribe

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
end

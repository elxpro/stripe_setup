defmodule StripeSetup.Billing do
  @moduledoc """
  The Billing context.
  """
  alias StripeSetup.Billing.Products
  alias StripeSetup.Billing.Plans
  alias StripeSetup.Billing.Customers
  alias StripeSetup.Billing.Subscriptions

  defdelegate list_products(), to: Products
  defdelegate list_products_by_plan(plan), to: Products
  defdelegate delete_product(product), to: Products
  defdelegate with_plans(product_or_products), to: Products
  defdelegate create_product(attrs), to: Products

  defdelegate get_plan!(plan_id), to: Plans
  defdelegate list_plans(), to: Plans
  defdelegate create_plan(product, attrs), to: Plans

  defdelegate list_customers(), to: Customers
  defdelegate create_customer(customer), to: Customers
  # SHOULD NOT BE HERE YET
  # defdelegate list_plans_for_subscription_page, to: Plans
  # defdelegate get_billing_customer_for_user(user), to: Customers
  # defdelegate get_active_subscription_for_user(id), to: Subscriptions
end

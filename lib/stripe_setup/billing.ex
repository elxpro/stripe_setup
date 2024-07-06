defmodule StripeSetup.Billing do
  @moduledoc """
  The Billing context.
  """
  alias StripeSetup.Billing.Products

  defdelegate list_products_by_plan(plan), to: Products
end

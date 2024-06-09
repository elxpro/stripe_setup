defmodule StripeSetup.BillingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `StripeSetup.Billing` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        stripe_id: "some stripe_id",
        stripe_product_name: "some stripe_product_name"
      })
      |> StripeSetup.Billing.create_product()

    product
  end

  @doc """
  Generate a plan.
  """
  def plan_fixture(attrs \\ %{}) do
    product = product_fixture()

    attrs =
      attrs
      |> Enum.into(%{
        amount: 42,
        stripe_id: "some stripe_id",
        stripe_plan_name: "some stripe_plan_name"
      })

    {:ok, plan} = StripeSetup.Billing.create_plan(product, attrs)

    plan
  end
end

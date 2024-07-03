defmodule StripeSetup.ProductFixtures do
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
end

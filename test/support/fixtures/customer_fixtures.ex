defmodule StripeSetup.CustomerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `StripeSetup.Billing` context.
  """

  @doc """
  Generate a customer.
  """
  def customer_fixture(attrs \\ %{}) do
    {:ok, customer} =
      attrs
      |> Enum.into(%{
        default_source: "some default_source",
        stripe_id: "some stripe_id"
      })
      |> StripeSetup.Billing.Customers.create_customer()

    customer
  end
end

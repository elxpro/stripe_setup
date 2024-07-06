defmodule StripeSetup.SubscriptionFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `StripeSetup.Billing` context.
  """

  @doc """
  Generate a subscription.
  """
  def subscription_fixture(attrs \\ %{}) do
    {:ok, subscription} =
      attrs
      |> Enum.into(%{
        cancel_at: ~N[2024-06-08 19:24:00],
        current_period_end_at: ~N[2024-06-08 19:24:00],
        status: "some status",
        stripe_id: "some stripe_id"
      })
      |> StripeSetup.Billing.Subscriptions.create_subscription()

    subscription
  end
end

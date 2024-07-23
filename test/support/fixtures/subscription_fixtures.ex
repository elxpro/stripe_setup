defmodule StripeSetup.SubscriptionFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `StripeSetup.Billing` context.
  """

  @doc """
  Generate a subscription.
  """
  def subscription_fixture(attrs \\ %{}) do
    date = NaiveDateTime.utc_now() |> NaiveDateTime.add(10, :day)

    {:ok, subscription} =
      attrs
      |> Enum.into(%{
        cancel_at: date,
        current_period_end_at: date,
        status: "some status",
        stripe_id: "some stripe_id"
      })
      |> StripeSetup.Billing.Subscriptions.create_subscription()

    subscription
  end
end

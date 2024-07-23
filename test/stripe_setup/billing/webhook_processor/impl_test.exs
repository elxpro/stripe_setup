defmodule StripeSetup.Billing.WebhookProcessor.ImplTest do
  use StripeSetup.DataCase
  alias StripeSetup.Billing.WebhookProcessor.Impl

  describe "sync_event/1" do
    test "testing if all subscriptions are working" do
      assert Impl.sync_event(%{type: "pumpkin", data: %{object: %{id: "234"}}}) == nil
      assert Impl.sync_event(%{type: "product.created", data: %{object: %{id: "234"}}}) == :ok
      assert Impl.sync_event(%{type: "product.deleted", data: %{object: %{id: "234"}}}) == :ok
      assert Impl.sync_event(%{type: "plan.created", data: %{object: %{id: "234"}}}) == :ok
      assert Impl.sync_event(%{type: "plan.updated", data: %{object: %{id: "234"}}}) == :ok
      assert Impl.sync_event(%{type: "plan.deleted", data: %{object: %{id: "234"}}}) == :ok
      assert Impl.sync_event(%{type: "customer.deleted", data: %{object: %{id: "234"}}}) == nil
      assert Impl.sync_event(%{type: "customer.updated", data: %{object: %{id: "234"}}}) == nil
      assert Impl.sync_event(%{type: "customer.created", data: %{object: %{id: "234"}}}) == nil
      assert Impl.sync_event(%{type: "customer.subscription.updated", data: %{object: %{id: "234"}}}) == nil
      assert Impl.sync_event(%{type: "customer.subscription.deleted", data: %{object: %{id: "234"}}}) == nil
      assert Impl.sync_event(%{type: "customer.subscription.created", data: %{object: %{id: "234"}}}) == nil
    end
  end
end

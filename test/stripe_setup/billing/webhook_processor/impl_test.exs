defmodule StripeSetup.Billing.WebhookProcessor.ImplTest do
  use StripeSetup.DataCase
  alias StripeSetup.Billing.WebhookProcessor.Impl


  describe "sync_event/1" do
    test "testing if all subscriptions are working" do
      assert Impl.sync_event(%{type: "pumpkin"}) == nil
      assert Impl.sync_event(%{type: "product.created"}) == :ok
      assert Impl.sync_event(%{type: "product.deleted"}) == :ok
      assert Impl.sync_event(%{type: "plan.created"}) == :ok
      assert Impl.sync_event(%{type: "plan.updated"}) == :ok
      assert Impl.sync_event(%{type: "plan.deleted"}) == :ok
      assert Impl.sync_event(%{type: "customer.deleted"}) == nil
      assert Impl.sync_event(%{type: "customer.updated"}) == nil
      assert Impl.sync_event(%{type: "customer.created"}) == nil
      assert Impl.sync_event(%{type: "customer.subscription.updated"}) == nil
      assert Impl.sync_event(%{type: "customer.subscription.deleted"}) == nil
      assert Impl.sync_event(%{type: "customer.subscription.created"}) == nil
    end
  end
end

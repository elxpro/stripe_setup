defmodule StripeSetup.Billing.WebhookProcessor.EventTest do
  use StripeSetup.DataCase

  alias StripeSetup.Billing.WebhookProcessor.Event

  describe "testing subscriptions" do
    test "testing if all subscriptions are working" do
      assert {:messages, []} == Process.info(self(), :messages)

      assert Event.subscribe_on_webhook_recieved() == :ok
      assert Event.subscribe() == :ok

      assert Event.notify_subscribers("pumpkin") == :ok

      assert {:messages, [{:event, "pumpkin"}]} == Process.info(self(), :messages)
    end
  end
end

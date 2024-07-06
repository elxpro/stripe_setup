defmodule StripeSetup.Billing.WebhookProcessor.EventTest do
  use StripeSetup.DataCase
  alias StripeSetup.Billing.WebhookProcessor.Event

  describe "testing events" do
    test "test if webhook received the event" do

      assert {:messages, []} == Process.info(self(), :messages)

      assert Event.subscribe_on_webhook_received() == :ok
      assert Event.subscribe() == :ok

      assert Event.notify_subscribers("pumpkin") == :ok

      assert {:messages, [{:event, "pumpkin"}]} = Process.info(self(), :messages)
    end
  end
end

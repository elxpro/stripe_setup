defmodule StripeSetup.Billing.WebhookProcessor.EventTest do
  use StripeSetup.DataCase
  alias StripeSetup.Billing.WebhookProcessor.Event

  describe "testing events" do
    test "test if webhook received the event" do
      assert {:messages, []} == Process.info(self(), :messages)

      assert Event.subscribe_on_webhook_received() == :ok
      assert Event.subscribe("123") == :ok

      event = %{type: "pumpkin", data: %{object: %{id: "123"}}}
      assert Event.notify_subscribers(event) == :ok

      assert {:messages, [{:event, %{data: %{object: %{id: "123"}}, type: "pumpkin"}}]} = Process.info(self(), :messages)
    end
  end
end

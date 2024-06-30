defmodule StripeSetup.Billing.WebhookProcessor.ServerTest do
  use StripeSetup.DataCase
  alias StripeSetup.Billing.WebhookProcessor.Server
  alias StripeSetup.Billing.WebhookProcessor.Event

  @stripe_service Application.compile_env(:stripe_setup, :stripe_service)

  def event_fixture(attrs \\ %{}) do
    @stripe_service.Event.generate(attrs)
  end

  describe "listen for and processing a stripe event" do
    test "processes incoming events after broadcasing it" do
      start_supervised(Server, [])
      Event.subscribe()
      event = event_fixture()
      Event.notify_subscribers(event)
      assert_receive {:event, ^event}
    end
  end
end

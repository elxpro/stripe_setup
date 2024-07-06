defmodule StripeSetup.Billing.WebhookProcessor.ServerTest do
  use StripeSetup.DataCase
  alias StripeSetup.Billing.WebhookProcessor.Event
  alias StripeSetup.Billing.WebhookProcessor.Server

  @stripe_service Application.compile_env(:stripe_setup, :stripe_service)

  def event_fixture(attrs \\ %{}) do
    @stripe_service.Event.generate(attrs)
  end

  describe "testing the server" do
    test "testing the server  after broadcasting" do
      start_supervised(Server, [])

      Event.subscribe()

      event = event_fixture()
      Event.notify_subscribers(event)
      assert_receive {:event, ^event}
    end
  end
end

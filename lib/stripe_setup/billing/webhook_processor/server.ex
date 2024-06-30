defmodule StripeSetup.Billing.WebhookProcessor.Server do
  use GenServer
  alias StripeSetup.Billing.WebhookProcessor.Impl

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(state) do
    Impl.subscribe_on_webhook_recieved()
    {:ok, state}
  end

  def handle_info(%{event: event}, state) do
    Impl.sync_event(event)
    {:noreply, state}
  end
end

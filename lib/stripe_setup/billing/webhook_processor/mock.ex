defmodule StripeSetup.Billing.WebhookProcessor.Mock do
  use GenServer

  def start_link(_), do: GenServer.start_link(__MODULE__, nil)
  def init(state), do: {:ok, state}
end

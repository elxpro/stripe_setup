defmodule StripeSetup.Billing.CreateStripeCustomer.Mock do
  use GenServer

  def start_link(_), do: GenServer.start_link(__MODULE__, nil)
  def state(state), do: {:ok, state}
end

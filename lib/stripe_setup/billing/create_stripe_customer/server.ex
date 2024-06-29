defmodule StripeSetup.Billing.CreateStripeCustomer.Server do
  use GenServer
  alias StripeSetup.Billing.CreateStripeCustomer.Impl

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(state) do
    Impl.subscribe_on_user_created()
    {:ok, state}
  end

  def handle_info(%{user: user}, state) do
    Impl.create_customer(user)
    {:noreply, state}
  end

  # def handle_info(_, state), do: {:noreply, state}
end

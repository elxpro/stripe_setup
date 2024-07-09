defmodule StripeSetupWeb.SubscriptionLive.New do
  use StripeSetupWeb, :live_view
  alias StripeSetup.Billing
  @public_key Application.compile_env(:stripity_stripe, :public_key)

  def mount(_, _, socket) do
    if connected?(socket), do: Billing.subscribe_process_webhook()
    customer = Billing.get_billing_customer_for_user(socket.assigns.current_user.id)
    products = Billing.list_plans_for_subscription_page()

    socket =
      socket
      |> assign(:customer, customer)
      |> assign(:products, products)
      |> assign(:error_message, nil)
      |> assign(:loading, false)
      |> assign(:retry, false)
      |> assign(:public_key, @public_key)

    {:ok, socket}
  end
end

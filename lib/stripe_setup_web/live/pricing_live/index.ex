defmodule StripeSetupWeb.PricingLive.Index do
  use StripeSetupWeb, :live_view
  alias StripeSetup.Billing

  def handle_params(params, _, socket) do
    interval = params["interval"] || "month"

    products = Billing.list_products_by_plan(interval)

    socket =
      socket
      |> assign(interval: interval)
      |> assign(products: products)

    {:noreply, socket}
  end
end

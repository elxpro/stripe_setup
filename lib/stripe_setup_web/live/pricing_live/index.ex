defmodule StripeSetupWeb.PricingLive.Index do
  use StripeSetupWeb, :live_view
  alias StripeSetup.Billing
  alias StripeSetupWeb.PricingLive.ProductComponent

  @impl true
  def handle_params(params, _, socket) do
    interval = params["interval"] || "month"
    products = Billing.list_products_by_plan(interval)

    {:noreply,
     socket
     |> assign(:interval, interval)
     |> assign(:products, products)}
  end
end

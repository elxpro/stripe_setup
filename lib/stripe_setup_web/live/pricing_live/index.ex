defmodule StripeSetupWeb.PricingLive.Index do
  use StripeSetupWeb, :live_view
  alias StripeSetup.Billing
  alias StripeSetupWeb.PricingLive.ProductComponent

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :products, [])}
  end

  def handle_params(params, _, socket) do
    interval = params["interval"] || "monthly"
    {:noreply, assign(socket, :interval, interval)}
  end

  # def plan_price_for_interval(plans, interval \\ "month") do
  #   plans
  #   |> Enum.find(&(&1.stripe_plan_name == interval))
  #   |> (fn plan -> plan || %{} end).()
  #   |> Map.get(:amount)
  # end

  # defp get_products() do
  #   Billing.list_products()
  #   |> Billing.with_plans()
  #   |> IO.inspect()
  #   |> Enum.sort_by(&cheapest_plan_price/1)
  # end

  # defp cheapest_plan_price(product) do
  #   product.plans
  #   |> Enum.map(& &1.amount)
  #   |> Enum.min()
  # end
end

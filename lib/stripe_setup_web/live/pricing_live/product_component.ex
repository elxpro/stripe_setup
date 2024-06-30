defmodule StripeSetupWeb.PricingLive.ProductComponent do
  use StripeSetupWeb, :live_component

  @impl true
  def update(assigns, socket) do
    # IO.inspect(assigns)

    # amount =
    #   assigns.product.plans
    #   |> plan_price_for_interval(assigns.price_interval)
    #   |> format_price()

    IO.inspect(assigns)

    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:amount, 0)
    }
  end

  def render(assigns) do
    ~H"""
    <div class="hover:bg-blue-200 bg-blue-100 transition-all p-2 rounded-lg">
      <p class="mb-1 text-xs font-semibold tracking-wide text-gray-500 uppercase">
        <%= @name %>
      </p>
      <h1 class="mb-2 text-4xl font-bold leading-tight text-gray-900 md:font-extrabold">
        <%= @price %>
        <span class="text-2xl font-medium text-gray-600"> per month</span>
      </h1>
      <p class="text-lg text-gray-600 mb-12">
        <%= @description %>
      </p>
      <div class="mt-6 pb-8 justify-center block md:flex space-x-0 md:space-x-2 space-y-2 md:space-y-0">
        <a href="#" class="w-full bg-blue-800 text-white p-2 rounded-full md:w-auto">Get Started</a>
      </div>
    </div>
    """
  end

  defp plan_price_for_interval(plans, interval) do
    plans
    |> Enum.find(&(&1.stripe_plan_name == interval))
    |> (fn plan -> plan || %{} end).()
    |> Map.get(:amount)
  end

  defp format_price(amount) do
    rounded_amount = round(amount / 100)
    "$#{rounded_amount}"
  end
end

defmodule StripeSetupWeb.PricingLive.ProductComponent do
  use StripeSetupWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="hover:bg-blue-200 bg-blue-100 transition-all p-2 rounded-lg">
      <p class="mb-1 text-xs font-semibold tracking-wide text-gray-500 uppercase">
        <%= @product.stripe_product_name %>
      </p>
      <h1 class="mb-2 text-4xl font-bold leading-tight text-gray-900 md:font-extrabold">
        <%= @product.plan.amount %>
        <span class="text-2xl font-medium text-gray-600"> per month</span>
      </h1>
      <p class="text-lg text-gray-600 mb-12">
        ....
      </p>
      <div class="mt-6 pb-8 justify-center block md:flex space-x-0 md:space-x-2 space-y-2 md:space-y-0">
        <a href="#" class="w-full bg-blue-800 text-white p-2 rounded-full md:w-auto">Get Started</a>
      </div>
    </div>
    """
  end
end

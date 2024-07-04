defmodule StripeSetup.Billing.Synchronize.Products do
  alias StripeSetup.Billing.Products
  @stripe_service Application.compile_env(:stripe_setup, :stripe_service)

  def get_active_products() do
    {:ok, %{data: products}} = @stripe_service.Product.list(%{active: true})
    products
  end

  def run do
    products_by_stripe_id = Enum.group_by(Products.list_products(), & &1.stripe_id)

    existing_stripe_ids =
      get_active_products()
      |> Enum.map(fn stripe_product ->
        case Map.get(products_by_stripe_id, stripe_product.id) do
          nil ->
            Products.create_product(%{
              stripe_id: stripe_product.id,
              stripe_product_name: stripe_product.name
            })

          [billing_product] ->
            Products.update_product(billing_product, %{stripe_product_name: stripe_product.name})
        end

        stripe_product.id
      end)

    products_by_stripe_id
    |> Enum.reject(fn {stripe_id, _bp} ->
      Enum.member?(existing_stripe_ids, stripe_id)
    end)
    |> Enum.each(fn {_stripe_id, [billing_product]} ->
      Products.delete_product(billing_product)
    end)
  end
end

defmodule StripeSetup.Billing.SynchronizeProducts do
  @stripe_service Application.compile_env(:stripe_setup, :stripe_service)

  alias StripeSetup.Billing

  defp get_all_active_products_from_stripe do
    {:ok, %{data: products}} = @stripe_service.Product.list(%{active: true})
    products
  end

  def run do
    # First, we gather our existing products
    products_by_stripe_id =
      Billing.list_products()
      |> Enum.group_by(& &1.stripe_id)

    existing_stripe_ids =
      get_all_active_products_from_stripe()
      |> Enum.map(fn stripe_product ->
        case Map.get(products_by_stripe_id, stripe_product.id) do
          nil ->
            Billing.create_product(%{
              stripe_id: stripe_product.id,
              stripe_product_name: stripe_product.name
            })

          [billing_product] ->
            Billing.update_product(billing_product, %{stripe_product_name: stripe_product.name})
        end

        stripe_product.id
      end)

    products_by_stripe_id
    |> Enum.reject(fn {stripe_id, _billing_product} ->
      Enum.member?(existing_stripe_ids, stripe_id)
    end)
    |> Enum.each(fn {_stripe_id, [billing_product]} ->
      Billing.delete_product(billing_product)
    end)
  end
end

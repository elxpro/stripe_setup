defmodule StripeSetup.Billing.Synchronize.ProductsTest do
  use StripeSetup.DataCase
  alias StripeSetup.Billing.Products.Product
  alias StripeSetup.Billing.Products
  alias StripeSetup.Billing.Synchronize.Products, as: Sync

  describe "run" do
    test "sync products from stripe and creates them in billing_products" do
      assert Products.list_products() == []
      Sync.run()
      assert [%Product{}] = Products.list_products()
    end

    test "throw error when product exist in db but not in stripe" do
      {:ok, product} =
        Products.create_product(%{
          stripe_product_name: "not exist",
          stripe_id: "price_!23123"
        })

      assert Products.list_products() == [product]

      Sync.run()

      assert_raise Ecto.NoResultsError, fn -> Products.get_product!(product.id) end
    end
  end
end

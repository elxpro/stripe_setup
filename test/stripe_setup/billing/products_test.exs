defmodule StripeSetup.Billing.ProductsTest do
  use StripeSetup.DataCase

  @invalid_product_attrs %{stripe_id: nil, stripe_product_name: nil}

  describe "products" do
    alias StripeSetup.Billing.Products
    alias StripeSetup.Billing.Products.Product

    import StripeSetup.ProductFixtures

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Products.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Products.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      valid_attrs = %{
        stripe_id: "some stripe_id",
        stripe_product_name: "some stripe_product_name"
      }

      assert {:ok, %Product{} = product} = Products.create_product(valid_attrs)
      assert product.stripe_id == "some stripe_id"
      assert product.stripe_product_name == "some stripe_product_name"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product(@invalid_product_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()

      update_attrs = %{
        stripe_id: "some updated stripe_id",
        stripe_product_name: "some updated stripe_product_name"
      }

      assert {:ok, %Product{} = product} = Products.update_product(product, update_attrs)
      assert product.stripe_id == "some updated stripe_id"
      assert product.stripe_product_name == "some updated stripe_product_name"
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Products.update_product(product, @invalid_product_attrs)

      assert product == Products.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Products.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Products.change_product(product)
    end

    test "get_product_by_stripe_id!" do
      product = product_fixture()
      assert Products.get_product_by_stripe_id!(product.stripe_id) == product
    end
  end
end

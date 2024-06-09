defmodule StripeSetup.BillingTest do
  use StripeSetup.DataCase

  alias StripeSetup.Billing

  @invalid_product_attrs %{stripe_id: nil, stripe_product_name: nil}

  describe "products" do
    alias StripeSetup.Billing.Product

    import StripeSetup.BillingFixtures

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Billing.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Billing.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      valid_attrs = %{
        stripe_id: "some stripe_id",
        stripe_product_name: "some stripe_product_name"
      }

      assert {:ok, %Product{} = product} = Billing.create_product(valid_attrs)
      assert product.stripe_id == "some stripe_id"
      assert product.stripe_product_name == "some stripe_product_name"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Billing.create_product(@invalid_product_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()

      update_attrs = %{
        stripe_id: "some updated stripe_id",
        stripe_product_name: "some updated stripe_product_name"
      }

      assert {:ok, %Product{} = product} = Billing.update_product(product, update_attrs)
      assert product.stripe_id == "some updated stripe_id"
      assert product.stripe_product_name == "some updated stripe_product_name"
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Billing.update_product(product, @invalid_product_attrs)
      assert product == Billing.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Billing.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Billing.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Billing.change_product(product)
    end
  end

  describe "plans" do
    alias StripeSetup.Billing.Plan

    import StripeSetup.BillingFixtures

    @invalid_attrs %{amount: nil, stripe_id: nil, stripe_plan_name: nil}

    test "list_plans/0 returns all plans" do
      plan = plan_fixture()
      assert Billing.list_plans() == [plan]
    end

    test "get_plan!/1 returns the plan with given id" do
      plan = plan_fixture()
      assert Billing.get_plan!(plan.id) == plan
    end

    test "create_plan/1 with valid data creates a plan" do
      valid_attrs = %{
        amount: 42,
        stripe_id: "some stripe_id",
        stripe_plan_name: "some stripe_plan_name"
      }

      product = product_fixture()
      assert {:ok, %Plan{} = plan} = Billing.create_plan(product, valid_attrs)
      assert plan.amount == 42
      assert plan.stripe_id == "some stripe_id"
      assert plan.stripe_plan_name == "some stripe_plan_name"
    end

    test "create_plan/1 with invalid data returns error changeset" do
      product = product_fixture()

      assert {:error, %Ecto.Changeset{}} = Billing.create_plan(product, @invalid_attrs)
    end

    test "update_plan/2 with valid data updates the plan" do
      plan = plan_fixture()

      update_attrs = %{
        amount: 43,
        stripe_id: "some updated stripe_id",
        stripe_plan_name: "some updated stripe_plan_name"
      }

      assert {:ok, %Plan{} = plan} = Billing.update_plan(plan, update_attrs)
      assert plan.amount == 43
      assert plan.stripe_id == "some updated stripe_id"
      assert plan.stripe_plan_name == "some updated stripe_plan_name"
    end

    test "update_plan/2 with invalid data returns error changeset" do
      plan = plan_fixture()
      assert {:error, %Ecto.Changeset{}} = Billing.update_plan(plan, @invalid_attrs)
      assert plan == Billing.get_plan!(plan.id)
    end

    test "delete_plan/1 deletes the plan" do
      plan = plan_fixture()
      assert {:ok, %Plan{}} = Billing.delete_plan(plan)
      assert_raise Ecto.NoResultsError, fn -> Billing.get_plan!(plan.id) end
    end

    test "change_plan/1 returns a plan changeset" do
      plan = plan_fixture()
      assert %Ecto.Changeset{} = Billing.change_plan(plan)
    end
  end
end

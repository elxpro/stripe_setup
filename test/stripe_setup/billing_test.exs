defmodule StripeSetup.BillingTest do
  use StripeSetup.DataCase

  alias StripeSetup.Billing

  @invalid_product_attrs %{stripe_id: nil, stripe_product_name: nil}
  import StripeSetup.BillingFixtures
  alias StripeSetup.Billing.Product

  describe "products" do
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

  describe "customers" do
    alias StripeSetup.Billing.Customer

    import StripeSetup.BillingFixtures

    @invalid_attrs %{default_source: nil, stripe_id: nil}

    test "list_customers/0 returns all customers" do
      customer = customer_fixture()
      assert Billing.list_customers() == [customer]
    end

    test "get_customer!/1 returns the customer with given id" do
      customer = customer_fixture()
      assert Billing.get_customer!(customer.id) == customer
    end

    test "create_customer/1 with valid data creates a customer" do
      valid_attrs = %{default_source: "some default_source", stripe_id: "some stripe_id"}

      assert {:ok, %Customer{} = customer} = Billing.create_customer(valid_attrs)
      assert customer.default_source == "some default_source"
      assert customer.stripe_id == "some stripe_id"
    end

    test "create_customer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Billing.create_customer(@invalid_attrs)
    end

    test "update_customer/2 with valid data updates the customer" do
      customer = customer_fixture()

      update_attrs = %{
        default_source: "some updated default_source",
        stripe_id: "some updated stripe_id"
      }

      assert {:ok, %Customer{} = customer} = Billing.update_customer(customer, update_attrs)
      assert customer.default_source == "some updated default_source"
      assert customer.stripe_id == "some updated stripe_id"
    end

    test "update_customer/2 with invalid data returns error changeset" do
      customer = customer_fixture()
      assert {:error, %Ecto.Changeset{}} = Billing.update_customer(customer, @invalid_attrs)
      assert customer == Billing.get_customer!(customer.id)
    end

    test "delete_customer/1 deletes the customer" do
      customer = customer_fixture()
      assert {:ok, %Customer{}} = Billing.delete_customer(customer)
      assert_raise Ecto.NoResultsError, fn -> Billing.get_customer!(customer.id) end
    end

    test "change_customer/1 returns a customer changeset" do
      customer = customer_fixture()
      assert %Ecto.Changeset{} = Billing.change_customer(customer)
    end
  end

  describe "subscriptions" do
    alias StripeSetup.Billing.Subscription

    import StripeSetup.BillingFixtures

    @invalid_attrs %{cancel_at: nil, current_period_end_at: nil, status: nil, stripe_id: nil}

    test "list_subscriptions/0 returns all subscriptions" do
      subscription = subscription_fixture()
      assert Billing.list_subscriptions() == [subscription]
    end

    test "get_subscription!/1 returns the subscription with given id" do
      subscription = subscription_fixture()
      assert Billing.get_subscription!(subscription.id) == subscription
    end

    test "create_subscription/1 with valid data creates a subscription" do
      valid_attrs = %{
        cancel_at: ~N[2024-06-08 19:24:00],
        current_period_end_at: ~N[2024-06-08 19:24:00],
        status: "some status",
        stripe_id: "some stripe_id"
      }

      assert {:ok, %Subscription{} = subscription} = Billing.create_subscription(valid_attrs)
      assert subscription.cancel_at == ~N[2024-06-08 19:24:00]
      assert subscription.current_period_end_at == ~N[2024-06-08 19:24:00]
      assert subscription.status == "some status"
      assert subscription.stripe_id == "some stripe_id"
    end

    test "create_subscription/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Billing.create_subscription(@invalid_attrs)
    end

    test "update_subscription/2 with valid data updates the subscription" do
      subscription = subscription_fixture()

      update_attrs = %{
        cancel_at: ~N[2024-06-09 19:24:00],
        current_period_end_at: ~N[2024-06-09 19:24:00],
        status: "some updated status",
        stripe_id: "some updated stripe_id"
      }

      assert {:ok, %Subscription{} = subscription} =
               Billing.update_subscription(subscription, update_attrs)

      assert subscription.cancel_at == ~N[2024-06-09 19:24:00]
      assert subscription.current_period_end_at == ~N[2024-06-09 19:24:00]
      assert subscription.status == "some updated status"
      assert subscription.stripe_id == "some updated stripe_id"
    end

    test "update_subscription/2 with invalid data returns error changeset" do
      subscription = subscription_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Billing.update_subscription(subscription, @invalid_attrs)

      assert subscription == Billing.get_subscription!(subscription.id)
    end

    test "delete_subscription/1 deletes the subscription" do
      subscription = subscription_fixture()
      assert {:ok, %Subscription{}} = Billing.delete_subscription(subscription)
      assert_raise Ecto.NoResultsError, fn -> Billing.get_subscription!(subscription.id) end
    end

    test "change_subscription/1 returns a subscription changeset" do
      subscription = subscription_fixture()
      assert %Ecto.Changeset{} = Billing.change_subscription(subscription)
    end
  end

  test "get_product_by_stripe_id!/1 returns the product with given stripe_id" do
    product = product_fixture()
    assert Billing.get_product_by_stripe_id!(product.stripe_id) == product
  end

  describe "with_plans/1" do
    test " loads the plans for a specific product" do
      product = product_fixture()
      assert %Product{plans: []} = Billing.with_plans(product)
    end

    test " loads the plans for a list of products" do
      product = product_fixture()
      assert [%Product{plans: []}] = Billing.with_plans([product])
    end
  end
end

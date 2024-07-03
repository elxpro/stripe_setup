defmodule StripeSetup.BillingTest do
  use StripeSetup.DataCase

  alias StripeSetup.Billing

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
end

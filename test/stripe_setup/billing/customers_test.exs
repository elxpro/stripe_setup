defmodule StripeSetup.Billing.CustomersTest do
  use StripeSetup.DataCase

  describe "customers" do
    alias StripeSetup.Billing.Customers
    alias StripeSetup.Billing.Customers.Customer

    import StripeSetup.CustomerFixtures

    @invalid_attrs %{default_source: nil, stripe_id: nil}

    test "list_customers/0 returns all customers" do
      customer = customer_fixture()
      assert Customers.list_customers() == [customer]
    end

    test "get_customer!/1 returns the customer with given id" do
      customer = customer_fixture()
      assert Customers.get_customer!(customer.id) == customer
    end

    test "create_customer/1 with valid data creates a customer" do
      valid_attrs = %{default_source: "some default_source", stripe_id: "some stripe_id"}

      assert {:ok, %Customer{} = customer} = Customers.create_customer(valid_attrs)
      assert customer.default_source == "some default_source"
      assert customer.stripe_id == "some stripe_id"
    end

    test "create_customer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Customers.create_customer(@invalid_attrs)
    end

    test "update_customer/2 with valid data updates the customer" do
      customer = customer_fixture()

      update_attrs = %{
        default_source: "some updated default_source",
        stripe_id: "some updated stripe_id"
      }

      assert {:ok, %Customer{} = customer} = Customers.update_customer(customer, update_attrs)
      assert customer.default_source == "some updated default_source"
      assert customer.stripe_id == "some updated stripe_id"
    end

    test "update_customer/2 with invalid data returns error changeset" do
      customer = customer_fixture()
      assert {:error, %Ecto.Changeset{}} = Customers.update_customer(customer, @invalid_attrs)
      assert customer == Customers.get_customer!(customer.id)
    end

    test "delete_customer/1 deletes the customer" do
      customer = customer_fixture()
      assert {:ok, %Customer{}} = Customers.delete_customer(customer)
      assert_raise Ecto.NoResultsError, fn -> Customers.get_customer!(customer.id) end
    end

    test "change_customer/1 returns a customer changeset" do
      customer = customer_fixture()
      assert %Ecto.Changeset{} = Customers.change_customer(customer)
    end

    test "get_customer_by_stripe_id!/1 returns the customer with given id" do
      customer = customer_fixture()
      assert Customers.get_customer_by_stripe_id!(customer.stripe_id) == customer
    end

    test "get_billing_customer_for_user/1 returns the customer with given id" do
      customer = customer_fixture()
      assert Customers.get_billing_customer_for_user(customer.user_id) == customer
    end
  end
end

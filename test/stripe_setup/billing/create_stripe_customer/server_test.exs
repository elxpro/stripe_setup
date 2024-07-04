defmodule StripeSetup.Billing.CreateStripeCustomer.ServerTest do
  use StripeSetup.DataCase
  alias StripeSetup.Billing.CreateStripeCustomer.Impl
  alias StripeSetup.Billing.CreateStripeCustomer.Server
  alias StripeSetup.Accounts
  alias StripeSetup.Billing.Customers
  import StripeSetup.AccountsFixtures

  describe "testing the server" do
    test "testing the server  after broadcasting" do
      user = user_fixture()

      start_supervised(Server, [])
      Impl.subscribe()

      Accounts.notify_subscribers({:ok, user})

      assert_receive {:customer, billing_customer}

      assert [result | _] = Customers.list_customers()
      assert result == billing_customer
    end
  end
end

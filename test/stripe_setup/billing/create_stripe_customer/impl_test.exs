defmodule StripeSetup.Billing.CreateStripeCustomer.ImplTest do
  use StripeSetup.DataCase
  import StripeSetup.AccountsFixtures
  alias StripeSetup.Billing.CreateStripeCustomer.Impl
  alias StripeSetup.Billing.Customer

  describe "subscribe_on_user_created/0" do
    test "subscribes on user created" do
      assert Impl.subscribe_on_user_created() == :ok
    end
  end

  describe "create_customer/1" do
    test "create a new customer" do
      user = user_fixture()

      assert {:messages, []} == Process.info(self(), :messages)
      Impl.subscribe()

      assert %Customer{} = customer = Impl.create_customer(user)
      assert customer.user_id == user.id

      assert {:messages, [{:customer, result}]} = Process.info(self(), :messages)
      assert result == customer
    end
  end
end

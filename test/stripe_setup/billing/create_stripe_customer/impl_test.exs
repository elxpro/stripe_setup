defmodule StripeSetup.Billing.CreateStripeCustomer.ImplTest do
  use StripeSetup.DataCase
  alias StripeSetup.Billing.CreateStripeCustomer.Impl
  import StripeSetup.AccountsFixtures

  describe "subscripe_on_user_created" do
    test "subscribe on event" do
      assert Impl.subscripe_on_user_created() == :ok
    end
  end

  describe "create_customer/1" do
    test "create a new customer" do
      user = user_fixture()

      assert {:messages, []} == Process.info(self(), :messages)

      Impl.subscribe()

      assert customer = Impl.create_customer(user)
      assert customer.user_id == user.id

      assert {:messages, [{:customer, result}]} = Process.info(self(), :messages)
      assert customer == result
    end
  end
end

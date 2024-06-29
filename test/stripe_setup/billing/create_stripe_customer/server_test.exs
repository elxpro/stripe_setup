defmodule StripeSetup.Billing.CreateStripeCustomer.ServerTest do
  use StripeSetup.DataCase
  import StripeSetup.AccountsFixtures
  alias StripeSetup.{Accounts, Billing}
  alias StripeSetup.Billing.CreateStripeCustomer.Server
  alias StripeSetup.Billing.CreateStripeCustomer.Impl

  describe "creating a stripe customer and billing customer" do
    test "creates a billing customer after broadcasting it" do
      %{id: id} = user = user_fixture()
      start_supervised(Server, [])
      Impl.subscribe()

      Accounts.notify_subscribers({:ok, user})
      assert_receive {:customer, _}
      assert [%{user_id: ^id, stripe_id: "" <> _}] = Billing.list_customers()
    end
  end
end

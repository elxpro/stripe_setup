defmodule StripeSetup.Billing.SubscriptionsTest do
  use StripeSetup.DataCase
  alias StripeSetup.Billing.Subscriptions
  alias StripeSetup.Billing.Subscriptions.Subscription

  describe "subscriptions" do
    import StripeSetup.SubscriptionFixtures
    import StripeSetup.CustomerFixtures
    import StripeSetup.PlanFixtures

    @invalid_attrs %{cancel_at: nil, current_period_end_at: nil, status: nil, stripe_id: nil}

    test "list_subscriptions/0 returns all subscriptions" do
      subscription = subscription_fixture()
      assert Subscriptions.list_subscriptions() == [subscription]
    end

    test "get_subscription!/1 returns the subscription with given id" do
      subscription = subscription_fixture()
      assert Subscriptions.get_subscription!(subscription.id) == subscription
    end

    test "create_subscription/1 with valid data creates a subscription" do
      valid_attrs = %{
        cancel_at: ~N[2024-06-08 19:24:00],
        current_period_end_at: ~N[2024-06-08 19:24:00],
        status: "some status",
        stripe_id: "some stripe_id"
      }

      assert {:ok, %Subscription{} = subscription} =
               Subscriptions.create_subscription(valid_attrs)

      assert subscription.cancel_at == ~N[2024-06-08 19:24:00]
      assert subscription.current_period_end_at == ~N[2024-06-08 19:24:00]
      assert subscription.status == "some status"
      assert subscription.stripe_id == "some stripe_id"
    end

    test "create_subscription/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Subscriptions.create_subscription(@invalid_attrs)
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
               Subscriptions.update_subscription(subscription, update_attrs)

      assert subscription.cancel_at == ~N[2024-06-09 19:24:00]
      assert subscription.current_period_end_at == ~N[2024-06-09 19:24:00]
      assert subscription.status == "some updated status"
      assert subscription.stripe_id == "some updated stripe_id"
    end

    test "update_subscription/2 with invalid data returns error changeset" do
      subscription = subscription_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Subscriptions.update_subscription(subscription, @invalid_attrs)

      assert subscription == Subscriptions.get_subscription!(subscription.id)
    end

    test "delete_subscription/1 deletes the subscription" do
      subscription = subscription_fixture()
      assert {:ok, %Subscription{}} = Subscriptions.delete_subscription(subscription)
      assert_raise Ecto.NoResultsError, fn -> Subscriptions.get_subscription!(subscription.id) end
    end

    test "change_subscription/1 returns a subscription changeset" do
      subscription = subscription_fixture()
      assert %Ecto.Changeset{} = Subscriptions.change_subscription(subscription)
    end

    test "get_subscription_by_stripe_id!/1 returns the subscription with given stripe_id" do
      subscription = subscription_fixture()
      assert Subscriptions.get_subscription_by_stripe_id!(subscription.stripe_id) == subscription
    end
  end

  import StripeSetup.CustomerFixtures
  import StripeSetup.PlanFixtures
  import StripeSetup.SubscriptionFixtures

  describe "create_full_subscription" do
    test "create_full_subscription/1 creates a subscription" do
      customer = customer_fixture()
      plan = plan_fixture()

      %{id: stripe_id} =
        stripe_subscription = subscription_data(%{customer_id: customer.id, plan_id: plan.id})

      Subscriptions.create_full_subscription(stripe_subscription)

      assert [%Subscription{stripe_id: ^stripe_id} = subscription] =
               Subscriptions.list_subscriptions()

      assert subscription.status == "active"
      assert subscription.current_period_end_at == ~N[2020-11-30 11:35:29]
      assert subscription.customer_id == customer.id
      assert subscription.plan_id == plan.id
    end
  end

  describe "update_full_subscription" do
    test "update_full_subscription/1 cancels a subscription" do
      customer = customer_fixture()
      plan = plan_fixture()

      subscription =
        subscription_fixture(%{
          status: "active",
          cancel_at: nil,
          customer_id: customer.id,
          plan_id: plan.id
        })

      stripe_subscription =
        subscription_data(%{
          id: subscription.stripe_id,
          customer_id: customer.id,
          plan_id: plan.id,
          status: "canceled",
          canceled_at: 1_604_064_386
        })

      assert [%Subscription{cancel_at: nil}] = Subscriptions.list_subscriptions()
      Subscriptions.update_full_subscription(stripe_subscription)

      assert [%Subscription{status: "canceled", cancel_at: ~N[2020-10-30 13:26:26]}] =
               Subscriptions.list_subscriptions()
    end
  end

  defp subscription_data(attrs) do
    %Stripe.Subscription{
      created: 1_604_057_729,
      current_period_start: 1_604_057_729,
      start_date: 1_604_057_729,
      billing_cycle_anchor: 1_604_057_729,
      current_period_end: 1_606_736_129,
      object: "subscription",
      id: Ecto.UUID.generate(),
      latest_invoice: MockStripe.token(),
      customer: attrs.customer_id,
      quantity: 1,
      status: "active",
      collection_method: "charge_automatically",
      cancel_at_period_end: false,
      plan: %Stripe.Plan{
        id: attrs.plan_id
      }
    }
    |> Map.merge(attrs)
  end
end

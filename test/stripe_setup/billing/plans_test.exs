defmodule StripeSetup.Billing.PlansTest do
  use StripeSetup.DataCase

  describe "plans" do
    alias StripeSetup.Billing.Plans.Plan
    alias StripeSetup.Billing.Plans

    import StripeSetup.ProductFixtures
    import StripeSetup.PlanFixtures

    @invalid_attrs %{amount: nil, stripe_id: nil, stripe_plan_name: nil}

    test "list_plans/0 returns all plans" do
      plan = plan_fixture()
      assert Plans.list_plans() == [plan]
    end

    test "get_plan!/1 returns the plan with given id" do
      plan = plan_fixture()
      assert Plans.get_plan!(plan.id) == plan
    end

    test "create_plan/1 with valid data creates a plan" do
      valid_attrs = %{
        amount: 42,
        stripe_id: "some stripe_id",
        stripe_plan_name: "some stripe_plan_name"
      }

      product = product_fixture()
      assert {:ok, %Plan{} = plan} = Plans.create_plan(product, valid_attrs)
      assert plan.amount == %Money{amount: 42, currency: :USD}
      assert plan.stripe_id == "some stripe_id"
      assert plan.stripe_plan_name == "some stripe_plan_name"
    end

    test "create_plan/1 with invalid data returns error changeset" do
      product = product_fixture()

      assert {:error, %Ecto.Changeset{}} = Plans.create_plan(product, @invalid_attrs)
    end

    test "update_plan/2 with valid data updates the plan" do
      plan = plan_fixture()

      update_attrs = %{
        amount: 43,
        stripe_id: "some updated stripe_id",
        stripe_plan_name: "some updated stripe_plan_name"
      }

      assert {:ok, %Plan{} = plan} = Plans.update_plan(plan, update_attrs)
      assert plan.amount == %Money{amount: 43, currency: :USD}
      assert plan.stripe_id == "some updated stripe_id"
      assert plan.stripe_plan_name == "some updated stripe_plan_name"
    end

    test "update_plan/2 with invalid data returns error changeset" do
      plan = plan_fixture()
      assert {:error, %Ecto.Changeset{}} = Plans.update_plan(plan, @invalid_attrs)
      assert plan == Plans.get_plan!(plan.id)
    end

    test "delete_plan/1 deletes the plan" do
      plan = plan_fixture()
      assert {:ok, %Plan{}} = Plans.delete_plan(plan)
      assert_raise Ecto.NoResultsError, fn -> Plans.get_plan!(plan.id) end
    end

    test "change_plan/1 returns a plan changeset" do
      plan = plan_fixture()
      assert %Ecto.Changeset{} = Plans.change_plan(plan)
    end

    test "get_plan_by_stripe_id!/1 returns the plan with given stripe_id" do
      plan = plan_fixture()
      assert Plans.get_plan_by_stripe_id!(plan.stripe_id) == plan
    end

    test "list_plans_for_subscription_page/0 returns all plans" do
      plan_fixture()

      assert [
               %{
                 amount: %Money{amount: 42, currency: :USD},
                 name: "some stripe_product_name",
                 period: "some stripe_plan_name"
               }
             ] = Plans.list_plans_for_subscription_page()
    end
  end
end

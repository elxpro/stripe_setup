defmodule StripeSetup.Billing.SynchronizePlansTest do
  use StripeSetup.DataCase
  alias StripeSetup.Billing
  alias StripeSetup.Billing.SynchronizePlans
  @stripe_service Application.compile_env(:stripe_setup, :stripe_service)

  def create_product(_) do
    {:ok, %{data: [plan | _rest]}} = @stripe_service.Plan.list(%{active: true})

    {:ok, product} =
      Billing.create_product(%{
        stripe_product_name: "Standard Product",
        stripe_id: plan.product
      })

    %{product: product}
  end

  describe "run" do
    setup [:create_product]

    test "run/0 syncs plans from stripe and creates them in billing_plans" do
      assert Billing.list_plans() == []
      SynchronizePlans.run()
      assert [%StripeSetup.Billing.Plan{}] = Billing.list_plans()
    end

    test "run/0 deletes plans that exists in local database but does not exists in stripe", %{
      product: product
    } do
      {:ok, plan} =
        Billing.create_plan(product, %{
          stripe_plan_name: "Dont exists",
          stripe_id: "price_abc123def456",
          amount: 666
        })

      assert Billing.list_plans() == [plan]
      SynchronizePlans.run()
      assert_raise Ecto.NoResultsError, fn -> Billing.get_plan!(plan.id) end
    end
  end
end

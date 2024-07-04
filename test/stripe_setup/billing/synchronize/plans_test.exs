defmodule StripeSetup.Billing.Synchronize.PlansTest do
  use StripeSetup.DataCase
  alias StripeSetup.Billing.Plans
  alias StripeSetup.Billing.Plans.Plan
  alias StripeSetup.Billing.Products
  alias StripeSetup.Billing.Synchronize.Plans, as: Sync
  @stripe_service Application.compile_env(:stripe_setup, :stripe_service)

  defp create_product(_) do
    {:ok, %{data: [plan | _]}} = @stripe_service.Plan.list(%{active: true})

    {:ok, product} =
      Products.create_product(%{
        stripe_id: plan.product,
        stripe_product_name: "Test Product"
      })

    %{product: product}
  end

  describe "run" do
    setup [:create_product]

    test "sync plans from stripe and creates them in billing_plans" do
      assert Plans.list_plans() == []
      Sync.run()
      assert [%Plan{}] = Plans.list_plans()
    end

    test "throw error when plan exist in db but not in stripe", %{product: product} do
      {:ok, plan} =
        Plans.create_plan(product, %{
          stripe_plan_name: "not exist",
          stripe_id: "price_!23123",
          amount: 123
        })

      assert Plans.list_plans() == [plan]

      Sync.run()

      assert_raise Ecto.NoResultsError, fn -> Plans.get_plan!(plan.id) end
    end
  end
end

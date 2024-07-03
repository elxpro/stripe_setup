defmodule StripeSetup.Billing.SynchronizePlans do
  alias StripeSetup.Billing.Plans
  alias StripeSetup.Billing.Products
  @stripe_service Application.compile_env(:stripe_setup, :stripe_service)

  defp get_all_active_plans_from_stripe do
    {:ok, %{data: plans}} = @stripe_service.Plan.list(%{active: true})
    plans
  end

  def run do
    # First, we gather our existing products
    plans_by_stripe_id =
      Plans.list_plans()
      |> Enum.group_by(& &1.stripe_id)

    existing_stripe_ids =
      get_all_active_plans_from_stripe()
      |> Enum.map(fn stripe_plan ->
        stripe_plan_name = stripe_plan.name || stripe_plan.nickname || stripe_plan.interval
        billing_product = Products.get_product_by_stripe_id!(stripe_plan.product)

        case Map.get(plans_by_stripe_id, stripe_plan.id) do
          nil ->
            Plans.create_plan(billing_product, %{
              stripe_id: stripe_plan.id,
              stripe_plan_name: stripe_plan_name,
              amount: stripe_plan.amount
            })

          [billing_plan] ->
            Plans.update_plan(billing_plan, %{
              stripe_plan_name: stripe_plan_name,
              amount: stripe_plan.amount
            })
        end

        stripe_plan.id
      end)

    plans_by_stripe_id
    |> Enum.reject(fn {stripe_id, _billing_plan} ->
      Enum.member?(existing_stripe_ids, stripe_id)
    end)
    |> Enum.each(fn {_stripe_id, [billing_plan]} ->
      Plans.delete_plan(billing_plan)
    end)
  end
end

defmodule StripeSetup.Billing.Synchronize.Plans do
  alias StripeSetup.Billing.Plans
  alias StripeSetup.Billing.Products

  @stripe_service Application.compile_env(:stripe_setup, :stripe_service)

  def get_active_plans() do
    {:ok, %{data: plans}} = @stripe_service.Plan.list(%{active: true})
    plans
  end

  def run do
    plans_by_stripe_id = Enum.group_by(Plans.list_plans(), & &1.stripe_id)

    existing_stripe_ids =
      get_active_plans()
      |> Enum.map(fn stripe_plan ->
        stripe_plan_name = stripe_plan.name || stripe_plan.nickname || stripe_plan.interval
        billing_product = Products.get_product_by_stripe_id!(stripe_plan.product)

        case Map.get(plans_by_stripe_id, stripe_plan.id) do
          nil ->
            Plans.create_plan(billing_product, %{
              amount: stripe_plan.amount,
              stripe_id: stripe_plan.id,
              stripe_plan_name: stripe_plan_name
            })

          [billing_plan] ->
            Plans.update_plan(billing_plan, %{
              amount: stripe_plan.amount,
              stripe_plan_name: stripe_plan_name
            })
        end

        stripe_plan.id
      end)

    plans_by_stripe_id
    |> Enum.reject(fn {stripe_id, _bp} ->
      Enum.member?(existing_stripe_ids, stripe_id)
    end)
    |> Enum.each(fn {_stripe_id, [billing_plan]} ->
      Plans.delete_plan(billing_plan)
    end)
  end
end

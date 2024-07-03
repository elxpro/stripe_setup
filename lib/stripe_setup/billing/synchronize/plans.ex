defmodule StripeSetup.Billing.Synchronize.Plans do
  @stripe_service Application.compile_env(:stripe_setup, :stripe_service)

  def get_active_plans() do
    {:ok, %{data: plans}} = @stripe_service.Plan.list(%{active: true})
    plans
  end
end

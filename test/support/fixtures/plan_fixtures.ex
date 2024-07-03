defmodule StripeSetup.PlanFixtures do
  import StripeSetup.ProductFixtures

  @doc """
  Generate a plan.
  """
  def plan_fixture(attrs \\ %{}) do
    product = product_fixture()

    attrs =
      attrs
      |> Enum.into(%{
        amount: 42,
        stripe_id: "some stripe_id",
        stripe_plan_name: "some stripe_plan_name"
      })

    {:ok, plan} = StripeSetup.Billing.create_plan(product, attrs)

    plan
  end
end

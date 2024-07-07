defmodule StripeSetup.PlanFixtures do
  @doc """
  Generate a plan.
  """
  import StripeSetup.ProductFixtures

  def plan_fixture(attrs \\ %{}) do
    product = product_fixture()

    attrs =
      attrs
      |> Enum.into(%{
        amount: 42,
        stripe_id: Ecto.UUID.generate(),
        stripe_plan_name: "some stripe_plan_name"
      })

    {:ok, plan} = StripeSetup.Billing.Plans.create_plan(product, attrs)

    plan
  end
end

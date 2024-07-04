defmodule StripeSetup.Billing.Plans.Plan do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "billing_plans" do
    field :amount, :integer
    field :stripe_id, :string
    field :stripe_plan_name, :string
    belongs_to :product, StripeSetup.Billing.Products.Product, foreign_key: :billing_product_id
    has_many :subscriptions, StripeSetup.Billing.Subscription
    timestamps()
  end

  @doc false
  def changeset(plan, attrs) do
    plan
    |> cast(attrs, [:stripe_id, :stripe_plan_name, :amount])
    |> validate_required([:stripe_id, :stripe_plan_name, :amount])
    |> unique_constraint(:stripe_id, name: :billing_plans_stripe_id_index)
  end
end

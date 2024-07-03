defmodule StripeSetup.Billing.Subscription do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "billing_subscriptions" do
    field :cancel_at, :naive_datetime
    field :current_period_end_at, :naive_datetime
    field :status, :string
    field :stripe_id, :string
    belongs_to :plan, StripeSetup.Billing.Plans.Plan
    belongs_to :customer, StripeSetup.Billing.Customer

    timestamps()
  end

  @doc false
  def changeset(subscription, attrs) do
    subscription
    |> cast(attrs, [:stripe_id, :status, :current_period_end_at, :cancel_at])
    |> validate_required([:stripe_id, :status, :current_period_end_at, :cancel_at])
    |> unique_constraint(:stripe_id, name: :billing_subscriptions_stripe_id_index)
  end
end

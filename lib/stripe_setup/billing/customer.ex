defmodule StripeSetup.Billing.Customer do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "billing_customers" do
    field :default_source, :string
    field :stripe_id, :string
    belongs_to :user, StripeSetup.Accounts.User
    timestamps()
  end

  @doc false
  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [:stripe_id, :default_source])
    |> validate_required([:stripe_id, :default_source])
    |> unique_constraint(:stripe_id, name: :billing_customers_stripe_id_index)
  end
end

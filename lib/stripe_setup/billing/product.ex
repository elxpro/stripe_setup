defmodule StripeSetup.Billing.Product do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "billing_products" do
    field :stripe_id, :string
    field :stripe_product_name, :string

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:stripe_id, :stripe_product_name])
    |> validate_required([:stripe_id, :stripe_product_name])
    |> unique_constraint(:stripe_id, name: :billing_products_stripe_id_index)
  end
end

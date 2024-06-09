defmodule StripeSetup.Repo.Migrations.CreateBillingProducts do
  use Ecto.Migration

  def change do
    create table(:billing_products, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :stripe_id, :string
      add :stripe_product_name, :string

      timestamps()
    end

    create unique_index(:billing_products, :stripe_id)
  end
end

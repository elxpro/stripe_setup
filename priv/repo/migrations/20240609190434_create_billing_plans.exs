defmodule StripeSetup.Repo.Migrations.CreateBillingPlans do
  use Ecto.Migration

  def change do
    create table(:billing_plans, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :stripe_id, :string
      add :stripe_plan_name, :string
      add :amount, :integer

      add :billing_product_id,
          references(:billing_products, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:billing_plans, [:billing_product_id])
    create unique_index(:billing_plans, :stripe_id)
  end
end

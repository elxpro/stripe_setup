defmodule StripeSetup.Repo.Migrations.CreateBillingSubscriptions do
  use Ecto.Migration

  def change do
    create table(:billing_subscriptions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :stripe_id, :string
      add :status, :string
      add :current_period_end_at, :naive_datetime
      add :cancel_at, :naive_datetime
      add :plan_id, references(:billing_plans, on_delete: :nothing, type: :binary_id)
      add :customer_id, references(:billing_customers, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:billing_subscriptions, [:plan_id])
    create index(:billing_subscriptions, [:customer_id])

    create unique_index(:billing_subscriptions, :stripe_id)
  end
end

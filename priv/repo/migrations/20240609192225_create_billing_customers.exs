defmodule StripeSetup.Repo.Migrations.CreateBillingCustomers do
  use Ecto.Migration

  def change do
    create table(:billing_customers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :stripe_id, :string
      add :default_source, :string
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:billing_customers, [:user_id])
    create unique_index(:billing_customers, :stripe_id)
  end
end

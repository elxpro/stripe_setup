defmodule StripeSetup.Repo do
  use Ecto.Repo,
    otp_app: :stripe_setup,
    adapter: Ecto.Adapters.Postgres
end

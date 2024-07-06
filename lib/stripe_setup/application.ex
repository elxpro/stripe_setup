defmodule StripeSetup.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias StripeSetup.Billing.CreateStripeCustomer
  alias StripeSetup.Billing.WebhookProcessor

  @impl true
  def start(_type, _args) do
    create_stripe_customer_service = get_customer_service(Mix.env())
    stripe_processor = get_stripe_processor(Mix.env())

    children = [
      # Start the Telemetry supervisor
      StripeSetupWeb.Telemetry,
      # Start the Ecto repository
      StripeSetup.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: StripeSetup.PubSub},
      # Start Finch
      {Finch, name: StripeSetup.Finch},
      # Start the Endpoint (http/https)
      StripeSetupWeb.Endpoint,
      create_stripe_customer_service,
      stripe_processor
      # Start a worker by calling: StripeSetup.Worker.start_link(arg)
      # {StripeSetup.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: StripeSetup.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    StripeSetupWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  def get_customer_service(:test), do: CreateStripeCustomer.Mock
  def get_customer_service(_), do: CreateStripeCustomer.Server

  def get_stripe_processor(:test), do: WebhookProcessor.Mock
  def get_stripe_processor(_), do: WebhookProcessor.Server
end

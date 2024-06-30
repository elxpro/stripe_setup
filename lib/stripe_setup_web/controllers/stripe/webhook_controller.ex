defmodule StripeSetupWeb.Stripe.WebhookController do
  use StripeSetupWeb, :controller
  alias StripeSetup.Billing.WebhookProcessor.Event

  @webhook_signing_key Application.compile_env(:stripity_stripe, :webhook_signing_key)
  @stripe_service Application.compile_env(:stripe_setup, :stripe_service)
  plug :assert_body_and_signature

  def create(conn, _params) do
    raw_body = conn.assigns[:raw_body]
    stripe_signature = conn.assigns[:stripe_signature]

    construct_event =
      @stripe_service.Webhook.construct_event(raw_body, stripe_signature, @webhook_signing_key)

    case construct_event do
      # Will be handled further down
      {:ok, %{} = event} -> Event.notify_subscribers(event)
      {:error, reason} -> reason
    end

    send_resp(conn, :created, "")
  end

  defp assert_body_and_signature(conn, _opts) do
    case {conn.assigns[:raw_body], conn.assigns[:stripe_signature]} do
      {"" <> _, "" <> _} ->
        conn

      _ ->
        conn
        |> send_resp(:created, "")
        |> halt()
    end
  end
end

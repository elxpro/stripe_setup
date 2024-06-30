defmodule StripeSetupWeb.Stripe.WebhookController do
  use StripeSetupWeb, :controller

  @webhook_signing_key Application.compile_env(:stripity_stripe, :webhook_signing_key)
  @stripe_service Application.compile_env(:stripe_setup, :stripe_service)
  plug :assert_body_and_signature

  def create(conn, _params) do
    case @stripe_service.Webhook.construct_event(
           conn.assigns[:raw_body],
           conn.assigns[:stripe_signature],
           @webhook_signing_key
         ) do
      # Will be handled further down
      {:ok, %{} = event} -> event
      {:error, reason} -> reason
    end

    conn
    |> send_resp(:created, "")
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

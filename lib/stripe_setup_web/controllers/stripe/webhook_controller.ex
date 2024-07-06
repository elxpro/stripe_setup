defmodule StripeSetupWeb.Stripe.WebhookController do
  use StripeSetupWeb, :controller

  @webhook_signing_key Application.compile_env(:stripity_stripe, :webhook_signing_key)
  @stripe_service Application.compile_env(:stripe_setup, :stripe_service)

  def create(conn, _params) do
    raw_body = conn.assigns[:raw_body]
    stripe_signature = conn.assigns[:stripe_signature]

    case @stripe_service.Webhook.construct_event(raw_body, stripe_signature, @webhook_signing_key) do
      {:ok, %{} = event} -> event
      {:error, reason} -> reason
    end

    send_resp(conn, :created, "")
  end

  defp assert_body_and_signature(conn, _) do
    raw_body = conn.assigns[:raw_body]
    stripe_signature = conn.assigns[:stripe_signature]

    case {raw_body, stripe_signature} do
      {"" <> _, "" <> _} -> {:ok, conn}
      _ -> conn |> send_resp(:created, "") |> halt()
    end
  end
end

defmodule StripeSetupWeb.Plugs.StripePayload do
  import Plug.Conn, only: [get_req_header: 2, assign: 3, read_body: 1]

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_stripe_signature(conn) do
      [] ->
        conn

      ["" <> stripe_signature] ->
        {:ok, raw_body, _co} = read_body(conn)

        conn
        |> assign(:raw_body, raw_body)
        |> assign(:stripe_signature, stripe_signature)
    end
  end

  def get_stripe_signature(conn) do
    get_req_header(conn, "stripe-signature") ++ get_req_header(conn, "Stripe-Signature")
  end
end

defmodule MockStripe.Webhook do
  alias MockStripe.Event

  def construct_event(_raw_body, "wrong_signature" = _, _webhook_signing_key) do
    send(self(), {:ok, "invalid_webhook"})
    {:error, "Signature has expired"}
  end

  def construct_event(_raw_body, _, _webhook_signing_key) do
    send(self(), {:ok, "valid_webhook"})
    {:ok, Event.generate()}
  end
end

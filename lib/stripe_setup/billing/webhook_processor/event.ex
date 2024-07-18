defmodule StripeSetup.Billing.WebhookProcessor.Event do
  import Phoenix.PubSub, only: [subscribe: 2, broadcast: 3]

  @pubsub StripeSetup.PubSub
  @webhook_processed "webhook_processed"
  @webhook_received "webhook_received"

  def notify_subscribers(event) do
    stripe_id = event.data.object.id
    IO.inspect event
    broadcast(@pubsub, @webhook_processed <> ":#{stripe_id}", {:event, event})
  end

  def subscribe(stripe_id),
    do: subscribe(@pubsub, @webhook_processed <> ":#{stripe_id}")

  def subscribe_on_webhook_received, do: subscribe(@pubsub, @webhook_received)
end

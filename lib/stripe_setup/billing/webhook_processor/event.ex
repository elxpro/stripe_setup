defmodule StripeSetup.Billing.WebhookProcessor.Event do
  import Phoenix.PubSub, only: [subscribe: 2, broadcast: 3]

  @pubsub StripeSetup.PubSub
  @webhook_processed "webhook_processed"
  @webhook_received "webhook_received"

  def notify_subscribers(event), do: broadcast(@pubsub, @webhook_processed, {:event, event})
  def subscribe, do: subscribe(@pubsub, @webhook_processed)

  def subscribe_on_webhook_received, do: subscribe(@pubsub, @webhook_received)
end

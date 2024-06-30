defmodule StripeSetup.Billing.WebhookProcessor.Event do
  import Phoenix.PubSub, only: [subscribe: 2, broadcast: 3]

  @pubsub StripeSetup.PubSub

  def subscribe_on_webhook_recieved, do: subscribe(@pubsub, "webhook_received")
  def subscribe, do: subscribe(@pubsub, "webhook_processed")

  def notify_subscribers(event), do: broadcast(@pubsub, "webhook_processed", {:event, event})
end

defmodule StripeSetup.Billing.WebhookProcessor.Impl do
  alias StripeSetup.Billing.WebhookProcessor.Event
  alias StripeSetup.Billing.Synchronize.Plans
  alias StripeSetup.Billing.Synchronize.Products

  def sync_event(event) do
    Event.notify_subscribers(event)

    sync(event.type)
    |> dbg()
  end

  def subscribe_on_webhook_received, do: Event.subscribe_on_webhook_received()

  defp sync("product.created"), do: Products.run()
  defp sync("product.deleted"), do: Products.run()
  defp sync("plan.created"), do: Plans.run()
  defp sync("plan.updated"), do: Plans.run()
  defp sync("plan.deleted"), do: Plans.run()
  defp sync("customer.deleted"), do: nil
  defp sync("customer.updated"), do: nil
  defp sync("customer.created"), do: nil
  defp sync("customer.subscription.updated"), do: nil
  defp sync("customer.subscription.deleted"), do: nil
  defp sync("customer.subscription.created"), do: nil
  defp sync(_), do: nil

  #   def handle_info(%{event: event}, state) do
  # notify_subscribers(event)
  # case event.type do
  # # ...other code
  # "customer.subscription.updated" -> HandleSubscriptions.update_subscription(event.data.object)
  # "customer.subscription.deleted" -> HandleSubscriptions.update_subscription(event.data.object)
  # "customer.subscription.created" -> HandleSubscriptions.create_subscription(event.data.object)
  # _ -> nil
  # end
  # end
end

defmodule StripeSetup.Billing.WebhookProcessor.Impl do
  alias StripeSetup.Billing.WebhookProcessor.Event
  alias StripeSetup.Billing.SynchronizeProducts
  alias StripeSetup.Billing.SynchronizePlans

  def sync_event(event) do
    Event.notify_subscribers(event)
    sync(event.type)
  end

  def subscribe_on_webhook_recieved, do: Event.subscribe_on_webhook_recieved()

  defp sync("product.created"), do: SynchronizeProducts.run()
  defp sync("product.deleted"), do: SynchronizeProducts.run()
  defp sync("plan.created"), do: SynchronizePlans.run()
  defp sync("plan.updated"), do: SynchronizePlans.run()
  defp sync("plan.deleted"), do: SynchronizePlans.run()
  defp sync("customer.deleted"), do: nil
  defp sync("customer.updated"), do: nil
  defp sync("customer.created"), do: nil
  defp sync("customer.subscription.updated"), do: nil
  defp sync("customer.subscription.deleted"), do: nil
  defp sync("customer.subscription.created"), do: nil
  defp sync(_), do: nil
end

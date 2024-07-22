defmodule StripeSetupWeb.SubscriptionLive.New do
  use StripeSetupWeb, :live_view
  alias StripeSetup.Billing
  @public_key Application.compile_env(:stripity_stripe, :public_key)

  def mount(_, _, socket) do
    customer = Billing.get_billing_customer_for_user(socket.assigns.current_user.id)
    Billing.subscribe_process_webhook(customer.stripe_id)
    products = Billing.list_plans_for_subscription_page()

    socket =
      socket
      |> assign(:customer, customer)
      |> assign(:products, products)
      |> assign(:error_message, nil)
      |> assign(:loading, false)
      |> assign(:retry, false)
      |> assign(:public_key, @public_key)

    {:ok, socket}
  end

  def handle_event(
        "payment_method_created",
        %{"paymentMethod" => %{"id" => payment_method_id}},
        socket
      ) do
    customer_stripe_id = socket.assigns.customer.stripe_id
    Billing.create_and_attach_payment_method(customer_stripe_id, payment_method_id)
    {:noreply, socket}
  end

  def handle_event("is_loading", %{"loading" => loading}, socket) do
    {:noreply, assign(socket, :loading, loading)}
  end

  def handle_info({:event, event}, socket) do
    IO.inspect("listen!!")

    case event.type do
      # "payment_method.attached" ->
      #   if socket.assigns.retry do
      #     {:noreply, socket}
      #   else
      #     create_subscription(socket)
      #   end
      "payment_intent.requires_action" -> requires_action(event.data.object, socket)
      "payment_intent.payment_failed" -> payment_failed(socket)
      "invoice.payment_succeeded" -> payment_succeeded(socket)
      _ -> {:noreply, socket}
    end
  end

  defp requires_action(payment_intent, socket) do
    {
      :noreply,
      socket
      |> push_event(
        "requires_action",
        %{
          client_secret: payment_intent.client_secret,
          payment_method_id: payment_intent.payment_method
        }
      )
    }
  end

  defp payment_failed(socket) do
    {
      :noreply,
      socket
      |> assign(:loading, false)
      |> assign(:error_message, "There was an error processing this card.")
    }
  end

  defp payment_succeeded(socket) do
    {
      :noreply,
      socket
      |> assign(:loading, false)
      |> assign(:error_message, nil)
      |> put_flash(:info, "The subscription was created successfully.")
      |> redirect(to: Routes.user_settings_path(socket, :edit))
    }
  end

  # defp create_subscription(socket) do
  #   %{customer: customer, plan_id: plan_id} = socket.assigns
  #   price_stripe_id = Billing.get_plan!(plan_id).stripe_id

  #   {:ok, subscription} =
  #     @stripe_service.Subscription.create(%{
  #       customer: customer.stripe_id,
  #       items: [%{price: price_stripe_id}]
  #     })

  #   {:ok, invoice} = @stripe_service.Invoice.retrieve(subscription.latest_invoice)
  #   {:ok, _payment_intent} = @stripe_service.PaymentIntent.retrieve(invoice.payment_intent, %{})
  #   {:noreply, socket}
  # end
end

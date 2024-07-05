defmodule StripeSetupWeb.Stripe.WebhookControllerTest do
  use StripeSetupWeb.ConnCase, async: true
  import StripeSetup.CustomerFixtures

  def set_incorrect_signature_and_body(%{conn: conn}) do
    conn =
      conn
      |> assign(:raw_body, "")
      |> assign(:stripe_signature, "wrong_signature")

    %{conn: conn}
  end

  def set_correct_signature_and_body(%{conn: conn}) do
    conn =
      conn
      |> assign(:raw_body, "")
      |> assign(:stripe_signature, "valid_signature")

    %{conn: conn}
  end

  describe "receives webhook from stripe wihtou signature or raw_body" do
    setup [:set_incorrect_signature_and_body]

    test "renders response when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/stripe/webhooks", customer_created())
      assert conn.status == 201
    end

    test "does  not call the stripe service", %{conn: conn} do
      post(conn, ~p"/api/stripe/webhooks", customer_created())
      assert_received {:ok, "invalid_webhook"}
    end
  end

  describe "correct" do
    setup [:set_correct_signature_and_body]

    test "renders response when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/stripe/webhooks", customer_created())
      assert conn.status == 201
    end

    test "does  not call the stripe service", %{conn: conn} do
      post(conn, ~p"/api/stripe/webhooks", customer_created())
      assert_received {:ok, "valid_webhook"}
    end
  end
end

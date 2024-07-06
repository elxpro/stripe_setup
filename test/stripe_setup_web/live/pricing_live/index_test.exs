defmodule StripeSetupWeb.PricingLive.IndexTest do
  use StripeSetupWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import MockStripe, only: [token: 0]
  alias StripeSetup.Billing.Products
  alias StripeSetup.Billing.Plans

  setup [:setup_products_and_plans]

  describe "render/1" do
    test "renders log in page", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/pricings")
      assert has_element?(lv, "h1", "Plans & Pricing")
      assert has_element?(lv, "div", "$9.00")
      assert has_element?(lv, "div", "$19.00")
      assert has_element?(lv, "div>span", "per month")
      refute has_element?(lv, "div>span", "per year")
      # open_browser(lv, &System.cmd("wslview", [&1]))
    end
  end

  describe "handle_params/3" do
    test "renders log in page", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/pricings")
      assert has_element?(lv, "div>span", "per month")
      refute has_element?(lv, "div>span", "per year")

      lv
      |> element("a[href=\"/pricings?interval=year\"]")
      |> render_click()

      assert_patched(lv, "/pricings?interval=year")

      refute has_element?(lv, "div>span", "per month")
      assert has_element?(lv, "div>span", "per year")

      lv
      |> element("a[href=\"/pricings?interval=month\"]")
      |> render_click()

      assert has_element?(lv, "div>span", "per month")
      refute has_element?(lv, "div>span", "per year")

      assert_patched(lv, "/pricings?interval=month")
    end
  end

  def setup_products_and_plans(_) do
    products_data()
    |> Enum.each(fn %{
                      stripe_id: stripe_id,
                      stripe_product_name: stripe_product_name,
                      plans: plans
                    } ->
      {:ok, product} =
        Products.create_product(%{stripe_id: stripe_id, stripe_product_name: stripe_product_name})

      plans
      |> Enum.each(fn plan_attrs ->
        Plans.create_plan(product, plan_attrs)
      end)
    end)

    :ok
  end

  defp products_data do
    [
      %{
        plans: [
          %{
            amount: 9900,
            stripe_id: "price_#{token()}",
            stripe_plan_name: "year"
          },
          %{
            amount: 900,
            stripe_id: "price_#{token()}",
            stripe_plan_name: "month"
          }
        ],
        stripe_id: "prod_#{token()}",
        stripe_product_name: "Standard Plan"
      },
      %{
        plans: [
          %{
            amount: 1900,
            stripe_id: "price_#{token()}",
            stripe_plan_name: "month"
          },
          %{
            amount: 19900,
            stripe_id: "price_#{token()}",
            stripe_plan_name: "year"
          }
        ],
        stripe_id: "prod_#{token()}",
        stripe_product_name: "Premium Plan"
      }
    ]
  end
end

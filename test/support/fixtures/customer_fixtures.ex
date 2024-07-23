defmodule StripeSetup.CustomerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `StripeSetup.Billing` context.
  """
  import StripeSetup.AccountsFixtures

  @doc """
  Generate a customer.
  """
  def customer_fixture(attrs \\ %{}) do
    user_id = user_fixture().id

    {:ok, customer} =
      attrs
      |> Enum.into(%{
        default_source: "some default_source",
        stripe_id: Ecto.UUID.generate(),
        user_id: Map.get(attrs, :user_id, user_id)
      })
      |> StripeSetup.Billing.Customers.create_customer()

    customer
  end

  def customer_created() do
    %{
      "api_version" => "2020-03-02",
      "created" => 1_720_177_234,
      "data" => %{
        "object" => %{
          "address" => nil,
          "balance" => 0,
          "created" => 1_720_177_234,
          "currency" => nil,
          "default_currency" => nil,
          "default_source" => nil,
          "delinquent" => false,
          "description" => nil,
          "discount" => nil,
          "email" => "dsafl@dsfs.com",
          "id" => "cus_QPzsfp6MWOxVfq",
          "invoice_prefix" => "6A4E4CAE",
          "invoice_settings" => %{
            "custom_fields" => nil,
            "default_payment_method" => nil,
            "footer" => nil,
            "rendering_options" => nil
          },
          "livemode" => false,
          "metadata" => %{},
          "name" => nil,
          "next_invoice_sequence" => 1,
          "object" => "customer",
          "phone" => nil,
          "preferred_locales" => [],
          "shipping" => nil,
          "sources" => %{
            "data" => [],
            "has_more" => false,
            "object" => "list",
            "total_count" => 0,
            "url" => "/v1/customers/cus_QPzsfp6MWOxVfq/sources"
          },
          "subscriptions" => %{
            "data" => [],
            "has_more" => false,
            "object" => "list",
            "total_count" => 0,
            "url" => "/v1/customers/cus_QPzsfp6MWOxVfq/subscriptions"
          },
          "tax_exempt" => "none",
          "tax_ids" => %{
            "data" => [],
            "has_more" => false,
            "object" => "list",
            "total_count" => 0,
            "url" => "/v1/customers/cus_QPzsfp6MWOxVfq/tax_ids"
          },
          "test_clock" => nil
        }
      },
      "id" => "evt_1PZ9sUFrkHcGdHmpMqVekRy9",
      "livemode" => false,
      "object" => "event",
      "pending_webhooks" => 2,
      "request" => %{
        "id" => "req_3SJlHYLmYI4i12",
        "idempotency_key" => "7767127a-794a-470d-8a19-7b273ec76cb1"
      },
      "type" => "customer.created"
    }
  end
end

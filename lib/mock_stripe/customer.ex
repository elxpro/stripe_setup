defmodule MockStripe.Customer do
  alias MockStripe.List

  defstruct [
    :id,
    :created,
    :name,
    :object,
    :default_source,
    :email
  ]

  def create(attrs \\ %{}) do
    {:ok, Map.merge(retrieve(), attrs)}
  end

  def update(customer_Stripe_id, attrs) do
    {:ok,
     retrieve()
     |> Map.merge(%{id: customer_Stripe_id})
     |> Map.merge(attrs)}
  end

  def retrieve, do: retrieve("cus_#{MockStripe.token()}")

  def retrieve("cus_" <> _ = stripe_id) do
    %__MODULE__{
      id: stripe_id,
      object: "customer",
      created: 1_597_085_304,
      name: "elxpro 5",
      email: "adm@elxpro.com"
    }
  end

  def list(_ \\ %{}) do
    {:ok,
     %List{
       data: [retrieve()],
       object: "list",
       has_more: false,
       total_count: nil,
       url: "/v1/customers"
     }}
  end
end

defmodule MockStripe.Product do
  alias MockStripe.List

  defstruct [
    :id,
    :created,
    :name,
    :object,
    :updated
  ]

  @product_id "prod_#{MockStripe.token()}"

  def retrieve, do: retrieve(@product_id)

  def get_product_id(), do: @product_id

  def retrieve("prod_" <> _ = stripe_id) do
    %__MODULE__{
      id: stripe_id,
      object: "product",
      created: 1_597_085_304,
      name: "pumpkin 5",
      updated: 1_719_747_375
    }
  end

  def list(_ \\ %{}) do
    {:ok,
     %List{
       data: [retrieve()],
       object: "list",
       has_more: false,
       total_count: nil,
       url: "/v1/products"
     }}
  end
end

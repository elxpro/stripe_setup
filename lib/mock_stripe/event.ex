defmodule MockStripe.Event do
  defstruct [
    :id,
    :data,
    :request,
    :type
  ]

  def generate(attrs \\ %{}) do
    %__MODULE__{
      id: "evt_#{MockStripe.token()}",
      data: %{object: %{id: "123"}},
      request: %{
        id: "req_#{MockStripe.token()}",
        idempotency_key: MockStripe.token()
      },
      type: "payment_intent.created"
    }
    |> Map.merge(attrs)
  end
end

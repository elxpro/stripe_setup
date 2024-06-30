defmodule MockStripe.Event do
  defstruct [
    :id,
    :object,
    :request,
    :type
  ]

  def generate(attrs \\ %{}) do
    %__MODULE__{
      id: "evt_#{MockStripe.token()}",
      object: "event",
      request: %{
        id: "req_#{MockStripe.token()}",
        idempotency_key: MockStripe.token()
      },
      type: "payment_intent.created"
    }
    |> Map.merge(attrs)
  end
end

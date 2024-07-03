defmodule MockStripe.Plan do
  alias MockStripe.List

  defstruct [
    :id,
    :object,
    :active,
    :aggregate_usage,
    :amount,
    :amount_decimal,
    :billing_scheme,
    :created,
    :currency,
    :interval,
    :interval_count,
    :livemode,
    :metadata,
    :nickname,
    :product,
    :tiers,
    :tiers_mode,
    :transform_usage,
    :trial_period_days,
    :usage_type,
    :name
  ]

  def retrieve, do: retrieve("price_#{MockStripe.token()}")

  def retrieve("price_" <> _ = stripe_id) do
    %__MODULE__{
      active: true,
      name: "premium",
      amount: 9900,
      amount_decimal: "9000",
      currency: "usd",
      id: stripe_id,
      interval: "year",
      interval_count: 1,
      nickname: "one year access",
      object: "plan",
      product: "prod_12lkjksldfsd",
      usage_type: "licensed"
    }
  end

  def list(_ \\ %{}) do
    {:ok,
     %List{
       data: [retrieve()],
       object: "list",
       has_more: false,
       total_count: nil,
       url: "/v1/plans"
     }}
  end
end

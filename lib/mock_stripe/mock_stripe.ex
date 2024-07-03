defmodule MockStripe do
  def token do
    :crypto.strong_rand_bytes(25)
    |> Base.url_encode64()
    |> binary_part(0, 25)
    |> String.replace(~r/(_|-)/, "")
    |> String.slice(0..13)
  end
end

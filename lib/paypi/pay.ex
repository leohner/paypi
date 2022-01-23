defmodule Paypi.Pay do
  alias Paypi.Validate

  def pay(order_id, amount, payment_key) do
    {order_status, order_id} = order_id |> Validate.check_order_exists()
    {amount_status, amount} = amount |> Validate.check_payment_amount()
    {key_status, payment_key} = Validate.check_payment_key(order_id, payment_key)
  end
end

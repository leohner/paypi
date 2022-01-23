defmodule Paypi.Get do
  alias Paypi.Validate
  alias Paypi.Data

  def get_order(order_id)
      when is_integer(order_id)
      and order_id > 0 do
    order_id |> Validate.check_order_exists()
  end

  def get_orders(email) do
    orders = email |> Data.get_orders_for_customer()
    {:ok, orders}
  end
end

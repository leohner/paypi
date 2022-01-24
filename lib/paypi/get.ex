defmodule Paypi.Get do
  alias Paypi.Data
  alias Paypi.Store
  alias Paypi.Validate

  def get_order(order_id)
      when is_integer(order_id)
      and order_id > 0 do
    order_id
      |> Validate.check_order_exists()
  end

  def get_order(order_id) when is_binary(order_id) do
    order_id |> Validate.check_order_exists()
  end

  def get_order(_invalid_input) do
    Store.set_id_valid(:false)
  end

  def get_orders(email) do
    orders = email |> Data.get_orders_for_customer()
    {:ok, orders}
  end


#  defp get_order_payments({:ok, _success_message}) do
#    Store.get_order_id()
#      |> Data.get_order_payments()
#  end

  # non-integer value submitted
#  defp get_order_payments({_bad_status, _message}) do
#    # nothing to do
#  end
end

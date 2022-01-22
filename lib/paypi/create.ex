defmodule Paypi.Create do
  alias Paypi.Data
  alias Paypi.Validate

  def create_order({customer_id, order_value}) do
    {customer_status, id} = Validate.check_customer_exists(customer_id)
    {order_value_status, value} = Validate.check_order_value(order_value)

    create_order(customer_status, order_value_status, id, value)
  end

  defp create_order(:ok, :ok, customer_id, order_value) do
    Data.create_order(customer_id, order_value)
  end

  defp create_order(:error, _, _, _) do
    IO.puts "Customer id provided isn't an integer"
  end

  defp create_order(:not_found, _, _, _) do
    IO.puts "Invalid customer id"
  end

  defp create_order(_, :error, _, _) do
    IO.puts "Order Value isn't valid"
  end
end

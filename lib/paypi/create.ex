defmodule Paypi.Create do
  alias Paypi.Data
  alias Paypi.Validate

  def create_order({customer_id, order_amount}) do
    {customer_status, customer_id} = customer_id |> Validate.check_customer_exists()
    {order_amount_status, order_amount} = order_amount |> Validate.check_order_amount()

    create_order(customer_status, order_amount_status, customer_id, order_amount)
  end

  defp create_order(:ok, :ok, customer_id, order_amount) do
    Data.create_order(customer_id, order_amount)
  end

  defp create_order(:error, _, _, _) do
    {:error, "Customer ID provided is not an integer"}
  end

  defp create_order(:not_found, _, _, _) do
    {:error, "Invalid customer id"}
  end

  defp create_order(_, :error, _, _) do
    {:error, "Order amount isn't valid"}
  end
end

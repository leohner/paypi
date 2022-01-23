defmodule Paypi.Create do
  alias Paypi.Data
  alias Paypi.Validate

  def create_order(customer_id, order_amount) do
    {customer_status, customer_id} = Validate.check_customer_exists(customer_id)
    {order_amount_status, order_amount} = Validate.check_order_amount(order_amount)

    IO.inspect customer_status
    IO.inspect customer_id

    # create_order(customer_status, order_amount_status, customer_id, order_amount)
  end

  ## ***
  ## Private Functions
  ## ***

  defp create_order_step_2(:ok, :ok, customer_id, order_amount) do
    Data.create_order(customer_id, order_amount)
  end

  defp create_order_step_2(:error, _, _, _) do
    {:error, "Customer ID provided is not an integer"}
  end

  defp create_order_step_2(:not_found, _, _, _) do
    {:error, "Invalid customer id"}
  end

  defp create_order_step_2(_, :error, _, _) do
    {:error, "Order amount isn't valid"}
  end
end

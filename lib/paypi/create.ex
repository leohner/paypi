defmodule Paypi.Create do
  alias Paypi.Data
  alias Paypi.Store
  alias Paypi.Validate

  def create_order(customer_id, order_amount) do
    Validate.check_customer_exists(customer_id)
    Validate.check_order_amount(order_amount)

    result_status = Store.get_result_status()
    result_message = Store.get_result_message()
    customer_id = Store.get_customer_id()
    order_amount = Store.get_order_amount()

    create_order_step_2(result_status, result_message, customer_id, order_amount)
  end

  ## ***
  ## Private Functions
  ## ***

  defp create_order_step_2(:ok, _message, customer_id, order_amount) do
    Data.create_order(customer_id, order_amount)
  end

  defp create_order_step_2(_bad_status, _, _, _) do
    # no further action required - error messages and info already in agent
  end
end

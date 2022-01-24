defmodule Paypi.Create do
  alias Paypi.Data
  alias Paypi.Store
  alias Paypi.Validate


  def create_order(customer_id, order_amount, run_validation \\ :true) do

    run_validation(customer_id, order_amount, run_validation)

    id_valid = Store.get_id_valid()
    order_amount_valid = Store.get_order_amount_valid()
    customer_id = Store.get_customer_id()
    order_amount = Store.get_order_amount()

    create_order_step_2(id_valid, order_amount_valid, customer_id, order_amount)
    :ok
  end

  ## ***
  ## Private Functions
  ## ***

  defp run_validation(customer_id, order_amount, :true) do
    Validate.check_customer_exists(customer_id)
    Validate.check_order_amount(order_amount)
    :ok
  end

  defp run_validation(_, _, :false) do
    # don't run validation - used when validation has already been performed during create and pay
    :ok
  end

  defp create_order_step_2(:true, :true, customer_id, order_amount) do
    Data.create_order(customer_id, order_amount)
    :ok
  end

  # if either id or order amount is not valid, we can't proceed
  defp create_order_step_2(_, _, _, _) do
    # no further action required
    :ok
  end
end

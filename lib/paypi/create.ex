defmodule Paypi.Create do
  @moduledoc """
  Documentation for Paypi.Create.

  Handles basic creation routing. Refers to Paypi.Data for actual creation functions.
  """

  alias Paypi.Data
  alias Paypi.Store
  alias Paypi.Validate


  @doc """
  Attempts to create an order based on provided customer id and order amount
  """
  def create_order(customer_id, order_amount) do
    # Checks customer id and order amounts and stores results to Paypi.Store agent
    Validate.check_customer_exists(customer_id)
    Validate.check_order_amount(order_amount)

    # Get customer id and order amount validity
    is_customer_id_valid = Store.get_customer_id_valid()
    is_order_amount_valid = Store.get_order_amount_valid()

    # Get parsed versions of customer id and order amount
    customer_id = Store.get_customer_id()
    order_amount = Store.get_order_amount()

    # Attempt to proceed to step 2 based on validity
    create_order_step_2(is_customer_id_valid, is_order_amount_valid, customer_id, order_amount)
  end

  ## ***
  ## Private Functions
  ## ***

  # When both customer id and order amount are valid, attempt to create the order
  defp create_order_step_2(:true, :true, customer_id, order_amount) do
    Data.create_order(customer_id, order_amount)
    :ok
  end

  # If either id or order amount is not valid, we can't proceed
  defp create_order_step_2(_, _, _, _) do
    # no further action required
    :ok
  end
end

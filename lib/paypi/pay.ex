defmodule Paypi.Pay do
  @moduledoc """
  Documentation for Paypi.Pay.

  Handles basic payment routing.
  """

  alias Paypi.Create
  alias Paypi.Data
  alias Paypi.Store
  alias Paypi.Validate


  @doc """
  Attempts to apply a payment for a provided order id
  """
  def pay(order_id, payment_amount, payment_key) do
    # Validate order id, payment amount, and payment key
    order_id |> Validate.check_order_exists()
    payment_amount |> Validate.check_payment_amount()
    payment_key |> Validate.check_payment_key(order_id)

    # Get validity of order id, payment amount, and payment key
    is_order_id_valid = Store.get_order_id_valid()
    is_payment_amount_valid = Store.get_payment_amount_numerically_valid()
    is_payment_key_valid = Store.get_payment_key_valid()

    # Get validated order id and check if the payment is valid
    order_id = Store.get_order_id()
    is_payment_valid = payment_valid?(is_order_id_valid, payment_amount, order_id)

    # Attempt to submit the payment
    submit_payment(is_order_id_valid, is_payment_amount_valid, is_payment_key_valid, is_payment_valid)
  end


  @doc """
  Attempts to create an order and apply a payment for provide customer id
  """
  def order_and_pay(customer_id, order_amount, payment_amount) do
    # Validate customer id and order amount
    customer_id |> Validate.check_customer_exists()
    order_amount |> Validate.check_order_amount()

    # Get validity of customer id and order amount
    is_customer_id_valid = Store.get_customer_id_valid()
    is_order_amount_valid = Store.get_order_amount_valid()

    # Attempt to proceed to step 2
    order_and_pay_step_2(is_customer_id_valid, is_order_amount_valid, payment_amount)
  end



  ## ***
  ### Private Functions
  ## ***

  # If all values passed are true
  defp submit_payment(:true, :true, :true, :true) do
    # Get the order amount and attempt to add the payment
    Data.get_order_amount()
    Data.add_payment()
    :ok
  end

  # If even one of the values is not true, fail the entire transaction
  defp submit_payment(_id_valid, _amount_valid, _payment_key_valid, _is_payment_valid) do
    # don't submit payment
    :ok
  end


  # When custoemr id and order amount are valid, store the values and atetmpt to create an order
  defp order_and_pay_step_2(customer_id_valid, order_amount_valid, payment_amount)
      when customer_id_valid == :true
      and order_amount_valid == :true do
    customer_id = Store.get_customer_id()
    order_amount = Store.get_order_amount()

    Create.create_order(customer_id, order_amount)

    # Get the order id we just created to validate payment key
    payment_key = Store.get_payment_key()
    order_id = Store.get_order_id()
    payment_key |> Validate.check_payment_key(order_id)
    is_payment_key_valid = Store.get_payment_key_valid()

    # Run mock functionality to simulate random server error
    get_server_status()
      |> order_and_pay_step_3(payment_amount, is_payment_key_valid)
  end

  # If customer id and order id aren't both valid, we can't continue
  defp order_and_pay_step_2(_customer_id_valid, _order_id_valid, _payment_amount) do
    # no action taken
    :ok
  end


  # If no server failure occurred, make note of it and run more validation
  defp order_and_pay_step_3(:success, payment_amount, is_payment_key_valid)
      when is_payment_key_valid == :true do
    Store.set_did_server_crash(:false)
    Validate.check_payment_amount(payment_amount)

    # Get validity statuses based on current values
    order_id = Store.get_order_id()
    is_amount_valid = Store.get_payment_amount_numerically_valid()
    is_payment_key_valid = Store.get_payment_key_valid()
    is_payment_valid = payment_valid?(:true, payment_amount, order_id)

    # If we've made it this far, we know the order id is valid, so only the remaining are required
    submit_payment(:true, is_amount_valid, is_payment_key_valid, is_payment_valid)
  end

  # If the payment key has already been used, we can't proceed
  defp order_and_pay_step_3(:success, _payment_amount, is_payment_key_valid)
      when is_payment_key_valid == :false do
    Store.set_did_server_crash(:false)
    :ok
  end

  # If a server failure occurred, fetch the most recent order (the one added in order_and_pay_step_2) and delete it as a rollback
  defp order_and_pay_step_3(:failure, _payment_amount, _is_payment_key_valid) do
    Store.set_did_server_crash(:true)

    Store.get_customer_id()
      |> Data.get_most_recent_order_id()
      |> Data.delete_order_by_id()
  end


  # Get a random server status
  defp get_server_status() do
		# Fail about 25% of the time
		[:success, :success, :success, :failure]
			|> Enum.shuffle()
			|> hd()
	end

  # Determine if a payment is valid
  defp payment_valid?(id_valid, payment_amount, order_id)
      when is_number(payment_amount)
      and is_integer(order_id)
      and id_valid == :true do

    Data.get_order_payments()
    Data.get_order_amount()

    order_amount = Store.get_order_amount()

    # Calculate total payments made and remaining balance
    total_payments =
      Store.get_order_payments()
        |> Enum.sum()

    remaining_balance = order_amount - total_payments

    parse_remaining_balance(remaining_balance, payment_amount)
  end

  # Default case - payment is not valid
  defp payment_valid?(_id_valid, _payment_amount, _invalid_order_id) do
    :false
  end

  # Calculate new remaining balance when remaining balance - payment amount >= 0
  defp parse_remaining_balance(remaining_balance, payment_amount)
      when is_number(remaining_balance)
      and is_number(payment_amount)
      and remaining_balance - payment_amount >= 0 do

    remaining_balance = remaining_balance - payment_amount
    Store.set_remaining_balance(remaining_balance)
    Store.set_is_payment_valid(:true)
    :true
  end

  # If the above match failed, we can't have a valid payment
  defp parse_remaining_balance(_remaining_balance, _payment_amount) do
    Store.set_is_payment_valid(:false)
    :false
  end
end

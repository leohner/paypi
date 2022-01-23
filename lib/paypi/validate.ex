defmodule Paypi.Validate do
  alias Paypi.Data
  alias Paypi.Store

  def check_customer_exists(customer_id) when is_integer(customer_id) do
    customer_id |> check_customer_id()
  end

  def check_customer_exists(customer_id) when is_binary(customer_id) do
    customer_id
      |> String.trim()
      |> Integer.parse()
      |> check_parse_result()
      |> check_customer_id()
  end

  # We can't continue because we have an invalid customer id
  def check_customer_exists(_invalid_input) do
    Store.set_result_status(:error)
    Store.set_result_message("Invalid Customer ID")
    Store.set_id_exists(:false)
  end

  def check_order_amount(order_amount)
      when is_number(order_amount)
      and order_amount > 0 do
    # convert order amount to float in case it's an integer and update store
    order_amount = order_amount / 1
    Store.set_order_amount(order_amount)

    {:ok, order_amount}
  end

  def check_order_amount(_order_amount) do
    message = "Invalid input. Need a number higher than 0"
    Store.set_result_status(:error)
    Store.set_result_message(message)

    {:error, message}
  end

  def check_order_exists(order_id) when is_integer(order_id) do
    order_id |> check_order_id()
  end

  def check_order_exists(order_id) when is_binary(order_id) do
    order_id
      |> String.trim()
      |> Integer.parse()
      |> check_parse_result()
      |> check_order_id()
  end

  def check_payment_key(order_id, payment_key) do
    Data.get_order_with_payment_key(order_id, payment_key)
  end

  def check_payment_amount(amount)
      when is_number(amount)
      and amount > 0 do
    {:ok, amount / 1}
  end



  ## ***
  ## Private Functions
  ## ***

  # Parsing returns error if fails, so we need to standardize return
  defp check_parse_result(:error) do
    {:error, "Parse Error"}
  end

  # Parsing returns tuple if success, so we need to standardize return
  defp check_parse_result({result, _}) do
    {:ok, result}
  end



  # we've got an integer, so now we need to find a customer
  defp check_customer_id({:ok, customer_id}) do
    # update agent customer id to integer
    Store.set_customer_id(customer_id)
    customer_id |> Data.get_customer_by_id()
  end

  defp check_customer_id({:error, _invalid_input}) do
    message = "Invalid Customer ID"

    Store.set_result_status(:error)
    Store.set_result_message(message)
    Store.set_id_exists(:false)
  end

  defp check_customer_id(customer_id) do
    Store.set_customer_id(customer_id)
    customer_id |> Data.get_customer_by_id()
  end



  defp check_order_id({:error, _invalid_input}) do
    # cannot proceed, so set result status and message
    message = "Invalid Order ID"

    Store.set_result_status(:error)
    Store.set_result_message(message)
    Store.set_id_exists(:false)
  end

  defp check_order_id(order_id) do
    # update agent order id to integer
    Store.set_order_id(order_id)
    order_id |> Data.get_order_by_id()
  end
end

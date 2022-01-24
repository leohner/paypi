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
    Store.set_id_valid(:false)
  end

  def check_order_amount(order_amount)
      when is_number(order_amount)
      and order_amount > 0 do
    # convert order amount to float in case it's an integer and update store
    Store.set_order_amount_valid(:true)
    Store.set_order_amount(order_amount / 1)
    order_amount = order_amount / 1

    {:ok, order_amount}
  end

  def check_order_amount(_order_amount) do
    Store.set_order_amount_valid(:false)
    Store.set_payment_amount_numerically_valid(:false)
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

  def check_payment_key(payment_key, order_id) when is_integer(order_id) do
    Data.get_order_with_payment_key(order_id, payment_key)
  end

  # order id isn't an integer -- can't proceed
  def check_payment_key(_payment_key, _order_id) do
    :ok
  end

  def check_payment_amount(amount)
      when is_number(amount)
      and amount > 0 do

    Store.set_payment_amount_numerically_valid(:true)
  end

  def check_payment_amount(amount)
      when is_binary(amount) do
    amount
      |> String.trim()
      |> Float.parse()
      |> check_payment_parse_result()
  end

  def check_payment_amount(_invalid_amount) do
    Store.set_payment_amount_numerically_valid(:false)
  end



  ## ***
  ## Private Functions
  ## ***

  # Parsing returns error if fails, so we need to standardize return
  defp check_parse_result(:error) do
    Store.set_id_valid(:false)
    {:error, "Invalid ID"}
  end

  # Parsing returns tuple if success, so we need to standardize return
  defp check_parse_result({result, _}) do
    Store.set_id_valid(:true)
    {:ok, result}
  end


  defp check_payment_parse_result({amount, _}) do
    Store.set_payment_amount(amount / 1)
    Store.set_payment_amount_numerically_valid(:true)
  end

  defp check_payment_parse_result(:error) do
    Store.set_payment_amount_numerically_valid(:false)
  end



  # we've got an integer, so now we need to find a customer
  def check_customer_id({:ok, customer_id}) do
    # update agent customer id to integer
    Store.set_customer_id(customer_id)
    customer_id |> Data.get_customer_by_id()
  end

  def check_customer_id({:error, _invalid_input}) do
    Store.set_id_valid(:false)
  end

  def check_customer_id(customer_id) do
    Store.set_customer_id(customer_id)
    customer_id |> Data.get_customer_by_id()
  end


  # binary was passed and couldn't be converted to an integer
  defp check_order_id({:error, _invalid_input}) do
    # cannot proceed; set id to not valid
    Store.set_id_valid(:false)
  end

  # binary was passed and could be converted to an integer
  defp check_order_id({:ok, order_id}) do
    check_order_id(order_id)
  end

  # check integer version of order id
  defp check_order_id(order_id) do
    # update agent order id to integer
    Store.set_order_id(order_id)
    order_id |> Data.get_order_by_id()
  end
end

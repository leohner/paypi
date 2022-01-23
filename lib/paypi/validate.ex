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

  def check_customer_exists(_invalid_input) do
    # We can't continue because we have an invalid customer id
    Store.set_result_status(:error)
    Store.set_result_message("Invalid Customer ID")
  end

  def check_order_amount(order_amount)
      when is_number(order_amount)
      and order_amount > 0 do
    {:ok, order_amount / 1}
  end

  def check_order_amount(_order_amount) do
    Store.set_result_status(:error)
    Store.set_result_message("Invalid input. Need float between 0 and higher")
  end

  def check_order_exists(order_id) do
    status = order_id |> Data.get_order_by_id()
    {status, order_id}
  end

  def check_payment_key(order_id, payment_key) do
    IO.inspect Data.get_order_with_payment_key(order_id, payment_key)
  end

  def check_payment_amount(amount)
      when is_number(amount)
      and amount > 0 do
    {:ok, amount / 1}
  end

  ## ***
  ## Private Functions
  ## ***

  # Parsing returns error if fails, so we need to standardize output
  defp check_parse_result(:error) do
    {:error, "Parse Error"}
  end

  # Parsing returns tuple if success, so we need to standardize output
  defp check_parse_result({result, _}) do
    {:ok, result}
  end

  # we've got an integer, so now we need to find a customer
  defp check_customer_id({:ok, customer_id}) do
    customer_id |> Data.get_customer_by_id()
    #case Data.get_customer_by_id(id) do
    #  {:nil, _} -> {:not_found, "Customer Not Found"}
    #  {:ok, _} -> {:ok, id}
    #  _ -> {:error, "Non-Integer Provided"}
    #end
  end
end

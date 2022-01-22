defmodule Paypi.Validate do
  alias Paypi.Data

  def check_customer_exists(customer_id) when is_integer(customer_id) do
      {:ok, customer_id}
        |> check_customer_id()
  end

  def check_customer_exists(customer_id) when is_binary(customer_id) do
    customer_id
      |> String.trim()
      |> Integer.parse()
      |> check_parse_result()
      |> check_customer_id()
  end

  def check_order_value(order_value)
      when is_float(order_value)
      and order_value > 0 do
    {:ok, order_value}
  end

  def check_order_value(order_value)
      when is_integer(order_value)
      and order_value > 0 do
    {:ok, order_value / 1}
  end

  def check_order_value(_order_value) do
    {:error, "Invalid input. Need float between 0 and higher"}
  end


  defp check_parse_result(:error) do
    {:error, "Parse Error"}
  end

  defp check_parse_result({result, _}) do
    {:ok, result}
  end

  defp check_customer_id({:error, _id}) do
    {:error, "Non Integer Provided"}
  end

  # we've got an integer, so now we need to find a customer
  defp check_customer_id({:ok, id}) do
    case Data.get_customer_by_id(id) do
      :nil -> {:not_found, "Customer Not Found"}
      _ -> {:ok, id}
    end
  end
end

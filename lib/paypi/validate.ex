defmodule Paypi.Validate do
  def check_customer_exists(customer_id) when is_integer(customer_id) do
      customer_id
        |> check_customer_id()
  end

  def check_customer_exists(customer_id) when is_binary(customer_id) do
    customer_id
      |> String.trim()
      |> Integer.parse()
      |> check_integer_parse_result()
      |> check_customer_id()
  end

  # if Integer.parse was successful, we only need the integer
  defp check_integer_parse_result({value, _}) do
    value
  end

  # if Integer.parse couldn't parse an integer, data passed is bad
  defp check_integer_parse_result(:error) do
    :error
  end

  defp check_customer_id(:error) do
    IO.puts "Please provide an integer"
  end

  defp check_customer_id(id) do
    IO.puts "Checking for customer"
  end

end

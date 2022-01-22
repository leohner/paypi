defmodule Paypi do
  alias Paypi.Create
  @moduledoc """
  Documentation for `Paypi`.
  """

  def run({:create_order, customer_id, order_value}) do
    Create.create_order({customer_id, order_value})
  end

  def run() do
    IO.puts "No data provided"
  end
end

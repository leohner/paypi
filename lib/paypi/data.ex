defmodule Paypi.Data do
  alias Paypi.Schema.Customer
  alias Paypi.Schema.Order
  alias Paypi.Schema.Payment
  alias Paypi.Repo

  def get_customer_by_id(id) do
    Repo.get(Customer, id)
  end

  def create_order(customer_id, order_value) do
    result = Repo.insert(%Order{
      customer_id: customer_id,
      order_value: order_value
    })
    IO.inspect result
  end
end

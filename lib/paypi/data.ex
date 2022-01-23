defmodule Paypi.Data do
  import Ecto.Query, only: [from: 2]
  alias Paypi.Schema.Customer
  alias Paypi.Schema.Order
  alias Paypi.Schema.Payment
  alias Paypi.Store
  alias Paypi.Repo

  def create_order(customer_id, order_amount) do
    Repo.insert(%Order{
      customer_id: customer_id,
      order_amount: order_amount
    })
      |> parse_result()
  end


  ## Functions for Get (Select) operations

  def get_customer_by_id(customer_id) do
      Repo.get(Customer, customer_id)
        |> parse_result()
  end

  def get_order_by_id(order_id) do
    Repo.get(Order, order_id)
      |> parse_result()
  end



  # returns list of tuples with records; empty list if nothing found
  def get_orders_for_customer(email) do
    # inner join customer table to order table on customer id
    query = from o in Order,
          inner_join: c in Customer,
          on: c.id == o.customer_id,
          # ^ character interpolates variable in query
          where: c.email == ^email,
          select: {o.id, o.order_amount},
          order_by: [asc: o.id]

    Repo.all(query)
      |> parse_result()
  end



  def get_order_with_payment_key(order_id, payment_key) do
    Repo.get_by(Payment, [order_id: order_id, payment_key: payment_key])
      |> parse_result()
  end

  ## Payment functions

  def add_payment(order_id, amount, payment_key) do
    Repo.insert(%Payment{
      order_id: order_id,
      payment_amount: amount,
      payment_key: payment_key
    })
      |> parse_result()
  end


  ## Private Functions

  defp parse_result(:nil) do
    Store.set_result_status(:nil)
    Store.set_output(:nil)
    {:nil, "No results found"}
  end

  defp parse_result({status, output}) do
    status |> Store.set_result_status()
    output |> Store.set_output()

    {status, output}
  end
end

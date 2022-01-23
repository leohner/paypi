defmodule Paypi.Data do
  import Ecto.Query, only: [from: 2]
  alias Paypi.Schema.Customer
  alias Paypi.Schema.Order
  alias Paypi.Schema.Payment
  alias Paypi.Store
  alias Paypi.Repo

  ## ***
  ## Functions for Insert operations
  ## ***

  def create_order(customer_id, order_amount) do
    Repo.insert(%Order{
      customer_id: customer_id,
      order_amount: order_amount
    })
      |> parse_result()
  end



  def add_payment(order_id, amount, payment_key) do
    Repo.insert(%Payment{
      order_id: order_id,
      payment_amount: amount,
      payment_key: payment_key
    })
      |> parse_result()
  end




  ## ***
  ## Functions for Get (Select) operations
  ## ***

  def get_customer_by_id(customer_id) do
      Repo.get(Customer, customer_id)
        |> parse_result()
  end



  def get_order_by_id(order_id) do
    Repo.get(Order, order_id)
      |> parse_result()
      |> get_order_payments()
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
      #|> parse_result()
  end



  def get_order_with_payment_key(order_id, payment_key) do
    Repo.get_by(Payment, [order_id: order_id, payment_key: payment_key])
      #|> parse_result()
  end

  def get_order_payments(:ok) do
    Store.get_order_id() |> get_order_payments()
  end

  def get_order_payments(:error) do
    # no need to do anything; already handled by parse_result
  end

  def get_order_payments(order_id) do
    # inner join order table to payment table on order id
    query = from o in Order,
          inner_join: p in Payment,
          on: o.id == p.order_id,
          where: o.id == ^order_id,
          select: {p.id, p.payment_amount},
          order_by: [asc: p.id]

    Repo.all(query) |> Store.set_order_payments()
  end



  ## ***
  ## Private Functions
  ## ***

  defp parse_result(:nil) do
    message = "No results found"

    Store.set_result_status(:not_found)
    Store.set_result_message(message)
    Store.set_transaction_info(:nil)
    Store.set_id_exists(:false)

    :error
  end

  defp parse_result(info) do
    message = "Successfully found by ID"

    Store.set_result_status(:ok)
    Store.set_result_message(message)
    Store.set_transaction_info(info)
    Store.set_id_exists(:true)

    :ok
  end
end

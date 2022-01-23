defmodule Paypi.Data do
  import Ecto.Query, only: [from: 2]
  alias Paypi.Schema.Customer
  alias Paypi.Schema.Order
  alias Paypi.Schema.Payment
  alias Paypi.Repo

  def create_order(customer_id, order_amount) do
    Repo.insert(%Order{
      customer_id: customer_id,
      order_amount: order_amount
    })
  end


  ## Functions for Get (Select) operations

  def get_customer_by_id(customer_id) do
    Repo.get(Customer, customer_id)
  end



  def get_order_by_id(order_id) do
    Repo.get(Order, order_id)
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
  end



  def get_order_with_payment_key(order_id, payment_key) do
    Repo.get_by(Payment, [order_id: order_id, payment_key: payment_key])
  end

  ## Payment functions

  def add_payment(order_id, amount, payment_key) do
    Repo.insert(%Payment{
      order_id: order_id,
      payment_amount: amount,
      payment_key: payment_key
    })
  end
end

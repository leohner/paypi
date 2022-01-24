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


  def add_payment() do
    order_id = Store.get_order_id()
    amount = Store.get_payment_amount() / 1
    payment_key = Store.get_payment_key()

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


  def get_email_validity(email) do
    query = from c in Customer,
          where: c.email == ^email,
          select: {c.email},
          limit: 1

    Repo.one(query)
      |> parse_email_validity_results()
      |> Store.set_order_payments()
  end


  def get_email_by_order_id(order_id) do

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

  def get_most_recent_order_id(customer_id) do
    # inner join order table to payment table on order id
    query = from o in Order,
          where: o.customer_id == ^customer_id,
          select: {o.id},
          order_by: [desc: o.id],
          limit: 1

    Repo.one(query)
      |> parse_most_recent()
  end


  def get_order_amount() do
    order_id = Store.get_order_id()

    query = from o in Order,
          where: o.id == ^order_id,
          select: {o.order_amount},
          limit: 1

    Repo.one(query)
      |> parse_order_amount()
  end


  def get_order_with_payment_key(order_id, payment_key) do
    Repo.get_by(Payment, [order_id: order_id, payment_key: payment_key])
      |> parse_payment_key_result()
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
          select: {p.payment_amount},
          order_by: [asc: p.id]

    Repo.all(query) |> Store.set_order_payments()
  end

  def get_order_payments() do
    Store.get_order_id() |> get_order_payments()
  end


  ## ***
  ## Functions for Delete Operations
  ## ***
  def delete_order_by_id(order_id) do
    %Order{id: order_id} |> Repo.delete()
  end


  ## ***
  ## Private Functions
  ## ***

  # result is nil when a single select returns nothing
  defp parse_result(result) when result == :nil do
    Store.set_transaction_info(:nil)
    Store.set_id_valid(:false)
    :error
  end

  # if an empty list is returned as part of an all(), the query successfully ran, but nothing returned
  defp parse_result(result) when result == [] do
    Store.set_transaction_info(:nil)
    Store.set_id_valid(:true)
  end

  defp parse_result(info) do
    Store.set_transaction_info(info)
    Store.set_id_valid(:true)
    :ok
  end

  # no existing key matches for the order id - the payment hasn't been recorded yet
  defp parse_payment_key_result(:nil) do
    Store.set_payment_key_valid(:true)
  end

  # the order id already has a payment with the provided key - don't record payment
  defp parse_payment_key_result(_data) do
    Store.set_payment_key_valid(:false)
  end

  defp parse_order_amount({amount}) do
    Store.set_order_amount(amount)
  end

  defp parse_order_amount(:nil) do
    :ok
  end

  defp parse_most_recent({id}) do
    id
  end

  defp parse_email_validity_results({email}) do
    Store.set_email_valid(:true)
    Store.set_email(email)
    :true
  end

  defp parse_email_validity_results(:nil) do
    Store.set_email_valid(:false)
    Store.set_email(:nil)
    :false
  end

end

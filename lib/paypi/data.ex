defmodule Paypi.Data do
  @moduledoc """
  Documentation for Paypi.Data

  Handles database transactions.
  """

  import Ecto.Query, only: [from: 2]
  alias Paypi.Schema.Customer
  alias Paypi.Schema.Order
  alias Paypi.Schema.Payment
  alias Paypi.Store
  alias Paypi.Repo


  ## ***
  ## Functions for Insert operations
  ## ***

  @doc """
  Attempt to create an order based on a provided customer id and order amount
  """
  def create_order(customer_id, order_amount) do
    Repo.insert(%Order{
      customer_id: customer_id,
      order_amount: order_amount
    })
      |> parse_create_order_result()
  end


  @doc """
  Attempt to add a payment from order id, payment amount, and payment key held in Store agent
  """
  def add_payment() do
    order_id = Store.get_order_id()
    amount = Store.get_payment_amount() / 1
    payment_key = Store.get_payment_key()

    Repo.insert(%Payment{
      order_id: order_id,
      payment_amount: amount,
      payment_key: payment_key
    })
      |> parse_add_payment_result()
  end



  ## ***
  ## Functions for Get (Select) operations
  ## ***

  @doc """
  Attempt to get customer information from a provided customer id
  """
  def get_customer_by_id(customer_id) do
      Repo.get(Customer, customer_id)
        |> parse_customer_by_id_result()
  end


  @doc """
  Attempt to get order information from a provided order id
  """
  def get_order_by_id(order_id) do
    Repo.get(Order, order_id)
      |> parse_order_by_id_result()
      |> get_order_payments()
  end


  @doc """
  Get the validity of a passed email
  """
  def get_email_validity(email) do
    query = from c in Customer,
          where: c.email == ^email,
          select: {c.id, c.email},
          limit: 1

    Repo.one(query)
      |> parse_email_validity_results()
  end



  @doc """
  Get orders for a provided email.
  Note: an empty list is returned if nothing is found
  """
  def get_orders_for_customer(email)
      when not is_nil(email)
      and email != :false do

    # inner join customer table to order table on customer id
    query = from o in Order,
          inner_join: c in Customer,
          on: c.id == o.customer_id,
          # ^ character interpolates variable in query
          where: c.email == ^email,
          select: {o.id, o.order_amount},
          order_by: [asc: o.id]

    Repo.all(query)
      |> parse_orders_for_customer_result()
  end

  # When the email is either :nil or :false
  def get_orders_for_customer(email) do
    Store.set_email(email)
    Store.set_email_valid(:false)
  end


  @doc """
  Get the most recent order id for a customer
  """
  def get_most_recent_order_id(customer_id) do
    # inner join order table to payment table on order id
    query = from o in Order,
          where: o.customer_id == ^customer_id,
          select: o.id,
          order_by: [desc: o.id],
          limit: 1

    Repo.one(query)
      |> parse_most_recent_order_id()
  end


  @doc """
  Get the amount of an order held in the Store agent
  """
  def get_order_amount() do
    order_id = Store.get_order_id()

    query = from o in Order,
          where: o.id == ^order_id,
          select: {o.order_amount},
          limit: 1

    Repo.one(query)
      |> parse_order_amount()
  end


  @doc """
  Attempt to get an existing order payment with the provided payment key
  """
  def get_order_with_payment_key(order_id, payment_key) do
    Repo.get_by(Payment, [order_id: order_id, payment_key: payment_key])
      |> parse_payment_key_result()
  end


  @doc """
  Get order payments.
  """
  def get_order_payments(:ok) do
    Store.get_order_id() |> get_order_payments()
  end

  def get_order_payments(:error) do
    # No need to do anything; already handled by parse result
  end

  # Use passed order id to get list of payments
  def get_order_payments(order_id) do
    # Inner join order table to payment table on order id
    query = from p in Payment,
          where: p.order_id == ^order_id,
          select: p.payment_amount,
          order_by: [asc: p.id]

    Repo.all(query)|> Store.set_order_payments()
  end

  # If no payment is passed, try to get it from the Store agent
  def get_order_payments() do
    Store.get_order_id() |> get_order_payments()
  end


  ## ***
  ## Functions for Delete Operations
  ## ***

  @doc """
  Delete an order which has an id matching the passed id
  """
  def delete_order_by_id(order_id) do
    %Order{id: order_id} |> Repo.delete()
  end



  ## ***
  ## Private Functions
  ## ***


  # Order could not be created
  defp parse_create_order_result(result) when result == :nil do
    Store.set_order_id(:invalid)
    Store.set_order_id_valid(:false)
  end

  # Order could be created
  defp parse_create_order_result({:ok, result}) do
    get_customer_by_id(result.customer_id)
    get_most_recent_order_id(result.customer_id)
    Store.set_order_id_valid(:true)
  end


  # No results returned - order id doesn't exist
  defp parse_order_by_id_result(result) when result == :nil do
    #Store.set_order_id(:invalid)
    Store.set_order_id_valid(:false)
  end

  # Order id found
  defp parse_order_by_id_result(result) do
    get_customer_by_id(result.customer_id)
    get_order_payments()
    Store.set_order_id(result.id)
    Store.set_order_id_valid(:true)
    Store.set_order_amount(result.order_amount)
    Store.set_order_amount_valid(:true)

    # Return ok so we can pass into get_order_payments function
    :ok
  end


  # No matter what, orders will return at least an empty list
  defp parse_orders_for_customer_result(orders) when orders == [] do
    Store.set_orders(:empty)
  end

  # Capture the full list
  defp parse_orders_for_customer_result(orders) do
    Store.set_orders(orders)
  end


  # Parse results from passed customer by id query when query returned :nil
  defp parse_customer_by_id_result(result) when result == :nil do
    Store.set_customer_id(:invalid)
    Store.set_email(:invalid)
    Store.set_customer_id_valid(:false)
    Store.set_email_valid(:false)
  end

  # Parse results from passed customer by id query when query succeeded
  defp parse_customer_by_id_result(result) do
    Store.set_customer_id(result.id)
    Store.set_email(result.email)
    Store.set_customer_id_valid(:true)
    Store.set_email_valid(:true)
  end


  # No existing key matches for the order id - the payment hasn't been recorded yet
  defp parse_payment_key_result(:nil) do
    Store.set_payment_key_valid(:true)
  end

  # The order id already has a payment with the provided key - don't record payment
  defp parse_payment_key_result(_data) do
    Store.set_payment_key_valid(:false)
  end

  defp parse_order_amount({amount}) do
    Store.set_order_amount(amount)
  end

  defp parse_order_amount(:nil) do
    :ok
  end


  # Get most recent order id - need to return it also because of how various functions call it
  defp parse_most_recent_order_id(id) do
    Store.set_order_id(id)
    id
  end


  # If an email is not valid
  defp parse_email_validity_results(:nil) do
    Store.set_email_valid(:false)
    Store.set_customer_id_valid(:false)
    :false
  end

  # If an email is valid
  defp parse_email_validity_results({id, email}) do
    Store.set_customer_id_valid(:true)
    Store.set_customer_id(id)
    Store.set_email_valid(:true)
    Store.set_email(email)
    :true
  end


  # If a payment was able to be added
  defp parse_add_payment_result({:ok, result}) do
    Store.set_payment_id(result.id)
    Store.set_payment_amount(result.payment_amount)
    Store.set_payment_key(result.payment_key)
    Store.set_order_id(result.order_id)
  end

  # If a payment transaction failed
  defp parse_add_payment_result(_bad_return) do
    Store.set_payment_id(:nil)
  end

end

defmodule Paypi.Get do
  @moduledoc """
  Documentation for Paypi.Get

  Handles basic getting routing. Refers to Paypi.Validation and Paypi.Data to process routed values.
  """

  alias Paypi.Data
  alias Paypi.Store
  alias Paypi.Validate


  @doc """
  Gets an order from a passed order id
  """
  # If the order id is an integer greater than 0, check if the order id exists in the system
  def get_order(order_id)
      when is_integer(order_id)
      and order_id > 0 do
    order_id
      |> Validate.check_order_exists()
  end

  # If the order id is passed as a string, route it the same way, but it handles differently on the Validate side
  def get_order(order_id) when is_binary(order_id) do
    order_id |> Validate.check_order_exists()
  end

  # If an invalid input is supplied, update the Store agent to reflect that
  def get_order(_invalid_input) do
    Store.set_order_id_valid(:false)
  end



  @doc """
  Gets orders associated with a given email address.
  """
  # Validates email and attempts to get associated orders.
  def get_orders(email) when is_binary(email) do
    email |> Data.get_email_validity()
    Store.get_email() |> Data.get_orders_for_customer()
  end

  # If an email is not binary, it can't possibly be a valid email
  def get_orders(_email) do
    Store.set_email_valid(:false)
  end
end

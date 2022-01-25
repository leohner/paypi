defmodule Paypi do
  @moduledoc """
  Documentation for `Paypi` (pronounced Pay-Pea-Eye).

  The Paypi module acts as an entry point into the PayPI API application.
  It has one function that accepts a variety of parameters.
  See README for more information.
  """

  alias Paypi.Create
  alias Paypi.Get
  alias Paypi.Pay
  alias Paypi.Store


  @doc """
  Runs the application based on provided parameters.
  Accepts the following:
  - {:create_order, customer_id, order_amount}
  - {:get_order, order_id}
  - {:get_orders, email}
  - {:pay, order_id, payment_amount, payment_key}
  - {:create_pay, customer_id, order_amount, payment_amount, payment_key}

  All other requests will be routed as invalid.
  """
  def run({:create_order, customer_id, order_amount}) do
    # Store provided params in Agent
    params = %{action: :create_order, customer_id: customer_id, order_amount: order_amount}
    Store.start_link(params)

    # Attempt to create order with provided customer id and order amount
    Create.create_order(customer_id, order_amount)

    # Create payload based on information from Create.create_order()
    payload = generate_payload(:create_order)

    # Print payload to console for ease of viewing data and return payload
    IO.inspect payload
    payload
  end

  def run({:get_order, order_id}) do
    params = %{action: :get_order, order_id: order_id}
    Store.start_link(params)

    Get.get_order(order_id)

    payload = generate_payload(:get_order)

    # Print payload to console for ease of viewing data and return payload
    IO.inspect payload
    payload
  end

  def run({:get_orders, email}) do
    params = %{action: :get_orders, email: email}
    Store.start_link(params)

    Get.get_orders(email)

    payload = generate_payload(:get_orders)

    # Print payload to console for ease of viewing data and return payload
    IO.inspect payload
    payload
  end

  # in practice, the payment_key (used for idempotency) would be passed by the client to the API
  # for this demo, the payment key will be generated inside the run function to simulate the behavior
  # leaving the parameter in the function so that it can be tested when necessary
  def run({:pay, order_id, payment_amount, payment_key}) do
    payment_key = generate_payment_key(payment_key)
    params = %{action: :pay, order_id: order_id, payment_amount: payment_amount, payment_key: payment_key, payment_key_valid: :true}
    Store.start_link(params)

    Pay.pay(order_id, payment_amount, payment_key)

    payload = generate_payload(:pay)

    # Print payload to console for ease of viewing data and return payload
    IO.inspect payload
    payload
  end

  def run({:create_pay, customer_id, order_amount, payment_amount, payment_key}) do
    payment_key = generate_payment_key(payment_key)
    params = %{action: :create_pay, customer_id: customer_id, order_amount: order_amount, payment_amount: payment_amount, payment_key: payment_key, payment_key_valid: :true}
    Store.start_link(params)

    Pay.order_and_pay(customer_id, order_amount, payment_amount)

    payload = generate_payload(:create_pay)

    # Print payload to console for ease of viewing data and return payload
    IO.inspect payload
    payload
  end

  def run(_) do
    params = %{action: :invalid}
    Store.start_link(params)

    payload = generate_payload(:invalid)

    # Print payload to console for ease of viewing data and return payload
    IO.inspect payload
    payload
  end



  ## ***
  ## Private Functions
  ## ***

  # Normally, a payment key would provided from the client, but this will work for demo purposes
  # Generate a UUID with Ecto if the provided key is nil or is not a string
  defp generate_payment_key(key) when key == :nil or not is_binary(key) do
    Ecto.UUID.generate()
  end

  # When a payment is falls through and is a string, use it
  defp generate_payment_key(key) when is_binary(key) do
    key
  end

  # Createas a payload of information to return to the user
  defp generate_payload(action) do
    Store.generate_payload(action)
  end
end

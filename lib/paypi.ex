defmodule Paypi do
  alias Paypi.Store
  alias Paypi.Create
  alias Paypi.Get
  alias Paypi.Pay
  @moduledoc """
  Documentation for `Paypi` (pronounced Pay-Pea-Eye).
  """

  def run({:create_order, customer_id, order_amount}) do
    params = [action: :create_order, customer_id: customer_id, order_amount: order_amount]
    Store.start_link(params)

    Create.create_order(customer_id, order_amount)
  end

  def run({:get_order, order_id}) when is_integer(order_id) do
    params = [action: :get_order, order_id: order_id]
    Store.start_link(params)
    Store.get_action()

    Get.get_order(order_id)
  end

  def run({:get_orders, email}) when is_binary(email) do
    params = [action: :get_order, email: email]
    Store.start_link(params)

    Get.get_orders(email)
  end

  def run({:pay, order_id, amount, payment_key}) when is_integer(order_id) do
    params = [action: :pay, order_id: order_id, amount: amount, payment_key: payment_key]
    Store.start_link(params)

    Pay.pay(order_id, amount, payment_key)
  end

  def run(_) do
    IO.puts "Invalid data provided"
  end
end

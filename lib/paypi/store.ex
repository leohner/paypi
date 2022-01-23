defmodule Paypi.Store do
  use Agent

  def start_link(input_params) do
    Agent.start_link(fn -> input_params end, name: __MODULE__)
  end

  # add result status to the store
  def set_result_status(status) do
    Agent.update(__MODULE__, &Map.put(&1, :result_status, status))
  end

  # add result message to the store
  def set_result_message(message) do
    Agent.update(__MODULE__, &Map.put(&1, :result_message, message))
  end

  # add transaction information to the store
  def set_transaction_info(info) do
    Agent.update(__MODULE__, &Map.put(&1, :transaction_info, info))
  end

  def set_customer_id(customer_id) do
    Agent.update(__MODULE__, &Map.put(&1, :customer_id, customer_id))
  end

  def set_id_exists(id_exists) do
    Agent.update(__MODULE__, &Map.put(&1, :id_exists, id_exists))
  end

  def set_order_id(order_id) do
    Agent.update(__MODULE__, &Map.put(&1, :order_id, order_id))
  end

  def set_order_amount(order_amount) do
    Agent.update(__MODULE__, &Map.put(&1, :order_amount, order_amount))
  end

  def set_order_payments(payments) do
    Agent.update(__MODULE__, &Map.put(&1, :order_payments, payments))
  end

  def set_payment_amount(payment_amount) do
    Agent.update(__MODULE__, &Map.put(&1, :payment_amount, payment_amount))
  end

  # returns action, nil if not found
  def get_action() do
    Agent.get(__MODULE__, &(&1[:action]))
  end

  # returns customer id, nil if not found
  def get_customer_id() do
    Agent.get(__MODULE__, &(&1[:customer_id]))
  end

  # returns order id, nil if not found
  def get_order_id() do
    Agent.get(__MODULE__, &(&1[:order_id]))
  end

  # returns email, nil if not found
  def get_email() do
    Agent.get(__MODULE__, &(&1[:email]))
  end

  # returns order amount, nil if not found
  def get_order_amount() do
    Agent.get(__MODULE__, &(&1[:order_amount]))
  end

  def get_order_payments() do
    Agent.get(__MODULE__, &(&1[:order_payments]))
  end

  # returns payment amount, nil if not found
  def get_payment_amount() do
    Agent.get(__MODULE__, &(&1[:payment_amount]))
  end

  # returns payment key, nil if not found
  def get_payment_key() do
    Agent.get(__MODULE__, &(&1[:payment_key]))
  end

  # returns result status, nil if not found
  def get_result_status() do
    Agent.get(__MODULE__,&(&1[:result_status]))
  end

  # returns result message, nil if not found
  def get_result_message() do
    Agent.get(__MODULE__, &(&1[:result_message]))
  end

  # returns transaction info, nil if not found
  def get_transaction_info() do
    Agent.get(__MODULE__, &(&1[:transaction_info]))
  end

  def get_payments() do
    Agent.get(__MODULE__, &(&1[:payments]))
  end

  def print_everything() do
    IO.inspect Agent.get(__MODULE__, &(&1))
  end
end

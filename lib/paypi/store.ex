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

  def set_id_valid(is_valid) do
    Agent.update(__MODULE__, &Map.put(&1, :id_valid, is_valid))
  end

  def set_email(email) do
    Agent.update(__MODULE__, &Map.put(&1, :email, email))
  end

  def set_email_valid(is_valid) do
    Agent.update(__MODULE__, &Map.put(&1, :email_valid, is_valid))
  end

  def set_order_id(order_id) do
    Agent.update(__MODULE__, &Map.put(&1, :order_id, order_id))
  end

  def set_order_amount(order_amount) do
    Agent.update(__MODULE__, &Map.put(&1, :order_amount, order_amount))
  end

  def set_order_amount_valid(is_valid) do
    Agent.update(__MODULE__, &Map.put(&1, :order_amount_valid, is_valid))
  end

  def set_order_payments(payments) do
    Agent.update(__MODULE__, &Map.put(&1, :order_payments, payments))
  end

  def set_payment_amount(payment_amount) do
    Agent.update(__MODULE__, &Map.put(&1, :payment_amount, payment_amount))
  end

  def set_payment_amount_numerically_valid(is_valid) do
    Agent.update(__MODULE__, &Map.put(&1, :payment_amount_numerically_valid, is_valid))
  end

  def set_payment_key_valid(is_valid) do
    Agent.update(__MODULE__, &Map.put(&1, :payment_key_valid, is_valid))
  end

  def set_is_payment_valid(is_valid) do
    Agent.update(__MODULE__, &Map.put(&1, :is_payment_valid, is_valid))
  end

  def set_remaining_balance(balance) do
    Agent.update(__MODULE__, &Map.put(&1, :remaining_balance, balance))
  end

  def set_did_server_crash(crashed) do
    Agent.update(__MODULE__, &Map.put(&1, :did_server_crash, crashed))
  end

  # returns action, nil if not found
  def get_action() do
    Agent.get(__MODULE__, &(&1[:action]))
  end

  def get_id_valid() do
    Agent.get(__MODULE__, &(&1[:id_valid]))
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

  def get_email_valid() do
    Agent.get(__MODULE__, &(&1[:email_valid]))
  end

  # returns order amount, nil if not found
  def get_order_amount() do
    Agent.get(__MODULE__, &(&1[:order_amount]))
  end

  def get_order_amount_valid() do
    Agent.get(__MODULE__, &(&1[:order_amount_valid]))
  end

  def get_order_payments() do
    Agent.get(__MODULE__, &(&1[:order_payments]))
  end

  # returns payment amount, nil if not found
  def get_payment_amount() do
    Agent.get(__MODULE__, &(&1[:payment_amount]))
  end

  def get_payment_amount_numerically_valid() do
    Agent.get(__MODULE__, &(&1[:payment_amount_numerically_valid]))
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

  def get_payment_key_valid() do
    Agent.get(__MODULE__, &(&1[:payment_key_valid]))
  end

  def get_is_payment_valid() do
    Agent.get(__MODULE__, &(&1[:is_payment_valid]))
  end

  def get_remaining_balance() do
    Agent.get(__MODULE__, &(&1[:remaining_balance]))
  end

  def get_did_server_crash() do
    Agent.get(__MODULE__, &(&1[:did_server_crash]))
  end

  def print_everything() do
    IO.inspect Agent.get(__MODULE__, &(&1))
  end



  def generate_payload(:create) do
    %{}
      |> add_to_payload(:action, get_action())
      |> add_to_payload(:customer_id, get_customer_id())
      |> add_to_payload(:customer_id_valid, get_id_valid())
      |> add_to_payload(:order_amount, get_order_amount())
      |> add_to_payload(:order_amount_valid, get_order_amount_valid())
  end

  def generate_payload(:get) do
    IO.inspect %{}
      |> add_to_payload(:action, get_action())
      |> add_to_payload(:customer_id, get_customer_id())
      |> add_to_payload(:customer_id_valid, get_id_valid())
      |> add_to_payload(:customer_email, get_email())
      |> add_to_payload(:customer_email_valid, get_email_valid())
      |> add_to_payload(:order_amount_valid, get_order_amount_valid())
      |> add_to_payload(:order_id, get_order_id())
  end


  def generate_payload() do
      %{}
        |> add_to_payload(:action, get_action())
        |> add_to_payload(:order_id, get_order_id())
        |> add_to_payload(:customer_id, get_customer_id())
        |> add_to_payload(:email, get_email())
        |> add_to_payload(:email_valid, get_email_valid())
        |> add_to_payload(:original_balance, get_order_amount())
        |> add_to_payload(:current_balance, get_remaining_balance())
        |> add_to_payload(:previous_payments, get_order_payments())
        |> add_to_payload(:current_payment, get_payment_amount())
        |> add_to_payload(:payment_key, get_payment_key())
        |> add_to_payload(:payment_key_valid, get_payment_key_valid())
  end

  defp add_to_payload(payload, key, value) do
    Map.put(payload, key, value)
  end
end

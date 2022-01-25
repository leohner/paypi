defmodule Paypi.Store do
  @moduledoc """
  Documentation for Paypi.Store.

  Handles data states throughout life of application runtime.
  """

  use Agent


  ## ***
  ## Initialize start link
  ## ***

  def start_link(input_params) do
    Agent.start_link(fn -> input_params end, name: __MODULE__)
  end


  ## ***
  ## Add values to the agent
  ## ***

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

  def set_customer_id_valid(is_valid) do
    Agent.update(__MODULE__, &Map.put(&1, :customer_id_valid, is_valid))
  end

  def set_order_id_valid(is_valid) do
    Agent.update(__MODULE__, &Map.put(&1, :order_id_valid, is_valid))
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

  def set_orders(orders) do
    Agent.update(__MODULE__, &Map.put(&1, :orders, orders))
  end

  def set_order_payments(payments) do
    Agent.update(__MODULE__, &Map.put(&1, :order_payments, payments))
  end

  def set_payment_id(id) do
    Agent.update(__MODULE__, &Map.put(&1, :payment_id, id))
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

  def set_payment_key(key) do
    Agent.update(__MODULE__, &Map.put(&1, :payment_key, key))
  end

  def set_remaining_balance(balance) do
    Agent.update(__MODULE__, &Map.put(&1, :remaining_balance, balance))
  end

  def set_did_server_crash(crashed) do
    Agent.update(__MODULE__, &Map.put(&1, :did_server_crash, crashed))
  end


  ## ***
  ## Get values from agent
  ## ***

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

  def get_customer_id_valid() do
    Agent.get(__MODULE__, &(&1[:customer_id_valid]))
  end

  # returns order id, nil if not found
  def get_order_id() do
    Agent.get(__MODULE__, &(&1[:order_id]))
  end

  def get_order_id_valid() do
    Agent.get(__MODULE__, &(&1[:order_id_valid]))
  end

  def get_orders() do
    Agent.get(__MODULE__, &(&1[:orders]))
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

  def get_payment_id() do
    Agent.get(__MODULE__, &(&1[:payment_id]))
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


  # Create payload for :create_order
  def generate_payload(:create_order) do
    {status, reason} =
      get_order_id()
        |> get_create_order_status()

    %{
      action: get_action(),
      order_id: get_order_id(),
      customer_id: get_customer_id(),
      is_customer_id_valid: get_customer_id_valid(),
      email: get_email(),
      is_email_valid: get_email_valid(),
      order_amount: get_order_amount(),
      is_order_amount_valid: get_order_amount_valid(),
      creation_status: status,
      creation_reason: reason
    }
  end

  # Create payload for :get_order
  def generate_payload(:get_order) do
    {status, reason} =
      get_order_id_valid()
        |> get_get_order_status()

    %{
      action: get_action(),
      order_id: get_order_id(),
      customer_id: get_customer_id(),
      is_customer_id_valid: get_customer_id_valid(),
      email: get_email(),
      is_email_valid: get_email_valid(),
      order_amount: get_order_amount(),
      is_order_amount_valid: get_order_amount_valid(),
      payments: get_order_payments(),
      remaining_balance: calculate_remaining_balance(),
      order_status: status,
      order_reason: reason
    }
  end

  # Create payload for :get_orders
  def generate_payload(:get_orders) do
    {status, reason} =
      get_email_valid()
        |> get_get_orders_status()

    %{
      action: get_action(),
      customer_id: get_customer_id(),
      is_customer_id_valid: get_customer_id_valid(),
      email: get_email(),
      is_email_valid: get_email_valid(),
      orders: get_orders(),
      order_status: status,
      order_reason: reason
    }
  end

  # Create payload for :pay
  def generate_payload(:pay) do
    {status, reason} =
      get_pay_order_status()

    %{
      action: get_action(),
      customer_id: get_customer_id(),
      is_customer_id_valid: get_customer_id_valid(),
      email: get_email(),
      is_email_valid: get_email_valid(),
      order_id: get_order_id(),
      is_order_id_valid: get_order_id_valid(),
      payment_id: get_payment_id(),
      payment_key: get_payment_key(),
      is_payment_key_valid: get_payment_key_valid(),
      payment_amount: get_payment_amount(),
      order_amount: get_order_amount(),
      remaining_balance: calculate_remaining_balance(),
      payment_status: status,
      payment_reason: reason
    }
  end

  # Create payload for :create_pay
  def generate_payload(:create_pay) do
    {status, reason} =
      get_create_pay_status()

    %{
      action: get_action(),
      customer_id: get_customer_id(),
      is_customer_id_valid: get_customer_id_valid(),
      email: get_email(),
      is_email_valid: get_email_valid(),
      order_id: get_order_id(),
      is_order_id_valid: get_order_id_valid(),
      payment_id: get_payment_id(),
      payment_key: get_payment_key(),
      is_payment_key_valid: get_payment_key_valid(),
      payment_amount: get_payment_amount(),
      order_amount: get_order_amount(),
      remaining_balance: calculate_remaining_balance(),
      did_server_crash: get_did_server_crash(),
      payment_status: status,
      payment_reason: reason
    }
  end

  # Create payload for invalid
  def generate_payload(:invalid) do
    IO.inspect %{
      action: get_action(),
      status: :error,
      status_reason: "Invalid API Action Submitted - Cannot Proceed"
    }
  end


  ## ***
  ## Private Functions
  ## ***

  # Order successfully created
  defp get_create_order_status(order_id) when is_integer(order_id) do
    {:success, "Order Successful"}
  end

  # Invalid order id
  defp get_create_order_status(_) do
    {:error, "Order Creation Failed - Invalid Order ID"}
  end


  # Get the status of getting an order
  defp get_get_order_status(order_id_status)
      when order_id_status == :true do
    {:success, "Order Successfully Retrieved"}
  end

  # Getting order status failed
  defp get_get_order_status(_order_id_status) do
    {:error, "Order Retrieval Failed - Invalid Order ID"}
  end


  # Get orders associated with an email status
  defp get_get_orders_status(is_email_valid)
      when is_email_valid == :true do
    {:success, "Orders Successfully Retrieved"}
  end

  # Getting orders failed
  defp get_get_orders_status(_is_email_valid) do
    {:error, "Orders Could Not Be Retrieved - Invalid Email"}
  end


  # Get status for the payment function
  defp get_pay_order_status() do
    is_order_id_valid = get_order_id_valid()
    is_payment_key_valid = get_payment_key_valid()
    payment_amount = get_payment_amount()
    remaining_balance = calculate_remaining_balance()

    get_pay_order_status(is_order_id_valid, is_payment_key_valid, payment_amount, remaining_balance)
  end

  # Payment failed due to invalid order id
  defp get_pay_order_status(is_order_id_valid, _is_payment_key_valid, _payment_amount, _remaining_balance)
      when is_order_id_valid == :false do
    {:error, "Invalid Order ID Provided"}
  end

  # Payment failed due to payment amount exceeding remaining balance
  defp get_pay_order_status(:true, _is_payment_key_valid, payment_amount, remaining_balance)
      when payment_amount > remaining_balance do
    {:error, "Payment Amount Exceeds Remaining Balance"}
  end

  # Payment failed due to payment amount exceeding remaining balance
  defp get_pay_order_status(_is_order_id_valid, :false, _payment_amount, _remaining_balance) do
    {:error, "Order Already Processed - Cannot Process Again"}
  end

  # Payment successful
  defp get_pay_order_status(:true, _is_payment_key_valid, _payment_amount, _remaining_balance) do
    {:success, "Payment Successfully Applied"}
  end


  # Entry point for get create and pay status
  defp get_create_pay_status() do
    is_customer_id_valid = get_customer_id_valid()
    is_payment_key_valid = get_payment_key_valid()
    order_amount = get_order_amount()
    payment_amount = get_payment_amount()
    did_server_crash = get_did_server_crash()

    get_create_pay_status(is_customer_id_valid, is_payment_key_valid, order_amount, payment_amount, did_server_crash)
  end

  # Fail because payment amount exceeds order amount
  defp get_create_pay_status(:true, :true, order_amount, payment_amount, _did_server_crash)
      when order_amount < payment_amount do
    {:error, "Cannot Process Payment. Payment Amount Exceeds Order Amount"}
  end

  # Fail because the payment key is not unique for the order
  # ealistically this should never happen because we're creating a new order
  defp get_create_pay_status(_is_customer_id_valid, :false, _order_amount, _payment_amount, _did_server_crash) do
    {:error, "Payment Key Not Unique for Order - Payment Already Processed."}
  end

  # Fail because a server error occurred
  defp get_create_pay_status(_is_customer_id_valid, _is_payment_key_valid, _order_amount, _payment_amount, did_server_crash)
      when did_server_crash == :true do
    {:error, "Server Error - Could Not Process Payment. Order and Payment Not Created"}
  end

  # Fail because the customer id provided is invalid
  defp get_create_pay_status(:false, _is_payment_key_valid, _order_amount, _payment_amount, _did_server_crash) do
    {:error, "Invalid Customer ID Provided"}
  end

  # Creating order and paying was successful
  defp get_create_pay_status(_is_customer_id_valid, _is_payment_key_valid, _order_amount, _payment_amount, _did_server_crash) do
    {:success, "Created Order and Processed Payment"}
  end


  # Determine the remaining balance for an order
  defp calculate_remaining_balance() do
    # Fetch existing payments and current payment amount
    existing_payments = get_order_payments()
    current_payment = get_payment_amount()

    # This is going to produce a tuple of old and current payments
    payments_tuple = join_payments(existing_payments, current_payment)

    payment_total =
      payments_tuple
        |> sum_payments()

    order_amount = get_order_amount()
    calculate_remaining_balance(order_amount, payment_total)
  end

  # When the order total and payment total are both numbers, we can subtract safely
  defp calculate_remaining_balance(order_total, payment_total)
      when is_number(order_total)
      and is_number(payment_total) do
    order_total - payment_total
  end

  # Can't proceed when a :nil payment total is provided
  defp calculate_remaining_balance(_order_total, payment_total) when is_nil(payment_total) do
    :nil
  end

  # Some other situation happened and we need to fail
  defp calculate_remaining_balance(_order_total, _payment_total) do
    :nil
  end


  # We can't sum up payments that don't exist
  defp sum_payments(:nil) do
    :nil
  end

  # Calculate total for a list of payments
  defp sum_payments(payments) do
    payments |> Enum.sum()
  end


  # If current payment does not exist, just get the existing payments
  defp join_payments(existing_payments, current_payment) when is_nil(current_payment) do
    existing_payments
  end

  # If the existing payments do not exist, just return the current payment in a list
  defp join_payments(existing_payments, current_payment) when is_nil(existing_payments) do
    # Return as list because Enum.sum expects list
    [current_payment]
  end

  # Both exist, so we can create a combined list
  defp join_payments(existing_payments, current_payment) do
    [current_payment | existing_payments]
  end
end

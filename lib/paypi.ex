defmodule Paypi do
  alias Paypi.Create
  alias Paypi.Data
  alias Paypi.Get
  alias Paypi.Pay
  alias Paypi.Store
  @moduledoc """
  Documentation for `Paypi` (pronounced Pay-Pea-Eye).
  """

  def run({:create_order, customer_id, order_amount}) do
    params = %{action: :create_order, customer_id: customer_id, order_amount: order_amount}
    Store.start_link(params)

    Create.create_order(customer_id, order_amount)

    generate_payload(:create)
    inspect_results()
  end

  def run({:get_order, order_id}) do
    params = %{action: :get_order, order_id: order_id}
    Store.start_link(params)

    Data.get_email_by_order_id(order_id)
    Get.get_order(order_id)

    generate_payload(:get)
    inspect_results()
  end

  def run({:get_orders, email}) when is_binary(email) do
    params = %{action: :get_order, email: email}
    Store.start_link(params)

    Get.get_orders(email)

    generate_payload(:get)
    inspect_results()
  end

  def run({:get_orders, bad_email}) do
    %{
      action: :get_order,
      email: bad_email,
      email_valid: :false,
      result_status: :error,
      result_message: "Email must be a string"
    }
      |> Store.start_link()

    generate_payload(:get)
    inspect_results()
  end

  # in practice, the payment_key (used for idempotency) would be passed by the client to the API
  # for this demo, the payment key will be generated inside the run function to simulate the behavior
  # leaving the parameter in the function so that it can be tested when necessary
  # hard code
  def run({:pay, order_id, amount, payment_key}) do
    payment_key = generate_payment_key(payment_key)
    params = %{action: :pay, order_id: order_id, payment_amount: amount, payment_key: payment_key, payment_key_valid: :true}
    Store.start_link(params)

    Pay.pay(order_id, amount, payment_key)

    generate_payload(:pay)
    inspect_results()
  end

  def run({:create_pay, customer_id, order_amount, payment_amount, payment_key}) do
    payment_key = generate_payment_key(payment_key)
    params = %{action: :create_pay, customer_id: customer_id, order_amount: order_amount, payment_amount: payment_amount, payment_key: payment_key, payment_key_valid: :true}
    Store.start_link(params)

    Pay.order_and_pay(customer_id, order_amount, payment_amount, payment_key)

    generate_payload(:pay)
    inspect_results()
  end

  def run(_) do
    params = %{action: :invalid}
    Store.start_link(params)

    generate_payload(:invalid)
    inspect_results()
  end



  ## ***
  ## Private Functions
  ## ***

  defp generate_payment_key(key) when key == :nil or not is_binary(key) do
    Ecto.UUID.generate()
  end

  defp generate_payment_key(key) when is_binary(key) do
    key
  end

  defp inspect_results() do
    Store.print_everything()
  end

  defp generate_payload(action) do
    Store.generate_payload(action)
  end
end

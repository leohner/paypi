defmodule Paypi.Pay do
  alias Paypi.Create
  alias Paypi.Data
  alias Paypi.Store
  alias Paypi.Validate

  def pay(order_id, amount, payment_key) do
    order_id |> Validate.check_order_exists()

    amount |> Validate.check_payment_amount()
    payment_key |> Validate.check_payment_key(order_id)

    id_valid = Store.get_id_valid()
    amount_valid = Store.get_payment_amount_numerically_valid()
    payment_key_valid = Store.get_payment_key_valid()

    order_id = Store.get_order_id()
    is_payment_valid = payment_valid?(amount, order_id)

    submit_payment(id_valid, amount_valid, payment_key_valid, is_payment_valid)
  end


  def order_and_pay(customer_id, order_amount, payment_amount, payment_key) do
    customer_id |> Validate.check_customer_exists()
    order_amount |> Validate.check_order_amount()

    customer_id_valid = Store.get_id_valid()
    order_amount_valid = Store.get_order_amount_valid()

    order_and_pay_step_2(customer_id_valid, order_amount_valid, {payment_amount, payment_key})
  end



  ## ***
  ### Private Functions
  ## ***

  defp submit_payment(:true, :true, :true, :true) do
    Data.add_payment()
    :ok
  end

  defp submit_payment(_id_valid, _amount_valid, _payment_key_valid, _is_payment_valid) do
    # don't submit payment
    :ok
  end

  defp order_and_pay_step_2(customer_id_valid, order_amount_valid, {payment_amount, payment_key})
      when customer_id_valid == :true
      and order_amount_valid == :true do
    customer_id = Store.get_customer_id()
    order_amount = Store.get_order_amount()

    Create.create_order(customer_id, order_amount, :false)

   get_server_status()
      |> order_and_pay_step_3(payment_amount, payment_key)
  end

  # if both aren't true, we can't continue
  defp order_and_pay_step_2(_customer_id_valid, _order_id_valid, _payment_details) do
    # no action taken
    :ok
  end


  defp order_and_pay_step_3(:success, payment_amount, payment_key) do
    Store.set_did_server_crash(:false)

    order_id = Store.get_order_id()
    is_payment_valid = payment_valid?(payment_amount, order_id)

    # if we've made it this far, we know the order id is valid
    submit_payment(:true, payment_amount, payment_key, is_payment_valid)
  end

  defp order_and_pay_step_3(:failure, _, _) do
    Store.set_did_server_crash(:true)

    Store.get_customer_id()
      |> Data.get_most_recent_order_id()
      |> Data.delete_order_by_id()
  end

  defp get_server_status() do
		# Fail about 25% of the time
		[:success, :success, :success, :failure]
			|> Enum.shuffle()
			|> hd()
	end

  defp payment_valid?(payment_amount, order_id)
      when is_number(payment_amount)
      and is_integer(order_id) do
    Data.get_order_payments()
    Data.get_order_amount()

    order_amount = Store.get_order_amount()

    total_payments =
      Store.get_order_payments()
        |> sum_payments(0)

    remaining_balance = order_amount - total_payments

    case remaining_balance - payment_amount do
      balance when balance >= 0 ->
        Store.set_is_payment_valid(:true)
        :true
      _ ->
        Store.set_is_payment_valid(:false)
        :false # payment exceeds reminaing balance
    end
  end

  defp payment_valid?(_payment_amount, _invalid_order_id) do
    :false
  end

  defp sum_payments([payment | rest], total) do
    {extracted_payment} = payment
    sum_payments(rest, total + extracted_payment)
  end

  defp sum_payments([], total) do
    total
  end
end

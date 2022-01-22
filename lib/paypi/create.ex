defmodule Paypi.Create do
  alias Paypi.Validate

  def create_order({customer_id, _order_value}) do
    Validate.check_customer_exists(customer_id)
  end
end

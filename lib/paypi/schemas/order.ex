defmodule Paypi.Schema.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "order" do
    field :customer_id, :integer
    field :order_amount, :float
  end

  def changset(order, params \\ %{}) do
    order
      |> cast(params, [:customer_id, :order_amount])
      |> validate_required([:customer_id, :order_amount])
  end
end

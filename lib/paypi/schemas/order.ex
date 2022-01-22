defmodule Paypi.Schema.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "order" do
    field :customer_id, :integer
    field :order_value, :float
  end

  def changset(user, params \\ %{}) do
    user
      |> cast(params, [:customer_id, :order_value])
      |> validate_required([:customer_id, :order_value])
  end
end

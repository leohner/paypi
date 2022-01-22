defmodule Paypi.Schema.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "payment" do
    field :order_id, :integer
    field :amount, :float
    field :payment_key, :string
  end

  def changset(user, params \\ %{}) do
    user
      |> cast(params, [:order_id, :amount, :payment_key])
      |> validate_required([:order_id, :amount, :payment_key])
  end
end

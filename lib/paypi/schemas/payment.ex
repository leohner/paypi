defmodule Paypi.Schema.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "payment" do
    field :order_id, :integer
    field :payment_amount, :float
    field :payment_key, :string
  end

  def changset(payment, params \\ %{}) do
    payment
      |> cast(params, [:order_id, :payment_amount, :payment_key])
      |> validate_required([:order_id, :payment_amount, :payment_key])
  end
end

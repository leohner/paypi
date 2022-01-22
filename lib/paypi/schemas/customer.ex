defmodule Paypi.Schema.Customer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "customer" do
    field :email, :string
  end

  def changset(user, params \\ %{}) do
    user
      |> cast(params, [:email])
      |> validate_required([:email])
  end
end

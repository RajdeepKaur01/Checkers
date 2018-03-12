defmodule Checkers.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :email, :string
    field :name, :string
    has_many :player, Checkers.Players.Player, on_delete: :nilify_all, foreign_key: :user_id
    has_many :audience, Checkers.Audiences.Audience, on_delete: :nilify_all, foreign_key: :user_id
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name])
    |> validate_required([:email, :name])
    |> unique_constraint(:email)
  end
end

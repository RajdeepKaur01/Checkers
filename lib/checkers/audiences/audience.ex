defmodule Checkers.Audiences.Audience do
  use Ecto.Schema
  import Ecto.Changeset


  schema "audiences" do
    field :game, :string
    belongs_to :user, Checkers.Accounts.User, foreign_key: :user_id

    timestamps()
  end

  @doc false
  def changeset(audience, attrs) do
    audience
    |> cast(attrs, [:game, :user_id])
    |> validate_required([:game, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end

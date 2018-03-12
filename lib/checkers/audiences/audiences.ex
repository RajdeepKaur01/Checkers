defmodule Checkers.Audiences do
  @moduledoc """
  The Audiences context.
  """

  import Ecto.Query, warn: false
  alias Checkers.Repo

  alias Checkers.Audiences.Audience

  @doc """
  Returns the list of audiences.

  ## Examples

      iex> list_audiences()
      [%Audience{}, ...]

  """
  def list_audiences do
    Repo.all(Audience)
  end


  def get_audience_by_user(user) do
     Repo.get_by(Audience, user_id: user)
   end
    @doc """
  Gets a single audience.

  Raises `Ecto.NoResultsError` if the Audience does not exist.

  ## Examples

      iex> get_audience!(123)
      %Audience{}

      iex> get_audience!(456)
      ** (Ecto.NoResultsError)

  """
  def get_audience!(id), do: Repo.get!(Audience, id)

  @doc """
  Creates a audience.

  ## Examples

      iex> create_audience(%{field: value})
      {:ok, %Audience{}}

      iex> create_audience(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_audience(attrs \\ %{}) do
    %Audience{}
    |> Audience.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a audience.

  ## Examples

      iex> update_audience(audience, %{field: new_value})
      {:ok, %Audience{}}

      iex> update_audience(audience, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_audience(%Audience{} = audience, attrs) do
    audience
    |> Audience.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Audience.

  ## Examples

      iex> delete_audience(audience)
      {:ok, %Audience{}}

      iex> delete_audience(audience)
      {:error, %Ecto.Changeset{}}

  """
  def delete_audience(%Audience{} = audience) do
    Repo.delete(audience)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking audience changes.

  ## Examples

      iex> change_audience(audience)
      %Ecto.Changeset{source: %Audience{}}

  """
  def change_audience(%Audience{} = audience) do
    Audience.changeset(audience, %{})
  end
end

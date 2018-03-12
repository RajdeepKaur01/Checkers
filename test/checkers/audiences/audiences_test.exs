defmodule Checkers.AudiencesTest do
  use Checkers.DataCase

  alias Checkers.Audiences

  describe "audiences" do
    alias Checkers.Audiences.Audience

    @valid_attrs %{game: "some game"}
    @update_attrs %{game: "some updated game"}
    @invalid_attrs %{game: nil}

    def audience_fixture(attrs \\ %{}) do
      {:ok, audience} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Audiences.create_audience()

      audience
    end

    test "list_audiences/0 returns all audiences" do
      audience = audience_fixture()
      assert Audiences.list_audiences() == [audience]
    end

    test "get_audience!/1 returns the audience with given id" do
      audience = audience_fixture()
      assert Audiences.get_audience!(audience.id) == audience
    end

    test "create_audience/1 with valid data creates a audience" do
      assert {:ok, %Audience{} = audience} = Audiences.create_audience(@valid_attrs)
      assert audience.game == "some game"
    end

    test "create_audience/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Audiences.create_audience(@invalid_attrs)
    end

    test "update_audience/2 with valid data updates the audience" do
      audience = audience_fixture()
      assert {:ok, audience} = Audiences.update_audience(audience, @update_attrs)
      assert %Audience{} = audience
      assert audience.game == "some updated game"
    end

    test "update_audience/2 with invalid data returns error changeset" do
      audience = audience_fixture()
      assert {:error, %Ecto.Changeset{}} = Audiences.update_audience(audience, @invalid_attrs)
      assert audience == Audiences.get_audience!(audience.id)
    end

    test "delete_audience/1 deletes the audience" do
      audience = audience_fixture()
      assert {:ok, %Audience{}} = Audiences.delete_audience(audience)
      assert_raise Ecto.NoResultsError, fn -> Audiences.get_audience!(audience.id) end
    end

    test "change_audience/1 returns a audience changeset" do
      audience = audience_fixture()
      assert %Ecto.Changeset{} = Audiences.change_audience(audience)
    end
  end
end

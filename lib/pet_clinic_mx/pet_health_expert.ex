defmodule PetClinicMx.PetHealthExpert do
  @moduledoc """
  The PetHealthExpert context.
  """

  import Ecto.Query, warn: false
  alias PetClinicMx.Repo

  alias PetClinicMx.PetHealthExpert.Healt

  @doc """
  Returns the list of healt_expert.

  ## Examples

      iex> list_healt_expert()
      [%Healt{}, ...]

  """
  def list_healt_expert do
    Repo.all(Healt)
  end

  @doc """
  Gets a single healt.

  Raises `Ecto.NoResultsError` if the Healt does not exist.

  ## Examples

      iex> get_healt!(123)
      %Healt{}

      iex> get_healt!(456)
      ** (Ecto.NoResultsError)

  """
  def get_healt!(id), do: Repo.get!(Healt, id)

  @doc """
  Creates a healt.

  ## Examples

      iex> create_healt(%{field: value})
      {:ok, %Healt{}}

      iex> create_healt(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_healt(attrs \\ %{}) do
    %Healt{}
    |> Healt.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a healt.

  ## Examples

      iex> update_healt(healt, %{field: new_value})
      {:ok, %Healt{}}

      iex> update_healt(healt, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_healt(%Healt{} = healt, attrs) do
    healt
    |> Healt.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a healt.

  ## Examples

      iex> delete_healt(healt)
      {:ok, %Healt{}}

      iex> delete_healt(healt)
      {:error, %Ecto.Changeset{}}

  """
  def delete_healt(%Healt{} = healt) do
    Repo.delete(healt)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking healt changes.

  ## Examples

      iex> change_healt(healt)
      %Ecto.Changeset{data: %Healt{}}

  """
  def change_healt(%Healt{} = healt, attrs \\ %{}) do
    Healt.changeset(healt, attrs)
  end
end

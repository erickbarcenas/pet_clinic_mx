defmodule PetClinicMx.Services.HealthExpertService do
    @moduledoc """
    The HealthExpert service
    """
  
    import Ecto.Query, warn: false
    alias PetClinicMx.Repo
  
    alias PetClinicMx.Models.HealthExpert
  
    @doc """
    Returns the list of healt_expert.
  
    ## Examples
  
        iex> list_healt_expert()
        [%Healt{}, ...]
  
    """
    def list_health_experts do
      Repo.all(HealthExpert)
    end
  
    @doc """
    Gets a single healt.
  
    Raises `Ecto.NoResultsError` if the Healt does not exist.
  
    ## Examples
  
        iex> get_health_expert!(123)
        %Healt{}
  
        iex> get_health_expert!(456)
        ** (Ecto.NoResultsError)
  
    """
    def get_health_expert!(id), do: Repo.get!(HealthExpert, id)
  
    @doc """
    Creates a health_expert.
  
    ## Examples
  
        iex> create_health_expert(%{field: value})
        {:ok, %HealthExpert{}}
  
        iex> create_health_expert(%{field: bad_value})
        {:error, %Ecto.Changeset{}}
  
    """
    def create_health_expert(attrs \\ %{}) do
      %HealthExpert{}
      |> HealthExpert.changeset(attrs)
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
    def update_healt(%HealthExpert{} = health_expert, attrs) do
      health_expert
      |> HealthExpert.changeset(attrs)
      |> Repo.update()
    end
  
    @doc """
    Deletes a health_expert.
  
    ## Examples
  
        iex> delete_health_expert(health_expert)
        {:ok, %Healt{}}
  
        iex> delete_health_expert(health_expert)
        {:error, %Ecto.Changeset{}}
  
    """
    def delete_health_expert(%HealthExpert{} = health_expert) do
      Repo.delete(health_expert)
    end
  
    @doc """
    Returns an `%Ecto.Changeset{}` for tracking health_expert changes.
  
    ## Examples
  
        iex> change_health_expert(health_expert)
        %Ecto.Changeset{data: %HealthExpert{}}
  
    """
    def change_health_expert(%HealthExpert{} = health_expert, attrs \\ %{}) do
        HealthExpert.changeset(health_expert, attrs)
    end
  end
  
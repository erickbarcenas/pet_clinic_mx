defmodule PetClinicMxWeb.PetController do
  use PetClinicMxWeb, :controller

  alias PetClinicMx.Models.Pet
  alias PetClinicMx.Services.PetService
  alias PetClinicMx.Serivices.OwnerService
  alias PetClinicMx.Services.HealthExpertService

  def index(conn, _params) do
    pets = PetService.list_pets()
    render(conn, "index.html", pets: pets)
  end

  def index_by_type(conn, params) do
    type = params["type"]
    pets = PetService.list_pets_by_type(params["type"])
    render(conn, "index_by_type.html", pets: pets, type: type)
  end

  def new(conn, _params) do
    changeset = PetService.change_pet(%Pet{})
    pet_types = PetService.list_pet_types()
    owners = PetService.list_owners()
    health_experts = PetService.list_health_experts()

    render(
      conn,
      "new.html",
      pet_types: pet_types,
      owners: owners,
      health_experts: health_experts,
      changeset: changeset
    )
  end

  def create(conn, %{"pet" => pet_params}) do
    case PetService.create_pet(pet_params) do
      {:ok, pet} ->
        conn
        |> put_flash(:info, "Pet created successfully.")
        |> redirect(to: Routes.pet_path(conn, :show, pet))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    pet = PetService.get_pet!(id)
    # 
    owner = OwnerService.get_owner!(pet.owner_id)
    # 
    expert = HealthExpertService.get_health_expert!(pet.preferred_expert_id)
    render(conn, "show.html", pet: pet, owner: owner, expert: expert)
  end

  def edit(conn, %{"id" => id}) do
    pet = PetService.get_pet!(id)
    changeset = PetService.change_pet(pet)
    pet_types = PetService.list_pet_types()
    render(conn, "edit.html", pet: pet, pet_types: pet_types, changeset: changeset)
  end

  def update(conn, %{"id" => id, "pet" => pet_params}) do
    pet = PetService.get_pet!(id)

    case PetService.update_pet(pet, pet_params) do
      {:ok, pet} ->
        conn
        |> put_flash(:info, "Pet updated successfully.")
        |> redirect(to: Routes.pet_path(conn, :show, pet))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", pet: pet, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    pet = PetService.get_pet!(id)
    {:ok, _pet} = PetService.delete_pet(pet)

    conn
    |> put_flash(:info, "Pet deleted successfully.")
    |> redirect(to: Routes.pet_path(conn, :index))
  end
end

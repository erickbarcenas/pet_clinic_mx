defmodule PetClinicMx.Models.Appointment do
  @moduledoc """
    health expert dating model
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias PetClinicMx.Repo
  alias PetClinicMx.Models.Pet
  alias PetClinicMx.Models.HealthExpert

  schema "appointments" do
    belongs_to :healt_expert, PetClinicMx.Models.HealthExpert
    belongs_to :pet, PetClinicMx.Models.Pet
    field :datetime, :utc_datetime
    timestamps()
  end

  @doc false
  def changeset(appointment, attrs) do
    healt_expert_id = Map.get(attrs, :health_expert_id)

    appointment
    |> cast(attrs, [:healt_expert_id, :pet_id, :datetime])
    |> validate_appointment
  end

  def validate_appointment(changeset) do
    if changeset.valid? do
      pet_id = get_field(changeset, :pet_id)
      health_expert_id = get_field(changeset, :healt_expert_id)

      case get_info(pet_id, health_expert_id) do
        true ->
          changeset

        false ->
          add_error(
            changeset,
            :wrong_pet_or_health_expert,
            "the pet or health expert id does not exist"
          )
      end
    else
      add_error(changeset, :wrong_parameters, "The entered parameters are incomplete")
    end
  end

  def get_info(pet_id, health_expert_id) do
    if get_pet_id(pet_id) and get_health_expert_id(health_expert_id), do: true, else: false
  end

  def get_pet_id(pet_id) do
    case Repo.get(Pet, pet_id) do
      %Pet{id: id} -> if pet_id == id, do: true
      # {:error, "the pet does not exist"}
      _ -> false
    end
  end

  def get_health_expert_id(health_expert_id) do
    case Repo.get(HealthExpert, health_expert_id) do
      %HealthExpert{id: id} -> if health_expert_id == id, do: true
      # {:error, "the health expert does not exist"}
      _ -> false
    end
  end
end

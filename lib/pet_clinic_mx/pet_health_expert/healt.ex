defmodule PetClinicMx.PetHealthExpert.Healt do
  use Ecto.Schema
  import Ecto.Changeset

  schema "healt_expert" do
    field :age, :integer
    field :email, :string
    field :name, :string
    field :sex, Ecto.Enum, values: [:male, :female]
    # field :specialities, :string

    has_many(:patients, PetClinicMx.PetClinicService.Pet, foreign_key: :preferred_expert_id)
    many_to_many(:specialities, PetClinicMx.PetClinicService.PetType, join_through: PetClinicMx.PetHealthExpert.ExpertSpecialities, 
                  join_keys: [pet_type_id: :id, healt_expert_id: :id])
    has_one(:schedule, PetClinicMx.Services.ExpertSchedule)

    timestamps()
  end

  @doc false
  def changeset(healt, attrs) do
    healt
    |> cast(attrs, [:name, :age, :email, :specialities, :sex])
    |> validate_required([:name, :age, :email, :specialities, :sex])
  end
end

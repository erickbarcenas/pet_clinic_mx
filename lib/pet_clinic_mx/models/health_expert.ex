defmodule PetClinicMx.Models.HealthExpert do
  use Ecto.Schema
  import Ecto.Changeset

  schema "healt_expert" do
    field :age, :integer
    field :email, :string
    field :name, :string
    field :sex, Ecto.Enum, values: [:male, :female]
    # field :specialities, :string

    has_many(:patients, PetClinicMx.Models.Pet, foreign_key: :preferred_expert_id)

    many_to_many(:specialities, PetClinicMx.Models.PetType,
      join_through: PetClinicMx.Models.ExpertSpecialities,
      join_keys: [pet_type_id: :id, healt_expert_id: :id]
    )

    has_one(:schedule, PetClinicMx.Models.ExpertSchedule)

    timestamps()
  end

  @doc false
  def changeset(healt, attrs) do
    healt
    |> cast(attrs, [:name, :age, :email, :sex])
    |> validate_required([:name, :age, :email, :sex])
    # |> put_specialities(attrs)
  end
end

defmodule PetClinicMx.Models.HealthExpert do
  use Ecto.Schema
  import Ecto.Changeset
  alias PetClinicMx.Models.{ExpertSpecialities, Appointment, ExpertSchedule, PetType, Pet}

  schema "healt_expert" do
    field :age, :integer
    field :email, :string
    field :name, :string
    field :sex, Ecto.Enum, values: [:male, :female]
    # field :specialities, :string

    has_many(:patients, Pet, foreign_key: :preferred_expert_id)

    many_to_many(:specialities, PetType,
      join_through: ExpertSpecialities,
      join_keys: [pet_type_id: :id, healt_expert_id: :id]
    )
    has_many(:appointments, Appointment, foreign_key: :healt_expert_id)
    has_one(:schedule, ExpertSchedule)

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

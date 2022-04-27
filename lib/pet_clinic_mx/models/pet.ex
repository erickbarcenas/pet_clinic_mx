defmodule PetClinicMx.Models.Pet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pets" do
    field :age, :integer, default: 1
    field :name, :string
    field :sex, Ecto.Enum, values: [:male, :female]
    # field :type, :string
    belongs_to(:type, PetClinicMx.Models.PetType)


    belongs_to(:owner, PetClinicMx.Models.Owner, foreign_key: :owner_id)
    belongs_to(:preferred_expert, PetClinicMx.Models.HealthExpert, foreign_key: :preferred_expert_id)

    timestamps()
  end

  @doc false
  def changeset(pet, attrs) do
    pet
    |> cast(attrs, [:name, :age, :type, :sex])
    |> validate_required([:name, :age, :type, :sex])
    |> validate_number(:age, greater_than: 3)
  end
end

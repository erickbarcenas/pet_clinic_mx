defmodule PetClinicMx.PetClinicService.Pet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pets" do
    field :age, :integer
    field :name, :string
    field :sex, :string
    field :type, :string

    belongs_to(:owner, PetClinicMx.OwnerService.Owner, foreign_key: :owner_id)
    # belongs_to(:preferred_expert, PetClinicMx.PetHealthExpert.Healt, foreign_key: :preferred_expert_id)  

    timestamps()
  end

  @doc false
  def changeset(pet, attrs) do
    pet
    |> cast(attrs, [:name, :age, :type, :sex])
    |> validate_required([:name, :age, :type, :sex])
  end
end

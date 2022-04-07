defmodule PetClinicMx.PetHealthExpert.Healt do
  use Ecto.Schema
  import Ecto.Changeset

  schema "healt_expert" do
    field :age, :integer
    field :email, :string
    field :name, :string
    field :sex, :string
    field :specialities, :string

    timestamps()
  end

  @doc false
  def changeset(healt, attrs) do
    healt
    |> cast(attrs, [:name, :age, :email, :specialities, :sex])
    |> validate_required([:name, :age, :email, :specialities, :sex])
  end
end

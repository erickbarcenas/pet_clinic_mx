defmodule PetClinicMx.PetClinicService.PetType do
    use Ecto.Schema
  
    schema "pet_types" do
      field :name, :string

      timestamps()
    end
  end
  
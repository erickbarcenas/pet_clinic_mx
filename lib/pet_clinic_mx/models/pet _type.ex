defmodule PetClinicMx.Models.PetType do
  @moduledoc """
    model for a type of pet
  """
  use Ecto.Schema

  schema "pet_types" do
    field :name, :string

    timestamps()
  end
end

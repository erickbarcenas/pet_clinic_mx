defmodule PetClinicMx.Models.ExpertSpecialities do
  @moduledoc """
    model for the specialties of a health expert
  """
  use Ecto.Schema

  schema "expert_specialities" do
    belongs_to :healt_expert, PetClinicMx.Models.HealthExpert
    belongs_to :pet_type, PetClinicMx.Models.PetType

    # timestamps()
  end
end

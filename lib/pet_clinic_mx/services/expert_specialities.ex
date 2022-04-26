defmodule PetClinicMx.PetHealthExpert.ExpertSpecialities do
    use Ecto.Schema
    schema "expert_specialities" do
      belongs_to :healt_expert, PetClinicMx.PetHealthExpert.Healt
      belongs_to :pet_type, PetClinicMx.PetClinicService.PetType
      
      # timestamps()
    end
  end



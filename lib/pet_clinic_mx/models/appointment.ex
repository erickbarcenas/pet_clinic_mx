defmodule PetClinicMx.Models.Appointment do
    use Ecto.Schema
    schema "appointments" do
      field :datetime, :utc_datetime

      belongs_to :healt_expert, PetClinicMx.PetHealthExpert.Healt
      belongs_to :pet, PetClinicMx.PetClinicService.Pet
      # timestamps()
    end
end

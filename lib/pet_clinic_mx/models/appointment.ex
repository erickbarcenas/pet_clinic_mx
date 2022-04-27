defmodule PetClinicMx.Models.Appointment do
    use Ecto.Schema
    schema "appointments" do
      field :datetime, :utc_datetime

      belongs_to :healt_expert, PetClinicMx.Models.HealthExpert
      belongs_to :pet, PetClinicMx.Models.Pet
      # timestamps()
    end
end

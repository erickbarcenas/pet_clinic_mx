defmodule PetClinicMx.Services.AppointmentService do
    alias PetClinicMx.Models.ExpertSchedule
    alias PetClinicMx.Repo
    def available_slots do
        Repo.all(ExpertSchedule)
    end

    def new_appointment(expert_id, pet_id, datetime) do

    end
end

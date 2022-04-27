defmodule PetClinicMx.Services.AppointmentService do
    @moduledoc """
    Service for appointment

    # Where 1 is Monday and 7 is Sunday
    Date.day_of_week(~D[2016-10-31])
    
    """
    import Ecto.Query
    alias PetClinicMx.Repo
    alias PetClinicMx.Models.{ Pet, HealthExpert, ExpertSchedule }
    
    def available_slots(expert_id, from_date, to_date) do

        day_of_week = Date.day_of_week(from_date)
        # case day_of_week do
        #     1 -> from(ExpertSchedule, where: [healt_expert_id: day_of_week])
        #     2 -> 2
        #     3 -> 3
        #     4 -> 4
        #     5 -> 5
        #     6 -> 6
        #     7 -> 7
        #     _ ->
        #         IO.puts("Error")
        # end

        # SELECT from_monday FROM expert_schedules WHERE healt_expert_id = {expert_id}
        
        # query = from(e in ExpertSchedule, where: [e.healt_expert_id: ^day_of_week])

        # Repo.all(query)
        # |> Repo.preload(:)
    end

    def new_appointment(expert_id, pet_id, datetime) do
        query = Repo.get(Pet, pet_id)
    end
end

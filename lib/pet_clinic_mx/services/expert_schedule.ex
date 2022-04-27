defmodule PetClinicMx.Services.ExpertSchedule do
    use Ecto.Schema
    schema "expert_schedule" do
     
        belongs_to :healt_expert, PetClinicMx.PetHealthExpert.Healt

       
        timestamps()
    end
end




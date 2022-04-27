defmodule PetClinicMx.Models.ExpertSchedule do
    use Ecto.Schema
    schema "expert_schedules" do
        field :from_monday, :time
        field :to_monday, :time
        field :from_tuesday, :time
        field :to_tuesday, :time
        field :from_wednesday, :time
        field :to_wednesday, :time
        field :from_thursday, :time
        field :to_thursday, :time
        field :from_friday, :time
        field :to_friday, :time
        field :from_saturday, :time
        field :to_saturday, :time
        field :from_sunday, :time
        field :to_sunday, :time
        
        belongs_to :healt_expert, PetClinicMx.Models.Healt
    end
end




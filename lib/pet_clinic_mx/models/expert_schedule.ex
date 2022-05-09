defmodule PetClinicMx.Models.ExpertSchedule do
  @moduledoc """
    template for health expert schedules
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "expert_schedules" do
    field :start_date, :date
    field :ending_date, :date
    field :start_hour, :time
    field :ending_hour, :time
    belongs_to :healt_expert, PetClinicMx.Models.HealthExpert
    timestamps()
  end

  @doc false
  def changeset(schedule, params) do
    schedule
    |> cast(params, [:healt_expert_id, :start_date, :ending_date, :start_hour, :ending_hour])
    |> validate_required([:healt_expert_id, :start_date, :ending_date, :start_hour, :ending_hour])
  end
end

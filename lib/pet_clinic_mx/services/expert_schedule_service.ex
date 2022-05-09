defmodule PetClinicMx.Services.ExpertScheduleService do
  @moduledoc false

  import Ecto.Query
  alias PetClinicMx.Repo
  alias PetClinicMx.Models.ExpertSchedule

  @doc """
  Returns the list of schedules.

  ## Examples

      iex> list_schedule()
      [%ExpertSchedule{}, ...]

  """
  def list_schedule do
    Repo.all(ExpertSchedule)
  end

  def create_schedule(params \\ %{}) do
    %ExpertSchedule{}
    |> ExpertSchedule.changeset(params)
    |> Repo.insert()
  end
end

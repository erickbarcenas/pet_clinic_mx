defmodule PetClinicMx.Services.AppointmentService do
  @moduledoc """
  Service for appointment

  # Where 1 is Monday and 7 is Sunday
  Date.day_of_week(~D[2016-10-31])

  """
  import Ecto.Query
  alias PetClinicMx.Repo
  alias PetClinicMx.Utils.AppointmentUtils
  alias PetClinicMx.Models.{Pet, HealthExpert, ExpertSchedule, Appointment}

  @offset 1800

  @doc """
  Returns the list of appointments.

  ## Examples

      iex> list_appointment()
      [%Owner{}, ...]

  """
  def list_appointment do
    Repo.all(Appointment)
  end

  @doc """
  Creates an appointment.

  ## Examples

      iex> new_appointment(%{field: value})
      {:ok, %Appointment{}}

      iex> new_appointment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  # query = Repo.get(Pet, pet_id)
  def new_appointment(expert_id, pet_id, datetime) do
    date = NaiveDateTime.to_date(datetime)

    with {:ok, slots} <- available_slots(expert_id, date, date) do
      if NaiveDateTime.to_time(datetime) in Map.get(slots, date, []) do
        if not is_nil(Repo.get(Pet, pet_id)) do
          %Appointment{}
          |> Appointment.changeset(%{
            healt_expert_id: expert_id,
            pet_id: pet_id,
            datetime: datetime
          })
          |> Repo.insert()
        else
          {:error, "Invalid pet id!"}
        end
      else
        {:error, "Appointment is not available!"}
      end
    end
  end

  @doc """
  Gets a single appointment.

  Raises `Ecto.NoResultsError` if the Appointment does not exist.

  ## Examples

      iex> get_appointment!(123)
      %Appointment{}

      iex> get_appointment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_appointment!(id), do: Repo.get!(Appointment, id)

  @doc """
  Deletes an appointment.

  ## Examples

      iex> delete_appointment(appointment)
      {:ok, %Appointment{}}

      iex> delete_appointment(appointment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_appointment(%Appointment{} = appointment) do
    Repo.delete(appointment)
  end

  @doc """
  Get available times to make an appointment


  ## Examples

      iex> AppointmentService.available_slots(1, ~D[2022-04-26], ~D[2022-04-29])
      {:ok,
      %{
        ~D[2022-04-28] => [~T[10:00:00], ~T[10:30:00], ~T[11:00:00], ~T[11:30:00],
          ~T[12:00:00], ~T[12:30:00], ~T[13:00:00], ~T[13:30:00], ~T[14:00:00],
          ~T[14:30:00], ~T[15:00:00], ~T[15:30:00], ~T[16:00:00], ~T[16:30:00],
          ~T[17:00:00], ~T[17:30:00], ~T[18:00:00], ~T[18:30:00], ~T[19:00:00],
          ~T[19:30:00]]
      }}

  """
  def available_slots(health_expert_id, start_date, ending_date) do
    case Repo.get_by(ExpertSchedule, healt_expert_id: health_expert_id) do
      nil ->
        {:error, "invalid health expert id!"}

      schedule ->
        time_intervals =
          AppointmentUtils.create_time_interval(
            [schedule.start_hour],
            schedule.ending_hour,
            @offset
          )

        appointments =
          Repo.all(
            from a in Appointment,
              where: a.healt_expert_id == ^health_expert_id,
              select: [a.datetime]
          )

        slots =
          max(start_date, schedule.start_date)
          |> Date.range(min(ending_date, schedule.ending_date))
          |> Map.new(fn day ->
            {
              day,
              time_intervals
              |> Enum.filter(fn hour ->
                DateTime.new!(day, hour) not in appointments
              end)
            }
          end)

        {:ok, slots}
    end
  end
end

defmodule PetClinicMx.Utils.AppointmentUtils do
  @moduledoc false
  def create_time_interval([head | _] = acc, ending_hour, offset) do
    new_time = Time.add(head, offset)

    case Time.compare(new_time, ending_hour) do
      :lt ->
        create_time_interval([new_time | acc], ending_hour, offset)

      _ ->
        Enum.reverse(acc)
        |> Enum.map(&Time.truncate(&1, :second))
    end
  end
end

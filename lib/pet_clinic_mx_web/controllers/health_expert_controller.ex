defmodule PetClinicMxWeb.HealthExpertController do
  use PetClinicMxWeb, :controller

  alias PetClinicMx.Models.HealthExpert
  alias PetClinicMx.Services.HealthExpertService
  alias PetClinicMx.Services.PetService

  def index(conn, _params) do
    health_experts = HealthExpertService.list_health_experts()
    render(conn, "index.html", health_experts: health_experts)
  end

  def index_appointments(conn, %{"id" => id, "date" => date}) do
    date = Date.from_iso8601!(date)

    appointments =
      HealthExpertService.get_pet_health_expert!(id, preloads: [appointments: :pet])
      |> Map.get(:appointments)
      |> Enum.filter(fn a ->
        a.datetime
        |> DateTime.to_date()
        |> Date.compare(date)
        |> case do
          :eq -> true
          _ -> false
        end
      end)

    render(conn, "index_appointments.html", appointments: appointments)
  end

  def new(conn, _params) do
    changeset = HealthExpertService.change_health_expert(%HealthExpert{})
    pet_types = PetService.list_pet_types()
    render(conn, "new.html", pet_types: pet_types, changeset: changeset)
  end

  def create(conn, %{"health_expert" => health_expert_params}) do
    pet_types = PetService.list_pet_types()

    case HealthExpertService.create_health_expert(health_expert_params) do
      {:ok, health_expert} ->
        conn
        |> put_flash(:info, "Health_expert created successfully.")
        |> redirect(to: Routes.health_expert_path(conn, :show, health_expert))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", pet_types: pet_types, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    health_expert = HealthExpertService.get_health_expert!(id)
    render(conn, "show.html", health_expert: health_expert)
  end

  def edit(conn, %{"id" => id}) do
    health_expert = HealthExpertService.get_health_expert!(id)
    pet_types = PetService.list_pet_types()

    changeset = HealthExpertService.change_health_expert(health_expert)

    render(conn, "edit.html",
      health_expert: health_expert,
      pet_types: pet_types,
      changeset: changeset
    )
  end

  def update(conn, %{"id" => id, "health_expert" => health_expert_params}) do
    health_expert = HealthExpertService.get_health_expert!(id)
    pet_types = PetService.list_pet_types()

    case HealthExpertService.update_health_expert(health_expert, health_expert_params) do
      {:ok, health_expert} ->
        conn
        |> put_flash(:info, "Health_expert updated successfully.")
        |> redirect(to: Routes.health_expert_path(conn, :show, health_expert))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html",
          health_expert: health_expert,
          pet_types: pet_types,
          changeset: changeset
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    health_expert = HealthExpertService.get_health_expert!(id)
    {:ok, _health_expert} = HealthExpertService.delete_health_expert(health_expert)

    conn
    |> put_flash(:info, "Health_expert deleted successfully.")
    |> redirect(to: Routes.health_expert_path(conn, :index))
  end
end

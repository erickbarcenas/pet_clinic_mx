defmodule PetClinicMxWeb.HealthExpertController do
  use PetClinicMxWeb, :controller

  alias PetClinicMx.Models.HealthExpert
  alias PetClinicMx.Services.HealthExpertService

  def index(conn, _params) do
    healt_experts = HealthExpertService.list_health_experts()
    render(conn, "index.html", healt_experts: healt_experts)
  end

  def new(conn, _params) do
    changeset = HealthExpertService.change_health_expert(%HealthExpert{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"health_expert" => health_expert_params}) do
    case HealthExpertService.create_health_expert(health_expert_params) do
      {:ok, health_expert} ->
        conn
        |> put_flash(:info, "Health_expert created successfully.")
        |> redirect(to: Routes.health_expert_path(conn, :show, health_expert))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    health_expert = HealthExpertService.get_health_expert!(id)
    render(conn, "show.html", health_expert: health_expert)
  end

  def edit(conn, %{"id" => id}) do
    health_expert = HealthExpertService.get_health_expert(id)
    changeset = HealthExpertService.change_health_expert(health_expert)
    render(conn, "edit.html", health_expert: health_expert, changeset: changeset)
  end

  def update(conn, %{"id" => id, "health_expert" => health_expert_params}) do
    health_expert = HealthExpertService.get_health_expert!(id)

    case HealthExpertService.update_health_expert(health_expert, health_expert_params) do
      {:ok, health_expert} ->
        conn
        |> put_flash(:info, "Health_expert updated successfully.")
        |> redirect(to: Routes.health_expert_path(conn, :show, health_expert))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", health_expert: health_expert, changeset: changeset)
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

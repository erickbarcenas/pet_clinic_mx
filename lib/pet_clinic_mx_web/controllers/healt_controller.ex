defmodule PetClinicMxWeb.HealtController do
  use PetClinicMxWeb, :controller

  alias PetClinicMx.PetHealthExpert
  alias PetClinicMx.PetHealthExpert.Healt

  def index(conn, _params) do
    healt_expert = PetHealthExpert.list_healt_expert()
    render(conn, "index.html", healt_expert: healt_expert)
  end

  def new(conn, _params) do
    changeset = PetHealthExpert.change_healt(%Healt{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"healt" => healt_params}) do
    case PetHealthExpert.create_healt(healt_params) do
      {:ok, healt} ->
        conn
        |> put_flash(:info, "Healt created successfully.")
        |> redirect(to: Routes.healt_path(conn, :show, healt))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    healt = PetHealthExpert.get_healt!(id)
    render(conn, "show.html", healt: healt)
  end

  def edit(conn, %{"id" => id}) do
    healt = PetHealthExpert.get_healt!(id)
    changeset = PetHealthExpert.change_healt(healt)
    render(conn, "edit.html", healt: healt, changeset: changeset)
  end

  def update(conn, %{"id" => id, "healt" => healt_params}) do
    healt = PetHealthExpert.get_healt!(id)

    case PetHealthExpert.update_healt(healt, healt_params) do
      {:ok, healt} ->
        conn
        |> put_flash(:info, "Healt updated successfully.")
        |> redirect(to: Routes.healt_path(conn, :show, healt))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", healt: healt, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    healt = PetHealthExpert.get_healt!(id)
    {:ok, _healt} = PetHealthExpert.delete_healt(healt)

    conn
    |> put_flash(:info, "Healt deleted successfully.")
    |> redirect(to: Routes.healt_path(conn, :index))
  end
end

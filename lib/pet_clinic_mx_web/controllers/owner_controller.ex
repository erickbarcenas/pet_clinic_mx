defmodule PetClinicMxWeb.OwnerController do
  use PetClinicMxWeb, :controller

  alias PetClinicMx.OwnerService
  alias PetClinicMx.OwnerService.Owner

  def index(conn, _params) do
    owners = OwnerService.list_owners()
    render(conn, "index.html", owners: owners)
  end

  def new(conn, _params) do
    changeset = OwnerService.change_owner(%Owner{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"owner" => owner_params}) do
    case OwnerService.create_owner(owner_params) do
      {:ok, owner} ->
        conn
        |> put_flash(:info, "Owner created successfully.")
        |> redirect(to: Routes.owner_path(conn, :show, owner))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    owner = OwnerService.get_owner!(id)
    render(conn, "show.html", owner: owner)
  end

  def edit(conn, %{"id" => id}) do
    owner = OwnerService.get_owner!(id)
    changeset = OwnerService.change_owner(owner)
    render(conn, "edit.html", owner: owner, changeset: changeset)
  end

  def update(conn, %{"id" => id, "owner" => owner_params}) do
    owner = OwnerService.get_owner!(id)

    case OwnerService.update_owner(owner, owner_params) do
      {:ok, owner} ->
        conn
        |> put_flash(:info, "Owner updated successfully.")
        |> redirect(to: Routes.owner_path(conn, :show, owner))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", owner: owner, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    owner = OwnerService.get_owner!(id)
    {:ok, _owner} = OwnerService.delete_owner(owner)

    conn
    |> put_flash(:info, "Owner deleted successfully.")
    |> redirect(to: Routes.owner_path(conn, :index))
  end
end

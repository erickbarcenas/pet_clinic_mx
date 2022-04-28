defmodule PetClinicMx.Repo.Migrations.CreatePetTypesTable do
  use Ecto.Migration
  use Timex
  alias PetClinicMx.Repo
  alias PetClinicMx.PetClinicService.Pet

  def change do
    # 1. Se selecciona el id y el type de todos los pets registrados
    query = "SELECT pets.id, pets.type FROM pets;"
    res = Ecto.Adapters.SQL.query!(Repo, query, [])
    # regresa dos columnas
    pets = res.rows

    # 2. Se seleccionan únicamente los valores únicos
    query = "SELECT DISTINCT type FROM pets;"
    result = Ecto.Adapters.SQL.query!(Repo, query, [])
    # regresa una columna
    types = result.rows |> List.flatten()

    # 3. Se crea una nueva tabla
    create table("pet_types") do
      add(:name, :string)
      timestamps()
    end

    flush()

    # 4. En la nueva tabla se insertan los typos únicos (obtenidos en el 2.)
    Enum.each(types, fn type ->
      query =
        "INSERT INTO pet_types (name, inserted_at, updated_at) VALUES ($1::character varying, $2, $3);"

      Ecto.Adapters.SQL.query!(Repo, query, [type, Timex.now(), Timex.now()])
    end)

    # 5. Se borra la columna type
    #    Se añade la columna pet_types
    alter table("pets") do
      remove :type
      add :type_id, references("pet_types")
    end

    flush()

    # 6. A cada pet se le va a asociar un type_id
    Enum.each(pets, fn pet ->
      # Se busca el id el type con nombre = variable
      query = "SELECT id FROM pet_types WHERE name = $1::character varying;"
      id = Enum.at(pet, 0)
      type = Enum.at(pet, 1)
      res = Ecto.Adapters.SQL.query!(Repo, query, [type])
      pet_type_id = res.rows |> List.flatten() |> Enum.at(0)

      query = "UPDATE pets SET type_id = $1::integer WHERE id = $2::integer;"
      Ecto.Adapters.SQL.query!(Repo, query, [pet_type_id, id])
    end)
  end
end

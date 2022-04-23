defmodule PetClinicMx.Repo.Migrations.CorrectPetSex do
  use Ecto.Migration
  alias PetClinicMx.Repo

  def change do
    query = "UPDATE pets SET sex = LOWER(sex)"
    Ecto.Adapters.SQL.query!(Repo, query, [])
    flush()
    query = "UPDATE pets SET sex = 'female' WHERE sex NOT IN ('male', 'female')"
    Ecto.Adapters.SQL.query!(Repo, query, [])
    flush()
  end
end

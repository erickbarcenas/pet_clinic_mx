defmodule PetClinicMx.Repo.Migrations.CreatePets do
  use Ecto.Migration

  def change do
    create table(:pets) do
      add :name, :string
      add :age, :integer
      add :type, :string
      add :sex, :string

      timestamps()
    end
  end
end

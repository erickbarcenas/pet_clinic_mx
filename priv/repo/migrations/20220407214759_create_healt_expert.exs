defmodule PetClinicMx.Repo.Migrations.CreateHealtExpert do
  use Ecto.Migration

  def up do
    create table(:healt_expert) do
      add :name, :string
      add :age, :integer
      add :email, :string
      add :specialities, :string
      add :sex, :string

      timestamps()
    end
  end

  def down do
    drop(table(:healt_expert))
  end
end

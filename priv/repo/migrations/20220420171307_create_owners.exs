defmodule PetClinicMx.Repo.Migrations.CreateOwners do
  use Ecto.Migration

  def up do
    create table(:owners) do
      add :name, :string
      add :age, :integer
      add :email, :string
      add :phone_num, :string

      timestamps()
    end
  end

  def down do
    drop(table(:owners))
  end
end

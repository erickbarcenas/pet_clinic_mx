defmodule PetClinicMx.Repo.Migrations.CreateAppointmentTable do
  use Ecto.Migration

  def change do
    create table("appointments") do
      add :pet_id, references("pets")
      add :healt_expert_id, references("healt_expert")
      add :datetime, :utc_datetime

      timestamps()
    end
  end
end

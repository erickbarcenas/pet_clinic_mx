defmodule PetClinicMx.Repo.Migrations.CreateExpertScheduleTable do
  use Ecto.Migration

  def change do
    create table("expert_schedules") do
      add :healt_expert_id, references("healt_expert")

      add :start_date, :date
      add :ending_date, :date
      add :start_hour, :time
      add :ending_hour, :time

      timestamps()
    end
  end
end

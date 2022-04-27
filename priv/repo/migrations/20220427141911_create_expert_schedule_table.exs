defmodule PetClinicMx.Repo.Migrations.CreateExpertScheduleTable do
  use Ecto.Migration

  def change do
    create table("expert_schedules") do
      add :from_monday, :time
      add :to_monday, :time
      add :from_tuesday, :time
      add :to_tuesday, :time
      add :from_wednesday, :time
      add :to_wednesday, :time
      add :from_thursday, :time
      add :to_thursday, :time
      add :from_friday, :time
      add :to_friday, :time
      add :from_saturday, :time
      add :to_saturday, :time
      add :from_sunday, :time
      add :to_sunday, :time

      add :healt_expert_id, references("healt_expert")
    end
  end
end

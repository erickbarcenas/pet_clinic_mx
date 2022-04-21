defmodule PetClinicMx.Repo.Migrations.RelationHealtExpertWithPatients do
  use Ecto.Migration

  def change do
    alter table("pets") do
      add :preferred_expert_id, references("healt_expert")
    end
  end
end

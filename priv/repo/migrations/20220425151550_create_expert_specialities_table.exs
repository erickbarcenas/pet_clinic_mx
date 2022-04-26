defmodule PetClinicMx.Repo.Migrations.CreateExpertSpecialitiesTable do
  use Ecto.Migration
  alias PetClinicMx.Repo
  # alias PetClinicMx.PetHealthExpert.Healt
  alias PetClinicMx.PetClinicService.PetType
  # use Timex
  # import Ecto.Query
  # migrar los datos de la tabla de healt expert especialities
  # después de migrarlos borrar la columna
  # specialities no sea un string sino relación many to many hacia pet type
  

  def change do
    # Nota: si se hace esto significa que del esquema trae una relación
    #       y no un string
    # healt_experts = Repo.all(Healt)

    # 1. Se selecciona el id y el type de todos los pets registrados
    query = "SELECT healt_expert.id, healt_expert.specialities FROM healt_expert;"
    res = Ecto.Adapters.SQL.query!(Repo, query, [])
    all_experts = res.rows # regresa una columna
    
    alter table("healt_expert") do
      remove :specialities
    end

    flush()

    create table("expert_specialities") do
      add :healt_expert_id, references("healt_expert")
      add :pet_type_id, references("pet_types")

      # timestamps()
    end

    flush()

    all_experts
    |> Enum.each(fn expert ->
      expert_id = Enum.at(expert, 0)
      specialities = Enum.at(expert, 1) |> String.split([" ", ","], trim: true) 

      specialities
      |> Enum.each(fn speciality ->  
        %PetType{ id: type_id } = Repo.get_by(PetType, name: speciality)
        insert = "INSERT INTO expert_specialities (healt_expert_id, pet_type_id)
                  VALUES ($1::integer, $2::integer);"

        # $3, $4                  
        # Timex.now(), Timex.now()
        Ecto.Adapters.SQL.query!(Repo, insert, [expert_id, type_id])
      end)
    end)
  end
end

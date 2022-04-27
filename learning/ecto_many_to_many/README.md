# Many to many


## 1. Cambiar a HealthExpert para que el atributo specialities sea una relación many_to_many hacia PetType. En la migración considarar migrar los datos existentes (asumiendo que están en singular en la columna) y borrar la columna anterior.

```elixir
iex> mix ecto.gen.migration create_expert_specialities_table
  Generated pet_clinic_mx app
* creating priv/repo/migrations/20220425151550_create_expert_specialities_table.exs
```


```elixir
iex> mix ecto.migrate
0:26:38.655 [info]  == Running 20220425151550 PetClinicMx.Repo.Migrations.CreateExpertSpecialitiesTable.change/0 forward

20:26:38.662 [debug] QUERY OK db=0.1ms
SELECT id, specialities FROM healt_expert; []

20:26:38.662 [info]  alter table healt_expert

20:26:38.663 [info]  create table expert_specialities
[1, "dog, cat"]

20:26:38.680 [debug] QUERY OK source="pet_types" db=4.2ms
SELECT p0."id", p0."name", p0."inserted_at", p0."updated_at" FROM "pet_types" AS p0 WHERE (p0."name" = $1) ["dog"]

20:26:38.682 [debug] QUERY OK db=1.1ms
INSERT INTO expert_specialities (healt_expert_id, pet_type_id)
                  VALUES ($1::integer, $2::integer); [1, 4]

20:26:38.682 [debug] QUERY OK source="pet_types" db=0.1ms
SELECT p0."id", p0."name", p0."inserted_at", p0."updated_at" FROM "pet_types" AS p0 WHERE (p0."name" = $1) ["cat"]


20:26:38.682 [debug] QUERY OK db=0.1ms
INSERT INTO expert_specialities (healt_expert_id, pet_type_id)
                  VALUES ($1::integer, $2::integer); [1, 2]

20:26:38.682 [debug] QUERY OK source="pet_types" db=0.1ms
SELECT p0."id", p0."name", p0."inserted_at", p0."updated_at" FROM "pet_types" AS p0 WHERE (p0."name" = $1) ["dog"]

20:26:38.683 [debug] QUERY OK db=0.1ms
INSERT INTO expert_specialities (healt_expert_id, pet_type_id)
                  VALUES ($1::integer, $2::integer); [2, 4]

20:26:38.683 [debug] QUERY OK source="pet_types" db=0.1ms
SELECT p0."id", p0."name", p0."inserted_at", p0."updated_at" FROM "pet_types" AS p0 WHERE (p0."name" = $1) ["cat"]

20:26:38.683 [debug] QUERY OK db=0.2ms
INSERT INTO expert_specialities (healt_expert_id, pet_type_id)
                  VALUES ($1::integer, $2::integer); [2, 2]

20:26:38.684 [info]  == Migrated 20220425151550 in 0.0s

```


```elixir
iex> Repo.all(Healt) |> Repo.preload(:specialities)
[
  %PetClinicMx.PetHealthExpert.Healt{
    __meta__: #Ecto.Schema.Metadata<:loaded, "healt_expert">,
    age: 24,
    email: "erick.barcenas@gmail.com",
    id: 1,
    inserted_at: ~N[2022-04-07 22:58:39],
    name: "Erick",
    patients: #Ecto.Association.NotLoaded<association :patients is not loaded>,
    sex: :male,
    specialities: [],
    updated_at: ~N[2022-04-07 22:58:39]
  },
  %PetClinicMx.PetHealthExpert.Healt{
    __meta__: #Ecto.Schema.Metadata<:loaded, "healt_expert">,
    age: 25,
    email: "pao@gmail.com",
    id: 2,
    inserted_at: ~N[2022-04-07 22:59:01],
    name: "Pao",
    patients: #Ecto.Association.NotLoaded<association :patients is not loaded>,
    sex: :female,
    specialities: [
      %PetClinicMx.PetClinicService.PetType{
        __meta__: #Ecto.Schema.Metadata<:loaded, "pet_types">,
        id: 1,
        inserted_at: ~N[2022-04-23 14:15:27],
        name: "lizard",
        updated_at: ~N[2022-04-23 14:15:27]
      },
      %PetClinicMx.PetClinicService.PetType{
        __meta__: #Ecto.Schema.Metadata<:loaded, "pet_types">,
        id: 2,
        inserted_at: ~N[2022-04-23 14:15:27],
        name: "cat",
        updated_at: ~N[2022-04-23 14:15:27]
      }
    ],
    updated_at: ~N[2022-04-07 22:59:01]
  }
]
```

## 2. Crear el esquema y migración para Appointment, debe tener los atributos y relaciones mostrados en el diagrama.


```elixir
defmodule PetClinicMx.Services.Appointment do
    use Ecto.Schema
    schema "appointments" do
      belongs_to :healt_expert, PetClinicMx.PetHealthExpert.Healt
      belongs_to :pet, PetClinicMx.PetClinicService.Pet
      
      timestamps()
    end
end

```

```elixir
iex> mix ecto.gen.migration create_appointment_table
Generated pet_clinic_mx app
* creating priv/repo/migrations/20220426022402_create_appointment_table.exs
```


## 3. Crear el esquema y migración para ExpertSchedule.  Debe mostrar los días y horarios disponibles del expert, y una relación health_expert hacia HealthExpert. Así mismo, HealthExpert debe tener una relación schedule de tipo has_one hacia ExpertSchedule.

```elixir
defmodule PetClinicMx.Services.Slots do
    use Ecto.Schema
    schema "slots" do
      field :from_time, :time	
      field :to_time, :time	
    end
end
```

```elixir
iex> mix ecto.gen.migration create_slots_table
```



```elixir

```

```elixir
iex> mix ecto.gen.migration create_expert_schedule_table

```



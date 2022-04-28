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
      field :datetime, :utc_datetime

      belongs_to :healt_expert, PetClinicMx.PetHealthExpert.Healt
      belongs_to :pet, PetClinicMx.PetClinicService.Pet
      # timestamps()
    end
end

```

```elixir
defmodule PetClinicMx.Repo.Migrations.CreateAppointmentTable do
  use Ecto.Migration

  def change do
    create table("appointments") do
      add :pet_id, references("pets")
      add :healt_expert_id, references("healt_expert")
      add :datetime, :utc_datetime
    end
  end
end
```

```elixir
iex> mix ecto.migrate
Compiling 1 file (.ex)

08:53:47.718 [info]  == Running 20220426022402 PetClinicMx.Repo.Migrations.CreateAppointmentTable.change/0 forward

08:53:47.720 [info]  create table appointments

08:53:47.745 [info]  == Migrated 20220426022402 in 0.0s

```



```elixir
iex> mix ecto.gen.migration create_appointment_table
Generated pet_clinic_mx app
* creating priv/repo/migrations/20220426022402_create_appointment_table.exs
```


## 3. Crear el esquema y migración para ExpertSchedule.  Debe mostrar los días y horarios disponibles del expert, y una relación health_expert hacia HealthExpert. Así mismo, HealthExpert debe tener una relación schedule de tipo has_one hacia ExpertSchedule.

```elixir
iex> mix ecto.gen.migration create_expert_schedule_table
Compiling 1 file (.ex)
* creating priv/repo/migrations/20220427141911_create_expert_schedule_table.exs
```


```elixir
defmodule PetClinicMx.Services.ExpertSchedule do
    use Ecto.Schema
    schema "expert_schedules" do
        field :from_monday, :time
        field :to_monday, :time
        field :from_tuesday, :time
        field :to_tuesday, :time
        field :from_wednesday, :time
        field :to_wednesday, :time
        field :from_thursday, :time
        field :to_thursday, :time
        field :from_friday, :time
        field :to_friday, :time
        field :from_saturday, :time
        field :to_saturday, :time
        field :from_sunday, :time
        field :to_sunday, :time
        
        belongs_to :healt_expert, PetClinicMx.PetHealthExpert.Healt
    end
end

```

```elixir
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
```

```elixir
iex> mix ecto.migrate
Compiling 1 file (.ex)

09:21:58.781 [info]  == Running 20220427141911 PetClinicMx.Repo.Migrations.CreateExpertScheduleTable.change/0 forward

09:21:58.783 [info]  create table expert_schedules

09:21:58.796 [info]  == Migrated 20220427141911 in 0.0s
```


## 4. Crear un servicio AppointmentService con las siguientes funciones:

```elixir
def available_slots(expert_id, from_date, to_date) do
    ...
end

def new_appointment(expert_id, pet_id, datetime) do
    ...
end
```

```elixir
iex> AppointmentService.available_slots(1, ~D[2022-04-26], ~D[2022-04-29])
{:ok,
 %{
   ~D[2022-04-28] => [~T[10:00:00], ~T[10:30:00], ~T[11:00:00], ~T[11:30:00],
    ~T[12:00:00], ~T[12:30:00], ~T[13:00:00], ~T[13:30:00], ~T[14:00:00],
    ~T[14:30:00], ~T[15:00:00], ~T[15:30:00], ~T[16:00:00], ~T[16:30:00],
    ~T[17:00:00], ~T[17:30:00], ~T[18:00:00], ~T[18:30:00], ~T[19:00:00],
    ~T[19:30:00]]
 }}
```
```elixir
iex> AppointmentService.new_appointment(1, 2, ~N[2022-04-26 15:00:00])
{:ok,
 %PetClinicMx.Models.Appointment{
   __meta__: #Ecto.Schema.Metadata<:loaded, "appointments">,
   datetime: ~U[2022-04-26 15:00:00Z],
   healt_expert: #Ecto.Association.NotLoaded<association :healt_expert is not loaded>,
   healt_expert_id: 1,
   id: 1,
   inserted_at: ~N[2022-04-28 17:24:25],
   pet: #Ecto.Association.NotLoaded<association :pet is not loaded>,
   pet_id: 1,
   updated_at: ~N[2022-04-28 17:24:25]
 }}
```
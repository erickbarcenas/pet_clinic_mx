# Ecto and Catalogs

## Configuración inicial
```elixir
iex> iex -S mix phx.server # levantar el servidor
iex> import Ecto.Query # importamos
iex> alias PetClinicMx.Repo # añadimos alias 
iex> alias PetClinicMx.PetClinicService.Pet
iex> alias PetClinicMx.PetHealthExpert.Healt
iex> alias PetClinicMx.OwnerService.Owner
iex> import Ecto.Changeset
```

## Instrucciones 
## 1. Cambiar el atributo sex en Pet y HealthExpert para que usen enums (Ecto.Enum)
```elixir
  schema "pets" do
    field :age, :integer, default: 1
    field :name, :string
    field :sex, Ecto.Enum, values: [:male, :female]
    field :type, :string

    belongs_to(:owner, PetClinicMx.OwnerService.Owner, foreign_key: :owner_id)
    belongs_to(:preferred_expert, PetClinicMx.PetHealthExpert.Healt, foreign_key: :preferred_expert_id)

    timestamps()
  end
```

```elixir
  schema "healt_expert" do
    field :age, :integer
    field :email, :string
    field :name, :string
    field :sex, Ecto.Enum, values: [:male, :female]
    field :specialities, :string

    has_many(:patients, PetClinicMx.PetClinicService.Pet, foreign_key: :preferred_expert_id)

    timestamps()
  end
```

## 2. Crear una migración para corregir el sexo en Pet y HealthExpert, usar un default para cuando no se sabe bien el sexo.

Primero se crea un error a propósito dado que los Pets tienen sexos correctos.
Nota: recordar que los modelos deben de estar de la siguiente manera
PetClinicMx.PetClinicService.Pet: `field :sex, :string`
PetClinicMx.PetHealthExpert.Healt: `field :sex, :string`

### Pet
**Ejemplo 1**
```elixir
iex> phoenix = Repo.get_by!(Pet, name: "phoenix")
%PetClinicMx.PetClinicService.Pet{
  __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
  age: 4,
  id: 2,
  inserted_at: ~N[2022-04-07 22:55:59],
  name: "phoenix",
  owner: #Ecto.Association.NotLoaded<association :owner is not loaded>,
  owner_id: nil,
  preferred_expert: #Ecto.Association.NotLoaded<association :preferred_expert is not loaded>,
  preferred_expert_id: 1,
  sex: :female,
  type: "cat",
  updated_at: ~N[2022-04-21 12:11:13]
}
```

```elixir
iex> phoenix |> change(%{sex: "Male"}) |> Repo.update()
{:ok,
 %PetClinicMx.PetClinicService.Pet{
   __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
   age: 4,
   id: 2,
   inserted_at: ~N[2022-04-07 22:55:59],
   name: "phoenix",
   owner: #Ecto.Association.NotLoaded<association :owner is not loaded>,
   owner_id: nil,
   preferred_expert: #Ecto.Association.NotLoaded<association :preferred_expert is not loaded>,
   preferred_expert_id: 1,
   sex: "Male",
   type: "cat",
   updated_at: ~N[2022-04-23 11:01:26]
 }}
```

**Ejemplo 2**
```elixir
iex> ecto = Repo.get_by!(Pet, name: "ecto")
%PetClinicMx.PetClinicService.Pet{
  __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
  age: 3,
  id: 9,
  inserted_at: ~N[2022-04-20 13:29:31],
  name: "ecto",
  owner: #Ecto.Association.NotLoaded<association :owner is not loaded>,
  owner_id: nil,
  preferred_expert: #Ecto.Association.NotLoaded<association :preferred_expert is not loaded>,
  preferred_expert_id: 2,
  sex: "male",
  type: "cat",
  updated_at: ~N[2022-04-21 12:15:25]
}
```
```elixir
iex> ecto |> change(%{sex: "feMalee"}) |> Repo.update()
{:ok,
 %PetClinicMx.PetClinicService.Pet{
   __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
   age: 3,
   id: 9,
   inserted_at: ~N[2022-04-20 13:29:31],
   name: "ecto",
   owner: #Ecto.Association.NotLoaded<association :owner is not loaded>,
   owner_id: nil,
   preferred_expert: #Ecto.Association.NotLoaded<association :preferred_expert is not loaded>,
   preferred_expert_id: 2,
   sex: "feMalee",
   type: "cat",
   updated_at: ~N[2022-04-23 11:04:24]
 }}
```
### HealthExpert

Ahora se cambian los esquemas 
PetClinicMx.PetClinicService.Pet: `field :sex, :string`
PetClinicMx.PetHealthExpert.Healt: `field :sex, :string`

```elixir
iex> animals = Repo.all(Pet) |> Repo.preload(:preferred_expert)
** (ArgumentError) cannot load `"Male"` as type {:parameterized, Ecto.Enum, %{mappings: [male: "male", female: "female"], on_cast: %{"female" => :female, "male" => :male}, on_dump: %{female: "female", male: "male"}, on_load: %{"female" => :female, "male" => :male}, type: :string}} for field :sex in %PetClinicMx.PetClinicService.Pet{__meta__: #Ecto.Schema.Metadata<:loaded, "pets">, age: 1, id: nil, inserted_at: nil, name: nil, owner: #Ecto.Association.NotLoaded<association :owner is not loaded>, owner_id: nil, preferred_expert: #Ecto.Association.NotLoaded<association :preferred_expert is not loaded>, preferred_expert_id: nil, sex: nil, type: nil, updated_at: nil}
    (ecto 3.7.2) lib/ecto/repo/queryable.ex:409: Ecto.Repo.Queryable.struct_load!/6
    (ecto 3.7.2) lib/ecto/repo/queryable.ex:233: anonymous fn/5 in Ecto.Repo.Queryable.preprocessor/3
    (elixir 1.13.3) lib/enum.ex:1593: Enum."-map/2-lists^map/1-0-"/2 
    (elixir 1.13.3) lib/enum.ex:1593: Enum."-map/2-lists^map/1-0-"/2
    (ecto 3.7.2) lib/ecto/repo/queryable.ex:224: Ecto.Repo.Queryable.execute/4
    (ecto 3.7.2) lib/ecto/repo/queryable.ex:19: Ecto.Repo.Queryable.all/3

```

Ahora se tienen que solucionar el problema
```elixir
iex> mix ecto.gen.migration correct_pet_sex
* creating priv/repo/migrations/20220423112247_correct_pet_sex.exs
```

```elixir
defmodule PetClinicMx.Repo.Migrations.CorrectPetSex do
  use Ecto.Migration
  alias PetClinicMx.Repo

  def change do
    query = "UPDATE pets SET sex = LOWER(sex)"
    Ecto.Adapters.SQL.query!(Repo, query, [])
    flush()
    query = "UPDATE pets SET sex = 'female' WHERE sex NOT IN ('male', 'female')"
    Ecto.Adapters.SQL.query!(Repo, query, [])
    flush()
  end
end

```

```elixir
iex> mix ecto.migrate
06:38:14.657 [info]  == Running 20220423112247 PetClinicMx.Repo.Migrations.CorrectPetSex.change/0 forward

06:38:14.663 [debug] QUERY OK db=0.3ms
UPDATE pets SET sex = LOWER(sex) []

06:38:14.664 [debug] QUERY OK db=0.5ms
UPDATE pets SET sex = 'female' WHERE sex NOT IN ('male', 'female') []

06:38:14.678 [info]  == Migrated 20220423112247 in 0.0s

```

```elixir
iex> animals = Repo.all(Pet) |> Repo.preload(:preferred_expert)
[
  %PetClinicMx.PetClinicService.Pet{
    __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
    age: 3,
    id: 1,
    inserted_at: ~N[2022-04-07 22:55:37],
    name: "Coco",
    owner: #Ecto.Association.NotLoaded<association :owner is not loaded>,
    owner_id: nil,
    preferred_expert: nil,
    preferred_expert_id: nil,
    sex: :male,
    type: "cat",
    updated_at: ~N[2022-04-07 22:55:37]
  },
  %PetClinicMx.PetClinicService.Pet{
    __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
    age: 2,
    id: 8,
    inserted_at: ~N[2022-04-07 22:57:43],
    name: "Coco", 
    owner: #Ecto.Association.NotLoaded<association :owner is not loaded>,
    owner_id: nil,
    preferred_expert: nil,
    preferred_expert_id: nil,
    sex: :male,
    type: "mice", 
    updated_at: ~N[2022-04-07 22:57:43]
  },
  %PetClinicMx.PetClinicService.Pet{
    __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
    age: 5,
    id: 4,
    inserted_at: ~N[2022-04-07 22:56:36],
    name: "Simba",
    owner: #Ecto.Association.NotLoaded<association :owner is not loaded>,
    owner_id: nil,
    preferred_expert: %PetClinicMx.PetHealthExpert.Healt{
      __meta__: #Ecto.Schema.Metadata<:loaded, "healt_expert">,
      age: 24,
      email: "erick.barcenas@gmail.com",
      id: 1,
      inserted_at: ~N[2022-04-07 22:58:39],
      name: "Erick",
      patients: #Ecto.Association.NotLoaded<association :patients is not loaded>,
      sex: :male,
      specialities: "cat",
      updated_at: ~N[2022-04-07 22:58:39]
    },
    preferred_expert_id: 1,
    sex: :male,
    type: "snake",
    updated_at: ~N[2022-04-21 12:13:57]
  },
  %PetClinicMx.PetClinicService.Pet{
    __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
    age: 7,
    id: 5,
    inserted_at: ~N[2022-04-07 22:56:58],
    name: "Leo",
    owner: #Ecto.Association.NotLoaded<association :owner is not loaded>,
    owner_id: nil,
    preferred_expert: %PetClinicMx.PetHealthExpert.Healt{
      __meta__: #Ecto.Schema.Metadata<:loaded, "healt_expert">,
      age: 24,
      email: "erick.barcenas@gmail.com",
      id: 1,
      inserted_at: ~N[2022-04-07 22:58:39],
      name: "Erick",
      patients: #Ecto.Association.NotLoaded<association :patients is not loaded>,
      sex: :male,
      specialities: "cat",
      updated_at: ~N[2022-04-07 22:58:39]
    },
    preferred_expert_id: 1,
    sex: :male,
    type: "lizard",
    updated_at: ~N[2022-04-21 12:14:27]
  },
  %PetClinicMx.PetClinicService.Pet{
    __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
    age: 3,
    id: 6,
    inserted_at: ~N[2022-04-07 22:57:13],
    name: "frog",
    owner: #Ecto.Association.NotLoaded<association :owner is not loaded>,
    owner_id: nil,
    preferred_expert: %PetClinicMx.PetHealthExpert.Healt{
      __meta__: #Ecto.Schema.Metadata<:loaded, "healt_expert">,
      age: 24,
      email: "erick.barcenas@gmail.com",
      id: 1,
      inserted_at: ~N[2022-04-07 22:58:39],
      name: "Erick",
      patients: #Ecto.Association.NotLoaded<association :patients is not loaded>,
      sex: :male,
      specialities: "cat",
      updated_at: ~N[2022-04-07 22:58:39]
    },
    preferred_expert_id: 1,
    sex: :male,
    type: "dog",
    updated_at: ~N[2022-04-21 12:14:43]
  },
  %PetClinicMx.PetClinicService.Pet{
    __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
    age: 3,
    id: 7,
    inserted_at: ~N[2022-04-07 22:57:27],
    name: "Lucas",
    owner: #Ecto.Association.NotLoaded<association :owner is not loaded>,
    owner_id: nil,
    preferred_expert: %PetClinicMx.PetHealthExpert.Healt{
      __meta__: #Ecto.Schema.Metadata<:loaded, "healt_expert">,
      age: 24,
      email: "erick.barcenas@gmail.com",
      id: 1,
      inserted_at: ~N[2022-04-07 22:58:39],
      name: "Erick",
      patients: #Ecto.Association.NotLoaded<association :patients is not loaded>,
      sex: :male,
      specialities: "cat",
      updated_at: ~N[2022-04-07 22:58:39]
    },
    preferred_expert_id: 1,
    sex: :female,
    type: "cat",
    updated_at: ~N[2022-04-21 12:15:00]
  },
  %PetClinicMx.PetClinicService.Pet{
    __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
    age: 1,
    id: 10,
    inserted_at: ~N[2022-04-20 23:24:50],
    name: "chocolata",
    owner: #Ecto.Association.NotLoaded<association :owner is not loaded>,
    owner_id: nil,
    preferred_expert: %PetClinicMx.PetHealthExpert.Healt{
      __meta__: #Ecto.Schema.Metadata<:loaded, "healt_expert">,
      age: 25,
      email: "pao@gmail.com",
      id: 2,
      inserted_at: ~N[2022-04-07 22:59:01],
      name: "Pao",
      patients: #Ecto.Association.NotLoaded<association :patients is not loaded>,
      sex: :female,
      specialities: "dog",
      updated_at: ~N[2022-04-07 22:59:01]
    },
    preferred_expert_id: 2,
    sex: :female,
    type: "dog",
    updated_at: ~N[2022-04-21 12:15:40]
  },
  %PetClinicMx.PetClinicService.Pet{
    __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
    age: 4,
    id: 2,
    inserted_at: ~N[2022-04-07 22:55:59],
    name: "phoenix",
    owner: #Ecto.Association.NotLoaded<association :owner is not loaded>,
    owner_id: nil,
    preferred_expert: %PetClinicMx.PetHealthExpert.Healt{
      __meta__: #Ecto.Schema.Metadata<:loaded, "healt_expert">,
      age: 24,
      email: "erick.barcenas@gmail.com",
      id: 1,
      inserted_at: ~N[2022-04-07 22:58:39],
      name: "Erick",
      patients: #Ecto.Association.NotLoaded<association :patients is not loaded>,
      sex: :male,
      specialities: "cat",
      updated_at: ~N[2022-04-07 22:58:39]
    },
    preferred_expert_id: 1,
    sex: :male,
    type: "cat",
    updated_at: ~N[2022-04-23 11:01:26]
  },
  %PetClinicMx.PetClinicService.Pet{
    __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
    age: 3,
    id: 9,
    inserted_at: ~N[2022-04-20 13:29:31],
    name: "ecto",
    owner: #Ecto.Association.NotLoaded<association :owner is not loaded>,
    owner_id: nil,
    preferred_expert: %PetClinicMx.PetHealthExpert.Healt{
      __meta__: #Ecto.Schema.Metadata<:loaded, "healt_expert">,
      age: 25,
      email: "pao@gmail.com",
      id: 2,
      inserted_at: ~N[2022-04-07 22:59:01],
      name: "Pao",
      patients: #Ecto.Association.NotLoaded<association :patients is not loaded>,
      sex: :female,
      specialities: "dog",
      updated_at: ~N[2022-04-07 22:59:01]
    },
    preferred_expert_id: 2,
    sex: :female,
    type: "cat",
    updated_at: ~N[2022-04-23 11:04:24]
  }
]

```
## 3. Cambiar Pet para que type no sea un string, sino un catálogo PetType. Esto implica:
  ## - Crear el schema de PetType


```elixir
defmodule PetClinicMx.PetClinicService.PetType do
    use Ecto.Schema
    import Ecto.Changeset
  
    schema "pet_types" do
      field :name, :string
      
      timestamps()
    end
  end
```

  ## - Crear la migración para crear la tabla, cambiar la relación de pet y migrar los datos.
  ## - En este último punto, hacer la migración de datos con sql (Ecto.Adapters.SQL.query!), de tal manera que todos los cambios se puedan mandar en un solo commit junto con los cambios en el schema de Pet.

  ```elixir
iex> mix ecto.gen.migration create_pet_types_table
```

```elixir
defmodule PetClinicMx.Repo.Migrations.CreatePetTypesTable do
  use Ecto.Migration

  def change do
    create table("pet_types") do
      add(:name, :string)
      timestamps()
    end
  end
end
```

```elixir
iex> mix ecto.migrate
09:15:26.886 [debug] QUERY OK db=0.1ms
SELECT id FROM pet_types WHERE name = $1::character varying; ["cat"]

09:15:26.888 [debug] QUERY OK db=0.2ms
UPDATE pets SET type_id = $1::integer WHERE id = $2::integer; [2, 1]

09:15:26.888 [debug] QUERY OK db=0.1ms
SELECT id FROM pet_types WHERE name = $1::character varying; ["mice"]

09:15:26.888 [debug] QUERY OK db=0.1ms
UPDATE pets SET type_id = $1::integer WHERE id = $2::integer; [3, 8]

09:15:26.889 [debug] QUERY OK db=0.0ms
SELECT id FROM pet_types WHERE name = $1::character varying; ["snake"]

09:15:26.889 [debug] QUERY OK db=0.1ms
UPDATE pets SET type_id = $1::integer WHERE id = $2::integer; [5, 4]

09:15:26.889 [debug] QUERY OK db=0.0ms
SELECT id FROM pet_types WHERE name = $1::character varying; ["lizard"]

09:15:26.889 [debug] QUERY OK db=0.1ms
UPDATE pets SET type_id = $1::integer WHERE id = $2::integer; [1, 5]

09:15:26.889 [debug] QUERY OK db=0.0ms
SELECT id FROM pet_types WHERE name = $1::character varying; ["dog"]

09:15:26.890 [debug] QUERY OK db=0.1ms
UPDATE pets SET type_id = $1::integer WHERE id = $2::integer; [4, 6]

09:15:26.890 [debug] QUERY OK db=0.0ms
SELECT id FROM pet_types WHERE name = $1::character varying; ["cat"]

09:15:26.890 [debug] QUERY OK db=0.1ms
UPDATE pets SET type_id = $1::integer WHERE id = $2::integer; [2, 7]

09:15:26.890 [debug] QUERY OK db=0.0ms
SELECT id FROM pet_types WHERE name = $1::character varying; ["dog"]

09:15:26.890 [debug] QUERY OK db=0.1ms
UPDATE pets SET type_id = $1::integer WHERE id = $2::integer; [4, 10]

09:15:26.891 [debug] QUERY OK db=0.0ms
SELECT id FROM pet_types WHERE name = $1::character varying; ["cat"]

09:15:26.891 [debug] QUERY OK db=0.1ms
UPDATE pets SET type_id = $1::integer WHERE id = $2::integer; [2, 2]

09:15:26.891 [debug] QUERY OK db=0.0ms
SELECT id FROM pet_types WHERE name = $1::character varying; ["cat"]

09:15:26.891 [debug] QUERY OK db=0.0ms
UPDATE pets SET type_id = $1::integer WHERE id = $2::integer; [2, 9]

09:15:26.892 [info]  == Migrated 20220423121651 in 0.0s
```


## Link a c/u de las migraciones

[CorrectPetSex](https://github.com/erickbarcenas/pet_clinic_mx/blob/main/priv/repo/migrations/20220423112247_correct_pet_sex.exs)	

[CreatePetTypesTable](https://github.com/erickbarcenas/pet_clinic_mx/blob/main/priv/repo/migrations/20220423121651_create_pet_types_table.exs)	



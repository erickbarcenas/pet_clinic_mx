# Ecto One To Many

![Schema](https://github.com/erickbarcenas/pet_clinic_mx/blob/main/learning/ecto_one_to_many/assets/schema.png)


## 1. Usando generadores, crear Owner (name, age, email, phone_num).

```elixir
iex> mix phx.gen.html OwnerService Owner owners name:string age:integer email:string phone_num:string

* creating lib/pet_clinic_mx_web/controllers/owner_controller.ex
* creating lib/pet_clinic_mx_web/templates/owner/edit.html.heex
* creating lib/pet_clinic_mx_web/templates/owner/form.html.heex
* creating lib/pet_clinic_mx_web/templates/owner/index.html.heex
* creating lib/pet_clinic_mx_web/templates/owner/new.html.heex
* creating lib/pet_clinic_mx_web/templates/owner/show.html.heex
* creating lib/pet_clinic_mx_web/views/owner_view.ex
* creating test/pet_clinic_mx_web/controllers/owner_controller_test.exs
* creating lib/pet_clinic_mx/owner_service/owner.ex
* creating priv/repo/migrations/20220420171307_create_owners.exs
* creating lib/pet_clinic_mx/owner_service.ex
* injecting lib/pet_clinic_mx/owner_service.ex
* creating test/pet_clinic_mx/owner_service_test.exs
* injecting test/pet_clinic_mx/owner_service_test.exs
* creating test/support/fixtures/owner_service_fixtures.ex
* injecting test/support/fixtures/owner_service_fixtures.ex

Add the resource to your browser scope in lib/pet_clinic_mx_web/router.ex:

    resources "/owners", OwnerController


Remember to update your repository by running migrations:

    $ mix ecto.migrate

```

```elixir
iex> mix ecto.migrate
Compiling 5 files (.ex)
Generated pet_clinic_mx app

12:13:47.823 [info]  == Running 20220420171307 PetClinicMx.Repo.Migrations.CreateOwners.change/0 forward

12:13:47.826 [info]  create table owners

12:13:47.849 [info]  == Migrated 20220420171307 in 0.0s
```

## 2. Agregar algunos owners.


```elixir
iex> iex -S mix phx.server # levantar el servidor
iex> import Ecto.Query # importamos
iex> alias PetClinicMx.Repo # añadimos alias 
iex> alias PetClinicMx.PetClinicService.Pet
iex> alias PetClinicMx.PetHealthExpert.Healt
iex> alias PetClinicMx.OwnerService.Owner
```
pet = Repo.get!(Pet, 1) |> Repo.preload(:owner)

```elixir
iex> Repo.insert(%Owner{age: 23, email: "erick.barcenas@bunsan.io", name: "erick", phone_num: "+5212284806275"})
{:ok,
 %PetClinicMx.OwnerService.Owner{
   __meta__: #Ecto.Schema.Metadata<:loaded, "owners">,
   age: 23,
   email: "erick.barcenas@bunsan.io",
   id: 1,
   inserted_at: ~N[2022-04-20 21:48:08],
   name: "erick",
   pets: #Ecto.Association.NotLoaded<association :pets is not loaded>,
   phone_num: "+5212284806275",
   updated_at: ~N[2022-04-20 21:48:08]
 }}
```


```elixir
iex> Repo.insert(%Owner{age: 25, email: "daniel@bunsan.io", name: "Daniel", phone_num: "+5215613558752"})
{:ok,
 %PetClinicMx.OwnerService.Owner{
   __meta__: #Ecto.Schema.Metadata<:loaded, "owners">,
   age: 25,
   email: "daniel@bunsan.io",
   id: 2,
   inserted_at: ~N[2022-04-20 21:49:40],
   name: "Daniel",
   pets: #Ecto.Association.NotLoaded<association :pets is not loaded>,
   phone_num: "+5215613558752",
   updated_at: ~N[2022-04-20 21:49:40]
 }}
```


```elixir
iex> Repo.insert(%Owner{age: 25, email: "bob@bunsan.io", name: "Bob", phone_num: "+5212284806273"})
{:ok,
 %PetClinicMx.OwnerService.Owner{
   __meta__: #Ecto.Schema.Metadata<:loaded, "owners">,
   age: 25,
   email: "bob@bunsan.io",
   id: 3,
   inserted_at: ~N[2022-04-20 21:50:35],
   name: "Bob",
   pets: #Ecto.Association.NotLoaded<association :pets is not loaded>,
   phone_num: "+5212284806273",
   updated_at: ~N[2022-04-20 21:50:35]
 }}
```

## 3. Agregar la relación entre Pet y Owner (pet.owner y owner.pets). Modelo y migración.


```elixir
iex> mix ecto.gen.migration relation_owner_with_pets
* creating priv/repo/migrations/20220420172007_relation_owner_with_pets.exs
```

```elixir
defmodule PetClinicMx.Repo.Migrations.RelationOwnerWithPets do
  use Ecto.Migration
  
  def change do
    alter table("pets") do
      add :owner_id, references("owners")
    end
  end
end
```



```elixir
defmodule PetClinicMx.OwnerService.Owner do
  use Ecto.Schema
  import Ecto.Changeset

  schema "owners" do
    field :age, :integer
    field :email, :string
    field :name, :string
    field :phone_num, :string
    
    has_many :pets, PetClinicMx.PetClinicService.Pet

    timestamps()
  end

  @doc false
  def changeset(owner, attrs) do
    owner
    |> cast(attrs, [:name, :age, :email, :phone_num])
    |> validate_required([:name, :age, :email, :phone_num])
  end
end
```

```elixir
defmodule PetClinicMx.PetClinicService.Pet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pets" do
    field :age, :integer
    field :name, :string
    field :sex, :string
    field :type, :string

    belongs_to :owner, PetClinicMx.OwnerService.Owner
    belongs_to :healt, PetClinicMx.PetHealthExpert.Healt 

    timestamps()
  end

  @doc false
  def changeset(pet, attrs) do
    pet
    |> cast(attrs, [:name, :age, :type, :sex])
    |> validate_required([:name, :age, :type, :sex])
  end
end
```
En caso de existir un warning ejecutar después de mix ecto.migrate
```elixir
mix do clean, compile
```

```elixir
mix ecto.migrate
```
## 4. Asociar owners con pets (mandar iex + resultado).
A continuación se comprueba la relación bidireccional.

```elixir
iex> pet = %Pet{name: "chocolata", type: "dog", age: 1, sex: "female", owner_id: 3}
%PetClinicMx.PetClinicService.Pet{
  __meta__: #Ecto.Schema.Metadata<:built, "pets">,
  age: 1,
  id: nil,
  inserted_at: nil,
  name: "chocolata",
  owner: #Ecto.Association.NotLoaded<association :owner is not loaded>,
  owner_id: 3,
  sex: "female",
  type: "dog",
  updated_at: nil
}
iex> Repo.insert(pet)
%PetClinicMx.PetClinicService.Pet{
  __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
  age: 1,
  id: 10,
  inserted_at: ~N[2022-04-20 23:24:50],
  name: "chocolata",
  owner: %PetClinicMx.OwnerService.Owner{
    __meta__: #Ecto.Schema.Metadata<:loaded, "owners">,
    age: 25,
    email: "bob@bunsan.io",
    id: 3,
    inserted_at: ~N[2022-04-20 21:50:35],
    name: "Bob",
    pets: #Ecto.Association.NotLoaded<association :pets is not loaded>,
    phone_num: "+5212284806273",
    updated_at: ~N[2022-04-20 21:50:35]
  },
  owner_id: 3,
  sex: "female",
  type: "dog",
  updated_at: ~N[2022-04-20 23:24:50]
}
```

```elixir
iex> Repo.get_by(Owner, name: "Bob") |> Repo.preload(:pets)
%PetClinicMx.OwnerService.Owner{
  __meta__: #Ecto.Schema.Metadata<:loaded, "owners">,
  age: 25,
  email: "bob@bunsan.io",
  id: 3,
  inserted_at: ~N[2022-04-20 21:50:35],
  name: "Bob",
  pets: [
    %PetClinicMx.PetClinicService.Pet{
      __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
      age: 1,
      id: 10,
      inserted_at: ~N[2022-04-20 23:24:50],
      name: "chocolata",
      owner: #Ecto.Association.NotLoaded<association :owner is not loaded>,
      owner_id: 3,
      sex: "female",
      type: "dog",
      updated_at: ~N[2022-04-20 23:24:50]
    }
  ],
  phone_num: "+5212284806273",
  updated_at: ~N[2022-04-20 21:50:35]
}
```
Se buscan pets que no tengan dueño y se les asigna alguno
```elixir
iex> phoenix = Repo.get_by(Pet, name: "phoenix") |> Repo.preload(:owner)
%PetClinicMx.PetClinicService.Pet{
  __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
  age: 4,
  id: 2,
  inserted_at: ~N[2022-04-07 22:55:59],
  name: "phoenix",
  owner: nil,
  owner_id: nil,
  sex: "female",
  type: "cat",
  updated_at: ~N[2022-04-20 13:20:58]
}
```

```elixir
iex> import Ecto.Changeset
```

```elixir
bob = Repo.get_by(Owner, name: "Bob")
%PetClinicMx.OwnerService.Owner{
  __meta__: #Ecto.Schema.Metadata<:loaded, "owners">,
  age: 25,
  email: "bob@bunsan.io",
  id: 3,
  inserted_at: ~N[2022-04-20 21:50:35],
  name: "Bob",
  pets: #Ecto.Association.NotLoaded<association :pets is not loaded>,
  phone_num: "+5212284806273",
  updated_at: ~N[2022-04-20 21:50:35]
}
```

```elixir
iex> chset = phoenix |> change() |> put_assoc(:owner, bob)
#Ecto.Changeset<
  action: nil,
  changes: %{
    owner: #Ecto.Changeset<action: :update, changes: %{}, errors: [],
     data: #PetClinicMx.OwnerService.Owner<>, valid?: true>
  },
  errors: [],
  data: #PetClinicMx.PetClinicService.Pet<>,
  valid?: true
>
```

```elixir
iex> Repo.update(chset)
{:ok,
 %PetClinicMx.PetClinicService.Pet{
   __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
   age: 4,
   id: 2,
   inserted_at: ~N[2022-04-07 22:55:59],
   name: "phoenix",
   owner: %PetClinicMx.OwnerService.Owner{
     __meta__: #Ecto.Schema.Metadata<:loaded, "owners">,
     age: 25,
     email: "bob@bunsan.io",
     id: 3,
     inserted_at: ~N[2022-04-20 21:50:35],
     name: "Bob",
     pets: #Ecto.Association.NotLoaded<association :pets is not loaded>,
     phone_num: "+5212284806273",
     updated_at: ~N[2022-04-20 21:50:35]
   },
   owner_id: 3,
   sex: "female",
   type: "cat",
   updated_at: ~N[2022-04-20 23:59:07]
 }}
```
### 4.1 Consultar 2 pets con la asociación hacia owner precargada.
```elixir
iex> with_owners = Repo.all(from p in Pet, where: p.owner_id > 0, select: [p.name])
[["chocolata"], ["phoenix"]]
```
```elixir
iex> chocolata = Repo.get_by(Pet, name: "chocolata") |> Repo.preload(:owner)
%PetClinicMx.PetClinicService.Pet{
  __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
  age: 1,
  id: 10,
  inserted_at: ~N[2022-04-20 23:24:50],
  name: "chocolata",
  owner: %PetClinicMx.OwnerService.Owner{
    __meta__: #Ecto.Schema.Metadata<:loaded, "owners">,
    age: 25,
    email: "bob@bunsan.io",
    id: 3,
    inserted_at: ~N[2022-04-20 21:50:35],
    name: "Bob",
    pets: #Ecto.Association.NotLoaded<association :pets is not loaded>,
    phone_num: "+5212284806273",
    updated_at: ~N[2022-04-20 21:50:35]
  },
  owner_id: 3,
  sex: "female",
  type: "dog",
  updated_at: ~N[2022-04-20 23:24:50]
}
```
```elixir
iex> phoenix = Repo.get_by(Pet, name: "phoenix") |> Repo.preload(:owner)
%PetClinicMx.PetClinicService.Pet{
  __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
  age: 4,
  id: 2,
  inserted_at: ~N[2022-04-07 22:55:59],
  name: "phoenix",
  owner: %PetClinicMx.OwnerService.Owner{
    __meta__: #Ecto.Schema.Metadata<:loaded, "owners">,
    age: 25,
    email: "bob@bunsan.io",
    id: 3,
    inserted_at: ~N[2022-04-20 21:50:35],
    name: "Bob",
    pets: #Ecto.Association.NotLoaded<association :pets is not loaded>,
    phone_num: "+5212284806273",
    updated_at: ~N[2022-04-20 21:50:35] 
  },
  owner_id: 3,
  sex: "female",
  type: "cat",
  updated_at: ~N[2022-04-20 23:59:07]
}
```

### 4.2 Usando put_assoc, asociar c/u de esos pets con algún owner.
```elixir
iex> ownerless = Repo.all(from p in Pet, where: is_nil(p.owner_id), select: [p.name])
[["Coco"], ["Simba"], ["Leo"], ["frog"], ["Lucas"], ["Coco"], ["ecto"]]
```

### 4.3 Consultar el owner anterior, precargando la asociación con pets.
```elixir
iex> Repo.all(Owner) |> Repo.preload(:pets) |> Enum.filter(fn o -> Enum.count(o.pets) == 0 end)
[
  %PetClinicMx.OwnerService.Owner{
    __meta__: #Ecto.Schema.Metadata<:loaded, "owners">,
    age: 23,
    email: "erick.barcenas@bunsan.io",
    id: 1,
    inserted_at: ~N[2022-04-20 21:48:08],
    name: "erick",
    pets: [],
    phone_num: "+5212284806275",
    updated_at: ~N[2022-04-20 21:48:08]
  },
  %PetClinicMx.OwnerService.Owner{ 
    __meta__: #Ecto.Schema.Metadata<:loaded, "owners">,
    age: 25,
    email: "daniel@bunsan.io",
    id: 2,
    inserted_at: ~N[2022-04-20 21:49:40],
    name: "Daniel",
    pets: [],
    phone_num: "+5215613558752", 
    updated_at: ~N[2022-04-20 21:49:40]
  }
]
```
Coco al estar no se utilizará.

Al owner erick* le se asignarán los siguientes pets:
[["Simba"], ["Leo"], ["frog"]]

```elixir
iex> simba = Repo.get_by(Pet, name: "Simba") |> Repo.preload(:owner)
%PetClinicMx.PetClinicService.Pet{
  __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
  age: 5,
  id: 4,
  inserted_at: ~N[2022-04-07 22:56:36],
  name: "Simba",
  owner: nil,
  owner_id: nil,
  sex: "male",
  type: "snake",
  updated_at: ~N[2022-04-07 22:56:36]
}

iex> erick = Repo.get_by(Owner, name: "erick")
%PetClinicMx.OwnerService.Owner{
  __meta__: #Ecto.Schema.Metadata<:loaded, "owners">,
  age: 23,
  email: "erick.barcenas@bunsan.io",
  id: 1, 
  inserted_at: ~N[2022-04-20 21:48:08],
  name: "erick",
  pets: #Ecto.Association.NotLoaded<association :pets is not loaded>,
  phone_num: "+5212284806275",
  updated_at: ~N[2022-04-20 21:48:08]
}

iex> chset = simba |> change() |> put_assoc(:owner, erick)
#Ecto.Changeset<
  action: nil,
  changes: %{
    owner: #Ecto.Changeset<action: :update, changes: %{}, errors: [],
     data: #PetClinicMx.OwnerService.Owner<>, valid?: true>
  },
  errors: [],
  data: #PetClinicMx.PetClinicService.Pet<>,
  valid?: true
>
iex> Repo.update(chset)
{:ok,
 %PetClinicMx.PetClinicService.Pet{
   __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
   age: 5,
   id: 4,
   inserted_at: ~N[2022-04-07 22:56:36],
   name: "Simba",
   owner: %PetClinicMx.OwnerService.Owner{
     __meta__: #Ecto.Schema.Metadata<:loaded, "owners">,
     age: 23,
     email: "erick.barcenas@bunsan.io",
     id: 1,
     inserted_at: ~N[2022-04-20 21:48:08],
     name: "erick",
     pets: #Ecto.Association.NotLoaded<association :pets is not loaded>,
     phone_num: "+5212284806275",
     updated_at: ~N[2022-04-20 21:48:08]
   },
   owner_id: 1,
   sex: "male",
   type: "snake",
   updated_at: ~N[2022-04-21 00:31:16]
 }}
```

```elixir
iex> leo = Repo.get_by(Pet, name: "Leo") |> Repo.preload(:owner)
iex> erick = Repo.get_by(Owner, name: "erick")
iex> chset = leo |> change() |> put_assoc(:owner, erick)
iex> Repo.update(chset)
```

```elixir
iex> frog = Repo.get_by(Pet, name: "frog") |> Repo.preload(:owner)
iex> erick = Repo.get_by(Owner, name: "erick")
iex> chset = frog |> change() |> put_assoc(:owner, erick)
iex> Repo.update(chset)
```

Al owner Daniel le se asignarán los siguientes pets:
[["Lucas"], ["ecto"]]

```elixir
iex> lucas = Repo.get_by(Pet, name: "Lucas") |> Repo.preload(:owner)
iex> daniel = Repo.get_by(Owner, name: "Daniel")
iex> chset = lucas |> change() |> put_assoc(:owner, daniel)
iex> Repo.update(chset)
```


```elixir
iex> ecto = Repo.get_by(Pet, name: "ecto") |> Repo.preload(:owner)
iex> daniel = Repo.get_by(Owner, name: "Daniel")
iex> chset = ecto |> change() |> put_assoc(:owner, daniel)
iex> Repo.update(chset)
```

### 4.3 Consultar el owner anterior, precargando la asociación con pets.

```elixir
iex> erick = Repo.get_by(Owner, name: "erick") |> Repo.preload(:pets)
%PetClinicMx.OwnerService.Owner{
  __meta__: #Ecto.Schema.Metadata<:loaded, "owners">,
  age: 23,
  email: "erick.barcenas@bunsan.io",
  id: 1, 
  inserted_at: ~N[2022-04-20 21:48:08],
  name: "erick",
  pets: [
    %PetClinicMx.PetClinicService.Pet{
      __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
      age: 5,
      id: 4,
      inserted_at: ~N[2022-04-07 22:56:36],
      name: "Simba",
      owner: #Ecto.Association.NotLoaded<association :owner is not loaded>,
      owner_id: 1,
      sex: "male",
      type: "snake",
      updated_at: ~N[2022-04-21 00:31:16]
    },
    %PetClinicMx.PetClinicService.Pet{
      __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
      age: 7,
      id: 5,
      inserted_at: ~N[2022-04-07 22:56:58],
      name: "Leo",
      owner: #Ecto.Association.NotLoaded<association :owner is not loaded>,
      owner_id: 1,
      sex: "male",
      type: "lizard",
      updated_at: ~N[2022-04-21 00:47:05]
    },
    %PetClinicMx.PetClinicService.Pet{
      __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
      age: 3,
      id: 6,
      inserted_at: ~N[2022-04-07 22:57:13],
      name: "frog",
      owner: #Ecto.Association.NotLoaded<association :owner is not loaded>,
      owner_id: 1,
      sex: "male",
      type: "dog",
      updated_at: ~N[2022-04-21 00:47:25]
    }
  ],
  phone_num: "+5212284806275",
  updated_at: ~N[2022-04-20 21:48:08]
}
```

```elixir
iex> daniel = Repo.get_by(Owner, name: "Daniel") |> Repo.preload(:pets)
%PetClinicMx.OwnerService.Owner{
  __meta__: #Ecto.Schema.Metadata<:loaded, "owners">,
  age: 25,
  email: "daniel@bunsan.io",
  id: 2,
  inserted_at: ~N[2022-04-20 21:49:40],
  name: "Daniel",
  pets: [
    %PetClinicMx.PetClinicService.Pet{
      __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
      age: 3,
      id: 7,
      inserted_at: ~N[2022-04-07 22:57:27],
      name: "Lucas",
      owner: #Ecto.Association.NotLoaded<association :owner is not loaded>,
      owner_id: 2,
      sex: "female",
      type: "cat",
      updated_at: ~N[2022-04-21 00:48:25]
    },
    %PetClinicMx.PetClinicService.Pet{
      __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
      age: 3,
      id: 9,
      inserted_at: ~N[2022-04-20 13:29:31],
      name: "ecto",
      owner: #Ecto.Association.NotLoaded<association :owner is not loaded>,
      owner_id: 2,
      sex: "male",
      type: "cat",
      updated_at: ~N[2022-04-21 00:48:41]
    }
  ],
  phone_num: "+5215613558752",
  updated_at: ~N[2022-04-20 21:49:40]
}
```
## 5. Agregar la relación entre Pet y HelthExpert (healthexpert.patients, pet.preferred_expert). Modelo y migración.
```elixir
iex> mix ecto.gen.migration relation_healt_expert_with_patients
* creating priv/repo/migrations/20220421005612_relation_healt_expert_with_patients.exs
```

```elixir
defmodule PetClinicMx.Repo.Migrations.RelationHealtExpertWithPatients do
  use Ecto.Migration

  def change do
    alter table("pets") do
      add :preferred_expert_id, references("healt_expert")
    end
  end
end
```

```elixir
defmodule PetClinicMx.PetHealthExpert.Healt do
  use Ecto.Schema
  import Ecto.Changeset

  schema "healt_expert" do
    field :age, :integer
    field :email, :string
    field :name, :string
    field :sex, :string
    field :specialities, :string

    has_many(:patients, PetClinicMx.PetClinicService.Pet, foreign_key: :preferred_expert_id)

    timestamps()
  end

  @doc false
  def changeset(healt, attrs) do
    healt
    |> cast(attrs, [:name, :age, :email, :specialities, :sex])
    |> validate_required([:name, :age, :email, :specialities, :sex])
  end
end
```
```elixir
defmodule PetClinicMx.PetClinicService.Pet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pets" do
    field :age, :integer
    field :name, :string
    field :sex, :string
    field :type, :string

    belongs_to(:owner, PetClinicMx.OwnerService.Owner, foreign_key: :owner_id)
    belongs_to(:preferred_expert, PetClinicMx.PetHealthExpert.Healt, foreign_key: :preferred_expert_id)  

    timestamps()
  end

  @doc false
  def changeset(pet, attrs) do
    pet
    |> cast(attrs, [:name, :age, :type, :sex])
    |> validate_required([:name, :age, :type, :sex])
  end
end

```
## 6. Asociar preferred_expert con pets (mandar iex + resultado)
### 6.1 Consultar 2 pets con la asociación hacia preferred_expert precargada.

```elixir
    iex> with_preferred_experd = Repo.all(from p in Pet, where: p.preferred_expert_id > 0, select: [p.name])
    []
```

```elixir
    iex>  chocolata = Repo.get_by(Pet, name: "chocolata") |> Repo.preload(:preferred_expert)
    %PetClinicMx.PetClinicService.Pet{
    __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
    age: 1,
    id: 10,
    inserted_at: ~N[2022-04-20 23:24:50],
    name: "chocolata",
    owner: #Ecto.Association.NotLoaded<association :owner is not loaded>,
    owner_id: nil, 
    preferred_expert: nil,
    preferred_expert_id: nil,
    sex: "female",
    type: "dog",
    updated_at: ~N[2022-04-20 23:24:50]
    }
```

```elixir
    iex> phoenix = Repo.get_by(Pet, name: "phoenix") |> Repo.preload(:preferred_expert) 
    %PetClinicMx.PetClinicService.Pet{
    __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
    age: 4,
    id: 2,
    inserted_at: ~N[2022-04-07 22:55:59],
    name: "phoenix",
    owner: #Ecto.Association.NotLoaded<association :owner is not loaded>,
    owner_id: nil,
    preferred_expert: nil,
    preferred_expert_id: nil,
    sex: "female",
    type: "cat",
    updated_at: ~N[2022-04-20 23:59:07]
    }
```



    6.2 Usando put_assoc, asociar c/u de esos pets con algún preferred_expert.


```elixir
    iex> import Ecto.Changeset
    Ecto.Changeset
```

```elixir
    iex> phoenix = Repo.get_by(Pet, name: "phoenix") |> Repo.preload(:preferred_expert)
    iex> erick = Repo.get_by(Healt, name: "Erick")
    iex> chset = phoenix |> change() |> put_assoc(:preferred_expert, erick)
    iex> Repo.update(chset)
```

```elixir
    iex> simba = Repo.get_by(Pet, name: "Simba") |> Repo.preload(:preferred_expert)
    iex> erick = Repo.get_by(Healt, name: "Erick")
    iex> chset = simba |> change() |> put_assoc(:preferred_expert, erick)
    iex> Repo.update(chset)
```

```elixir
    iex> leo = Repo.get_by(Pet, name: "Leo") |> Repo.preload(:preferred_expert)
    iex> erick = Repo.get_by(Healt, name: "Erick")
    iex> chset = leo |> change() |> put_assoc(:preferred_expert, erick)
    iex> Repo.update(chset)
```

```elixir
    iex> frog = Repo.get_by(Pet, name: "frog") |> Repo.preload(:preferred_expert)
    iex> erick = Repo.get_by(Healt, name: "Erick")
    iex> chset = frog |> change() |> put_assoc(:preferred_expert, erick)
    iex> Repo.update(chset)
```

```elixir
    iex> lucas = Repo.get_by(Pet, name: "Lucas") |> Repo.preload(:preferred_expert)
    iex> erick = Repo.get_by(Healt, name: "Erick")
    iex> chset = lucas |> change() |> put_assoc(:preferred_expert, erick)
    iex> Repo.update(chset)
```

```elixir
    iex> ecto = Repo.get_by(Pet, name: "ecto") |> Repo.preload(:preferred_expert)
    iex> pao = Repo.get_by(Healt, name: "Pao")
    iex> chset = ecto |> change() |> put_assoc(:preferred_expert, pao)
    iex> Repo.update(chset)
    ```


```elixir
    iex> chocolata = Repo.get_by(Pet, name: "chocolata") |> Repo.preload(:preferred_expert)
    iex> pao = Repo.get_by(Healt, name: "Pao")
    iex> chset = chocolata |> change() |> put_assoc(:preferred_expert, pao)
    iex> Repo.update(chset)
```

    6.3 Consultar el preferred_expert anterior, precargando la asociación con pets.

```elixir
    iex> erick = Repo.get_by(Healt, name: "Erick") |> Repo.preload(:patients)
    %PetClinicMx.PetHealthExpert.Healt{
    __meta__: #Ecto.Schema.Metadata<:loaded, "healt_expert">,
    age: 24,
    email: "erick.barcenas@gmail.com",
    id: 1,
    inserted_at: ~N[2022-04-07 22:58:39],
    name: "Erick",
    patients: [
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
        sex: "female",
        type: "cat",
        updated_at: ~N[2022-04-21 12:11:13]
        },
        %PetClinicMx.PetClinicService.Pet{
        __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
        age: 5,
        id: 4,
        inserted_at: ~N[2022-04-07 22:56:36],
        name: "Simba",
        owner: #Ecto.Association.NotLoaded<association :owner is not loaded>,
        owner_id: nil,
        preferred_expert: #Ecto.Association.NotLoaded<association :preferred_expert is not loaded>,
        preferred_expert_id: 1,
        sex: "male",
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
        preferred_expert: #Ecto.Association.NotLoaded<association :preferred_expert is not loaded>,
        preferred_expert_id: 1,
        sex: "male",
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
        preferred_expert: #Ecto.Association.NotLoaded<association :preferred_expert is not loaded>,
        preferred_expert_id: 1,
        sex: "male",
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
        preferred_expert: #Ecto.Association.NotLoaded<association :preferred_expert is not loaded>,
        preferred_expert_id: 1,
        sex: "female",
        type: "cat",
        updated_at: ~N[2022-04-21 12:15:00]
        }
    ],
    sex: "male",
    specialities: "cat",
    updated_at: ~N[2022-04-07 22:58:39]
    }

```

```elixir
    iex> pao = Repo.get_by(Healt, name: "Pao") |> Repo.preload(:patients)
    %PetClinicMx.PetHealthExpert.Healt{
    __meta__: #Ecto.Schema.Metadata<:loaded, "healt_expert">,
    age: 25,
    email: "pao@gmail.com",
    id: 2,
    inserted_at: ~N[2022-04-07 22:59:01],
    name: "Pao",
    patients: [
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
        },
        %PetClinicMx.PetClinicService.Pet{
        __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
        age: 1,
        id: 10,
        inserted_at: ~N[2022-04-20 23:24:50],
        name: "chocolata",
        owner: #Ecto.Association.NotLoaded<association :owner is not loaded>,
        owner_id: nil,
        preferred_expert: #Ecto.Association.NotLoaded<association :preferred_expert is not loaded>,
        preferred_expert_id: 2,
        sex: "female",
        type: "dog",
        updated_at: ~N[2022-04-21 12:15:40]
        }
    ],
    sex: "female",
    specialities: "dog",
    updated_at: ~N[2022-04-07 22:59:01]
    }
```

## 7. Leer la documentación de Ecto.Changeset. La parte principal y las funciones cast y change.


## 8. En Pet.changeset agregar 1 validación para que la edad no sea menor a 0.

```elixir
def changeset(pet, params \\ %{}) do
    pet
    |> cast(params, [:name, :email, :age])
    |> validate_required([:name, :email, :age])
    |> validate_format(:email, ~r/@/)
    |> validate_inclusion(:age, 18..100)
    |> unique_constraint(:email)
end

```

```elixir
iex> Pet.changeset(%Pet{}, %{name: "dolly", type: "dog", age: 0, sex: "female"})  
#Ecto.Changeset<
  action: nil,
  changes: %{age: 0, name: "dolly", sex: "female", type: "dog"},
  errors: [
    age: {"must be greater than %{number}",
     [validation: :number, kind: :greater_than, number: 3]}
  ],
  data: #PetClinicMx.PetClinicService.Pet<>,
  valid?: false
>
```

```elixir
iex> Pet.changeset(%Pet{}, %{name: "dolly", type: "dog", age: 1, sex: "female"})  
#Ecto.Changeset<
  action: nil,
  changes: %{name: "dolly", sex: "female", type: "dog"},
  errors: [],
  data: #PetClinicMx.PetClinicService.Pet<>,
  valid?: true
>
```

# Ecto One To Many

![Calculator](https://github.com/erickbarcenas/pet_clinic_mx/tree/main/learning/ecto_one_to_many/assets/schema.png)


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

## 5. Repetir las instrucciones del punto 3, pero para Pet y HelthExpert (healthexpert.patients, pet.preferred_expert).

## 6. Repetir el punto 4 pero para Pet y HelthExpert.


## 7. Leer la documentación de Ecto.Changeset. La parte principal y las funciones cast y change.


## 8. En Pet.changeset agregar 1 validación para que la edad no sea menor a 0.




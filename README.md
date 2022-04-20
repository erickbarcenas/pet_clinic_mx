# PetClinicMx

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).


## Screenshots

### Part 1

Veterinarian show screen
![Veterinarian show screen](https://cdn.discordapp.com/attachments/954764763739586630/961779119014686750/unknown.png)

Pet show screen
![pet show screen](https://cdn.discordapp.com/attachments/954764763739586630/961779166443864174/unknown.png)

### Part 2
Snake list screen
![Snake list screen](https://cdn.discordapp.com/attachments/954764763739586630/961779270978519090/unknown.png)


## Ecto basic operations

```elixir
iex -S mix phx.server
```

```elixir
import Ecto.Query
```

```elixir
alias PetClinicMx.Repo
alias PetClinicMx.PetClinicService.Pet # modelo
```

### Crear 1 pet
```elixir
iex> Repo.insert(%Pet{age: 3, name: "ecto", sex: "male", type: "cat"})
{:ok,
 %PetClinicMx.PetClinicService.Pet{
   __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
   age: 3,
   id: 9,
   inserted_at: ~N[2022-04-20 13:29:31],
   name: "ecto",
   sex: "male",
   type: "cat",
   updated_at: ~N[2022-04-20 13:29:31]
 }}
```
###  Consultar todos los pets.
```elixir
iex> Repo.all(Pet)
[
  %PetClinicMx.PetClinicService.Pet{
    __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
    age: 3,
    id: 1,
    inserted_at: ~N[2022-04-07 22:55:37],
    name: "Coco",
    sex: "male",
    type: "cat",
    updated_at: ~N[2022-04-07 22:55:37]
  },
  %PetClinicMx.PetClinicService.Pet{
    __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
    age: 4,
    id: 2,
    inserted_at: ~N[2022-04-07 22:55:59],
    name: "Rocky",
    sex: "female",
    type: "cat",
    updated_at: ~N[2022-04-07 22:55:59]
  },
  %PetClinicMx.PetClinicService.Pet{
    __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
    age: 4,
    id: 3,
    inserted_at: ~N[2022-04-07 22:56:24],
    name: "Toby",
    sex: "male",
    type: "snake",
    updated_at: ~N[2022-04-07 22:56:24]
  },
  %PetClinicMx.PetClinicService.Pet{
    __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
    age: 5,
    id: 4,
    inserted_at: ~N[2022-04-07 22:56:36],
    name: "Simba",
    sex: "male",
    type: "snake",
    updated_at: ~N[2022-04-07 22:56:36]
  }, 
  %PetClinicMx.PetClinicService.Pet{
    __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
    age: 7,
    id: 5,
    inserted_at: ~N[2022-04-07 22:56:58],
    name: "Leo",
    sex: "male",
    type: "lizard",
    updated_at: ~N[2022-04-07 22:56:58]
  },
  %PetClinicMx.PetClinicService.Pet{
    __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
    age: 3,
    id: 6,
    inserted_at: ~N[2022-04-07 22:57:13],
    name: "frog",
    sex: "male",
    type: "dog",
    updated_at: ~N[2022-04-07 22:57:13]
  },
  %PetClinicMx.PetClinicService.Pet{
    __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
    age: 3,
    id: 7,
    inserted_at: ~N[2022-04-07 22:57:27],
    name: "Lucas",
    sex: "female",
    type: "cat",
    updated_at: ~N[2022-04-07 22:57:27]
  },
  %PetClinicMx.PetClinicService.Pet{
    __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
    age: 2,
    id: 8,
    inserted_at: ~N[2022-04-07 22:57:43],
    name: "Coco",
    sex: "male",
    type: "mice",
    updated_at: ~N[2022-04-07 22:57:43]
  }
]
```

###  Consultar pets con más de un criterio (Repo.all), usando también select y order_by

```elixir
iex> Repo.all(from p in Pet, where: p.sex == "male", select: %{id: p.id, name: p.name, age: p.age},order_by: [desc: p.inserted_at])

[
  %{age: 2, id: 8, name: "Coco"},
  %{age: 3, id: 6, name: "frog"},
  %{age: 7, id: 5, name: "Leo"},
  %{age: 5, id: 4, name: "Simba"},
  %{age: 4, id: 3, name: "Toby"},
  %{age: 3, id: 1, name: "Coco"}
]
```

### - Modificar en BD 1 atributo de 1 pet (consultar, crear changeset, actualizar)

```elixir
iex> pet = Repo.get!(Pet, 2)
%PetClinicMx.PetClinicService.Pet{
  __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
  age: 4,
  id: 2,
  inserted_at: ~N[2022-04-07 22:55:59],
  name: "Rocky",
  sex: "female", 
  type: "cat",
  updated_at: ~N[2022-04-07 22:55:59]
}
iex> pet = Ecto.Changeset.change(pet, name: "phoenix")
iex> Repo.update(pet)

{:ok,
 %PetClinicMx.PetClinicService.Pet{
   __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
   age: 4,
   id: 2,
   inserted_at: ~N[2022-04-07 22:55:59],
   name: "phoenix",
   sex: "female",
   type: "cat",
   updated_at: ~N[2022-04-20 13:20:58]
 }}

```

###  Corroborar el cambio anterior usando Repo.get!

```elixir
iex> pet = Repo.get!(Pet, 2)
%PetClinicMx.PetClinicService.Pet{
  __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
  age: 4,
  id: 2,
  inserted_at: ~N[2022-04-07 22:55:59],
  name: "phoenix",
  sex: "female",
  type: "cat",
  updated_at: ~N[2022-04-20 13:20:58]
}
```


### Borrar un pet
```elixir
iex> pet = Repo.get!(Pet, 3)
%PetClinicMx.PetClinicService.Pet{
  __meta__: #Ecto.Schema.Metadata<:loaded, "pets">,
  age: 4,
  id: 3,
  inserted_at: ~N[2022-04-07 22:56:24],
  name: "Toby",
  sex: "male",
  type: "snake",
  updated_at: ~N[2022-04-07 22:56:24]
}
iex> Repo.delete(pet)
{:ok,
 %PetClinicMx.PetClinicService.Pet{
   __meta__: #Ecto.Schema.Metadata<:deleted, "pets">,
   age: 4,
   id: 3,
   inserted_at: ~N[2022-04-07 22:56:24],
   name: "Toby",
   sex: "male",
   type: "snake",
   updated_at: ~N[2022-04-07 22:56:24]
 }}
```
## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
  * Console code: https://carbon.now.sh

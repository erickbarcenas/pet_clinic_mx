## Services


### ExpertSchedule

```elixir
iex> alias PetClinicMx.Models.ExpertSchedule
iex> alias PetClinicMx.Services.ExpertScheduleService
iex> import Ecto.Query
iex> alias PetClinicMx.Repo
```

```elixir
iex> ExpertScheduleService.create_schedule(%{
    healt_expert_id: 1,
    start_date: ~D[2022-04-28],
    ending_date: ~D[2022-04-28],
    start_hour: ~T[10:00:00],
    ending_hour: ~T[20:00:00]
})

{:ok,
 %PetClinicMx.Models.ExpertSchedule{
   __meta__: #Ecto.Schema.Metadata<:loaded, "expert_schedules">,
   ending_date: ~D[2022-04-28],
   ending_hour: ~T[20:00:00],
   healt_expert: #Ecto.Association.NotLoaded<association :healt_expert is not loaded>,
   healt_expert_id: 1,
   id: 1,
   inserted_at: ~N[2022-04-28 02:45:42],
   start_date: ~D[2022-04-28],
   start_hour: ~T[10:00:00],
   updated_at: ~N[2022-04-28 02:45:42]
 }}


```

```elixir
iex> ExpertScheduleService.list_schedule
```

```elixir
iex> ExpertScheduleService.list_schedule
[
  %PetClinicMx.Models.ExpertSchedule{
    __meta__: #Ecto.Schema.Metadata<:loaded, "expert_schedules">,
    ending_date: ~D[2022-04-28],
    ending_hour: ~T[20:00:00],
    healt_expert: #Ecto.Association.NotLoaded<association :healt_expert is not loaded>,
    healt_expert_id: 1,
    id: 1,
    inserted_at: ~N[2022-04-28 01:50:37],
    start_date: ~D[2022-04-28],
    start_hour: ~T[10:00:00],
    updated_at: ~N[2022-04-28 01:50:37]
  }
]
```



### Appointment

```elixir
iex> alias PetClinicMx.Services.AppointmentService
```


```elixir
iex> AppointmentService.new_appointment(%{datetime: ~N[2022-04-28 15:00:00], health_expert_id: 2, pet_id: 5})
{:ok,
 %PetClinicMx.Models.Appointment{
   __meta__: #Ecto.Schema.Metadata<:loaded, "appointments">,
   datetime: ~U[2022-04-28 15:00:00Z],
   healt_expert: #Ecto.Association.NotLoaded<association :healt_expert is not loaded>,
   healt_expert_id: 2,
   id: 2,
   pet: #Ecto.Association.NotLoaded<association :pet is not loaded>,
   pet_id: 5
 }}
```


```elixir
iex> AppointmentService.list_appointment()
[
  %PetClinicMx.Models.Appointment{
    __meta__: #Ecto.Schema.Metadata<:loaded, "appointments">,
    datetime: ~U[2022-04-28 15:00:00Z],
    healt_expert: #Ecto.Association.NotLoaded<association :healt_expert is not loaded>,
    healt_expert_id: 2,
    id: 2,
    pet: #Ecto.Association.NotLoaded<association :pet is not loaded>,
    pet_id: 5
  }
]
```


```elixir
# AppointmentUtils.time_range(~T[14:00:00], ~T[14:30:00], 1800, 1)
iex> AppointmentService.available_slots(1, ~D[2022-04-26], ~D[2022-04-29])
[~T[10:00:00], ~T[10:30:00], ~T[11:00:00], ~T[11:30:00], ~T[12:00:00],
 ~T[12:30:00], ~T[13:00:00], ~T[13:30:00], ~T[14:00:00], ~T[14:30:00],
 ~T[15:00:00], ~T[15:30:00], ~T[16:00:00], ~T[16:30:00], ~T[17:00:00],
 ~T[17:30:00], ~T[18:00:00], ~T[18:30:00], ~T[19:00:00], ~T[19:30:00]]
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
iex> alias PetClinicMx.Services.AppointmentService
# new_appointment(expert_id, pet_id, datetime)
AppointmentService.new_appointment(1, 5, ~N[2022-04-01 15:00:00])
 ```
defmodule PetClinicMx.Repo do
  use Ecto.Repo,
    otp_app: :pet_clinic_mx,
    adapter: Ecto.Adapters.Postgres
end

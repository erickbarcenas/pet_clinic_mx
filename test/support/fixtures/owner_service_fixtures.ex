defmodule PetClinicMx.OwnerServiceFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PetClinicMx.OwnerService` context.
  """

  @doc """
  Generate a owner.
  """
  def owner_fixture(attrs \\ %{}) do
    {:ok, owner} =
      attrs
      |> Enum.into(%{
        age: 42,
        email: "some email",
        name: "some name",
        phone_num: "some phone_num"
      })
      |> PetClinicMx.OwnerService.create_owner()

    owner
  end
end

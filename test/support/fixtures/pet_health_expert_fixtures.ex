defmodule PetClinicMx.PetHealthExpertFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PetClinicMx.PetHealthExpert` context.
  """

  @doc """
  Generate a healt.
  """
  def healt_fixture(attrs \\ %{}) do
    {:ok, healt} =
      attrs
      |> Enum.into(%{
        age: 42,
        email: "some email",
        name: "some name",
        sex: "some sex",
        specialities: "some specialities"
      })
      |> PetClinicMx.PetHealthExpert.create_healt()

    healt
  end
end

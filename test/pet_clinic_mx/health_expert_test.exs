defmodule PetClinicMx.PetHealthExpertTest do
  use PetClinicMx.DataCase

  alias PetClinicMx.Services.HealthExpertService

  describe "healt_expert" do
    alias PetClinicMx.Models.HealthExpert

    import PetClinicMx.PetHealthExpertFixtures

    @invalid_attrs %{age: nil, email: nil, name: nil, sex: nil, specialities: nil}

    test "list_healt_expert/0 returns all healt_expert" do
      healt = healt_fixture()
      assert HealthExpertService.list_healt_expert() == [healt]
    end

    test "get_healt!/1 returns the healt with given id" do
      healt = healt_fixture()
      assert HealthExpertService.get_healt!(healt.id) == healt
    end

    test "create_healt/1 with valid data creates a healt" do
      valid_attrs = %{
        age: 42,
        email: "some email",
        name: "some name",
        sex: "some sex",
        specialities: "some specialities"
      }

      assert {:ok, %HealthExpert{} = healt_expert} = HealthExpertService.create_healt(valid_attrs)
      assert healt_expert.age == 42
      assert healt_expert.email == "some email"
      assert healt_expert.name == "some name"
      assert healt_expert.sex == "some sex"
      assert healt_expert.specialities == "some specialities"
    end

    test "create_healt/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               HealthExpertService.create_health_expert(@invalid_attrs)
    end

    test "update_healt/2 with valid data updates the healt" do
      healt = healt_fixture()

      update_attrs = %{
        age: 43,
        email: "some updated email",
        name: "some updated name",
        sex: "some updated sex",
        specialities: "some updated specialities"
      }

      assert {:ok, %HealthExpertService{} = healt} =
               HealthExpertService.update_healt(healt, update_attrs)

      assert healt.age == 43
      assert healt.email == "some updated email"
      assert healt.name == "some updated name"
      assert healt.sex == "some updated sex"
      assert healt.specialities == "some updated specialities"
    end

    test "update_healt/2 with invalid data returns error changeset" do
      healt = healt_fixture()
      assert {:error, %Ecto.Changeset{}} = HealthExpertService.update_healt(healt, @invalid_attrs)
      assert healt == HealthExpertService.get_healt!(healt.id)
    end

    test "delete_healt/1 deletes the healt" do
      healt = healt_fixture()
      assert {:ok, %Healt{}} = HealthExpertService.delete_health_expert(healt)
      assert_raise Ecto.NoResultsError, fn -> HealthExpertService.get_health_expert!(healt.id) end
    end

    test "change_healt/1 returns a healt changeset" do
      healt = healt_fixture()
      assert %Ecto.Changeset{} = HealthExpertService.change_health_expert(health_expert)
    end
  end
end

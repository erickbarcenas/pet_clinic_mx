defmodule PetClinicMxWeb.HealtControllerTest do
  use PetClinicMxWeb.ConnCase

  import PetClinicMx.PetHealthExpertFixtures

  @create_attrs %{age: 42, email: "some email", name: "some name", sex: "some sex", specialities: "some specialities"}
  @update_attrs %{age: 43, email: "some updated email", name: "some updated name", sex: "some updated sex", specialities: "some updated specialities"}
  @invalid_attrs %{age: nil, email: nil, name: nil, sex: nil, specialities: nil}

  describe "index" do
    test "lists all healt_expert", %{conn: conn} do
      conn = get(conn, Routes.healt_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Healt expert"
    end
  end

  describe "new healt" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.healt_path(conn, :new))
      assert html_response(conn, 200) =~ "New Healt"
    end
  end

  describe "create healt" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.healt_path(conn, :create), healt: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.healt_path(conn, :show, id)

      conn = get(conn, Routes.healt_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Healt"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.healt_path(conn, :create), healt: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Healt"
    end
  end

  describe "edit healt" do
    setup [:create_healt]

    test "renders form for editing chosen healt", %{conn: conn, healt: healt} do
      conn = get(conn, Routes.healt_path(conn, :edit, healt))
      assert html_response(conn, 200) =~ "Edit Healt"
    end
  end

  describe "update healt" do
    setup [:create_healt]

    test "redirects when data is valid", %{conn: conn, healt: healt} do
      conn = put(conn, Routes.healt_path(conn, :update, healt), healt: @update_attrs)
      assert redirected_to(conn) == Routes.healt_path(conn, :show, healt)

      conn = get(conn, Routes.healt_path(conn, :show, healt))
      assert html_response(conn, 200) =~ "some updated email"
    end

    test "renders errors when data is invalid", %{conn: conn, healt: healt} do
      conn = put(conn, Routes.healt_path(conn, :update, healt), healt: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Healt"
    end
  end

  describe "delete healt" do
    setup [:create_healt]

    test "deletes chosen healt", %{conn: conn, healt: healt} do
      conn = delete(conn, Routes.healt_path(conn, :delete, healt))
      assert redirected_to(conn) == Routes.healt_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.healt_path(conn, :show, healt))
      end
    end
  end

  defp create_healt(_) do
    healt = healt_fixture()
    %{healt: healt}
  end
end

defmodule ThundermoonWeb.GameOfLifeLiveTest do
  use ThundermoonWeb.ConnCase, async: false
  import Phoenix.LiveViewTest

  import ThundermoonWeb.AuthSupport

  alias Phoenix.PubSub

  def restart_realm(_) do
    GameOfLife.restart()
    :ok
  end

  def login_as_member(%{conn: conn}) do
    conn = login_as(conn, %{username: "crumb"})
    %{conn: conn}
  end

  def login_as_admin(%{conn: conn}) do
    conn = login_as(conn, %{username: "gilbert_shelton", role: "admin"})
    %{conn: conn}
  end

  describe "a guest" do
    test "should be redirected", %{conn: conn} do
      conn = get(conn, "/game_of_life")
      assert redirected_to(conn) == "/"
    end
  end

  describe "a member" do
    setup [:login_as_member, :restart_realm]

    test "disconnected and connected mount", %{conn: conn} do
      conn = get(conn, "/game_of_life")
      assert html_response(conn, 200) =~ "<h1>Game of Life</h1>"
      {:ok, _view, html} = live(conn)
      assert html =~ "<h1>Game of Life</h1>"
    end

    test "can not create a grid", %{conn: conn} do
      {:ok, view, html} = live(conn, "/game_of_life")
      assert html =~ "no simulation available"

      data = %{"form_data" => %{"size" => "5"}}

      render_submit(view, :create, data)
      assert_redirect(view, "/")
    end

    test "can start and stop sim", %{conn: conn} do
      GameOfLife.create(3)
      PubSub.subscribe(ThundermoonWeb.PubSub, "GameOfLife")
      {:ok, view, _html} = live(conn, "/game_of_life")
      render_click(view, "toggle-sim-start", %{"action" => "start"})
      assert_receive({:sim, started: true})
      render_click(view, "toggle-sim-start", %{"action" => "stop"})
      assert_receive({:sim, started: false})
    end

    test "can reset the grid", %{conn: conn} do
      GameOfLife.create(3)
      PubSub.subscribe(ThundermoonWeb.PubSub, "GameOfLife")
      {:ok, view, _html} = live(conn, "/game_of_life")
      render_click(view, "toggle-sim-start", %{"action" => "start"})
      assert_receive({:sim, started: true})
      render_click(view, :recreate)
      assert_receive({:sim, started: false})
      assert_receive({:update, data: %{}})
    end

    test "can clear the grid", %{conn: conn} do
      GameOfLife.create(3)
      PubSub.subscribe(ThundermoonWeb.PubSub, "GameOfLife")
      {:ok, view, _html} = live(conn, "/game_of_life")
      render_click(view, :clear)
      assert_receive({:update, data: %{0 => %{0 => false}}})
    end

    test "can change the value of a cell", %{conn: conn} do
      GameOfLife.create(3)
      PubSub.subscribe(ThundermoonWeb.PubSub, "GameOfLife")
      {:ok, view, _html} = live(conn, "/game_of_life")
      grid = GameOfLife.get_root()
      value = get_in(grid, [0, 0])
      render_click(view, "toggle-cell", %{"x" => "0", "y" => "0"})
      changed_value = not value
      assert_receive({:update, data: %{0 => %{0 => ^changed_value}}})
    end

    test "can not recreate a grid", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/game_of_life")

      render_click(view, :restart)
      assert_redirect(view, "/")
    end
  end

  describe "a admin" do
    setup [:login_as_admin, :restart_realm]

    test "can create a grid", %{conn: conn} do
      PubSub.subscribe(ThundermoonWeb.PubSub, "GameOfLife")
      {:ok, view, _html} = live(conn, "/game_of_life")

      data = %{"form_data" => %{"size" => "5"}}
      render_submit(view, :create, data)
      assert_receive({:update, data: %{}})
    end

    test "see an error when size submitted is too big", %{conn: conn} do
      {:ok, view, html} = live(conn, "/game_of_life")
      refute html =~ "class=\"help-block\""

      data = %{"form_data" => %{"size" => "100"}}

      assert render_submit(view, :create, data) =~ "must be less than 51"
    end

    test "can recreate a grid", %{conn: conn} do
      GameOfLife.create(3)
      {:ok, view, html} = live(conn, "/game_of_life")
      assert html =~ "id=\"grid\""
      render_click(view, "toggle-sim-start", %{"action" => "start"})
      render_click(view, :restart)
      {:ok, _view, html} = live(conn, "/game_of_life")
      assert html =~ "Create a new Grid"
    end
  end
end

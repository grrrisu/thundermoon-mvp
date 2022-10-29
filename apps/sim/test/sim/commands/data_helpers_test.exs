defmodule Test.Commands.DataHelpers do
  use ExUnit.Case
  use Sim.Commands.DataHelpers, app_module: __MODULE__

  setup do
    start_supervised!({Sim.Realm.Data, name: Test.Commands.DataHelpers.Data})
    set_data(%{world: %{city: %{factory: %{wood: 5}}}})
    :ok
  end

  describe "change_data" do
    test "with change and update function" do
      assert :ok =
               change_data(
                 fn _data -> {[:world, :city, :factory, :wood], 3} end,
                 fn data, {path, amount} -> {:ok, update_in(data, path, &(&1 + amount))} end
               )

      assert 8 == get_data(fn data -> get_in(data, [:world, :city, :factory, :wood]) end)
    end

    test "with change and update function returning events" do
      assert {:ok, [:wood_changed]} ==
               change_data(
                 fn _data -> {[:world, :city, :factory, :wood], 3} end,
                 fn data, {path, amount} ->
                   {:ok, update_in(data, path, &(&1 + amount)), [:wood_changed]}
                 end
               )

      assert 8 == get_data(fn data -> get_in(data, [:world, :city, :factory, :wood]) end)
    end

    test "with change and failing update function" do
      assert {:error, "failed"} ==
               change_data(
                 fn _data -> {[:world, :city, :factory, :wood], 3} end,
                 fn data, {path, amount} -> {:error, "failed"} end
               )

      assert 5 == get_data(fn data -> get_in(data, [:world, :city, :factory, :wood]) end)
    end

    test "with get, change and update function" do
      assert :ok =
               change_data(
                 fn data -> get_in(data, [:world, :city, :factory, :wood]) end,
                 fn wood -> {[:world, :city, :factory, :wood], wood * 0.5} end,
                 fn data, {path, amount} -> {:ok, update_in(data, path, &(&1 + amount))} end
               )

      assert 7.5 == get_data(fn data -> get_in(data, [:world, :city, :factory, :wood]) end)
    end
  end
end

defmodule Thundermoon.LotkaVolterra.FormData do
  import Ecto.Changeset

  alias LotkaVolterra.Vegetation

  @types %{
    capacity: :integer,
    birth_rate: :float,
    death_rate: :float,
    size: :integer
  }

  def changeset(%Vegetation{} = model, params \\ %{}) do
    {model, @types}
    |> cast(params, [:capacity, :birth_rate, :death_rate, :size])
    |> validate_required(:size)
    |> validate_number(:capacity, greater_than: 0)
    |> validate_number(:birth_rate, greater_than: 0)
    |> validate_number(:death_rate, greater_than: 0)
    |> validate_number(:size, greater_than: 0)
  end

  def apply_params(model, params) do
    model
    |> changeset(params)
    |> apply_valid_changes()
  end

  defp apply_valid_changes(%Ecto.Changeset{valid?: false} = changeset), do: {:error, changeset}

  defp apply_valid_changes(%Ecto.Changeset{valid?: true} = changeset) do
    {:ok, Ecto.Changeset.apply_changes(changeset)}
  end
end

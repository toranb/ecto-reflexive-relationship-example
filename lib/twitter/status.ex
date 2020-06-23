defmodule Twitter.Status do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :string, []}
  schema "statuses" do
    timestamps()
  end

  @required_attrs [
    :id
  ]

  def changeset(status, params \\ %{}) do
    status
    |> cast(params, @required_attrs)
    |> validate_required(@required_attrs)
    |> validate_inclusion(:id, ["PENDING", "IGNORED", "ACCEPTED"])
  end
end

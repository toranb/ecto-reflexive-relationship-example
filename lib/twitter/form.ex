defmodule Twitter.Form do
  use Ecto.Schema

  import Ecto.Changeset

  schema "search_form" do
    field :code, :string
  end

  @required_attrs [
    :code
  ]

  def changeset(todo, params \\ %{}) do
    todo
    |> cast(params, @required_attrs)
    |> validate_required(@required_attrs)
  end
end

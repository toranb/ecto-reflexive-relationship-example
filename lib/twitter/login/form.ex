defmodule Twitter.Login.Form do
  use Ecto.Schema

  import Ecto.Changeset

  schema "login_form" do
    field :name, :string
    field :name_touched, :boolean
    field :form_submitted, :boolean
    field :form_disabled, :boolean
  end

  @required_attrs [
    :name,
  ]

  @optional_attrs [
    :name_touched,
    :form_submitted,
    :form_disabled
  ]

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, @required_attrs ++ @optional_attrs)
    |> validate_required(@required_attrs)
  end
end

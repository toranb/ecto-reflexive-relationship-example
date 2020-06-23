defmodule Twitter.User do
  use Ecto.Schema

  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :code, :string

    has_many :friendships, Twitter.Friendship, on_replace: :delete
    has_many :friends, through: [:friendships, :friend]

    timestamps()
  end

  @required_attrs [
    :name,
    :code
  ]

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, @required_attrs)
    |> validate_required(@required_attrs)
  end
end

defmodule Twitter.Friendship do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false
  schema "friendships" do
    belongs_to :status, Twitter.Status, type: :string
    belongs_to :user, Twitter.User, primary_key: true, foreign_key: :user_id
    belongs_to :friend, Twitter.User, primary_key: true, foreign_key: :friend_id

    timestamps()
  end

  def changeset(friendship, params \\ %{}) do
    friendship |> cast(params, [:user_id, :friend_id, :status_id])
  end
end

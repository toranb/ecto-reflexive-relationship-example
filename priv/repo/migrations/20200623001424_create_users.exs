defmodule Twitter.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:statuses, primary_key: false) do
      add :id, :string, primary_key: true

      timestamps()
    end

    create table(:users) do
      add :name, :string, null: false
      add :code, :string, null: false

      timestamps()
    end

    create table(:friendships, primary_key: false) do
      add(:status_id, references(:statuses, on_delete: :delete_all, type: :string), primary_key: true, null: false)
      add(:user_id, references(:users, on_delete: :delete_all), primary_key: true, null: false)
      add(:friend_id, references(:users, on_delete: :delete_all), primary_key: true, null: false)

      timestamps()
    end

    create(index(:friendships, [:status_id]))
    create(index(:friendships, [:user_id]))
    create(index(:friendships, [:friend_id]))

    create(
      unique_index(:friendships, [:status_id, :user_id, :friend_id], name: :status_user_friend_unique_index)
    )
  end
end

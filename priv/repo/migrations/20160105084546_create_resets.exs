defmodule Repo.Migrations.CreateResets do
  use Ecto.Migration

  def change do
    create table(:resets, primary_key: false) do
      add :email, :text
      add :sha, :string
      timestamps

    end
  end

end

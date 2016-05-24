defmodule Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def up do
  	create table(:posts,primary_key: false) do
      add :id, :bigserial, primary_key: true
      add :title, :string, size: 140
      add :content, :text
      add :user_id, :bigint

      timestamps

    end
  end

  def down do
    drop table(:posts)
  end
end

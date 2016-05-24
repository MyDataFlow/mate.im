defmodule Repo.Migrations.CreateUsers do
  use Ecto.Migration


  def up do
    create table(:users,primary_key: false) do
      add :id, :bigserial, primary_key: true
      add :name, :text, null: false
      add :email, :text, null: false
      add :password, :text, null: false

      timestamps
    end
    create index :users, [:name], unique: true
    create index :users, [:email], unique: true

  end

  def down do
    drop table(:users)
  end

end

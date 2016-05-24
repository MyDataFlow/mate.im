defmodule Repo.Migrations.CreateSignups do
  use Ecto.Migration


  def up do
    create table(:signups,primary_key: false) do
      add :email, :string, primary_key: true
      add :sha, :string
      add :sent, :boolean,default: false
      timestamps
    end
  end

  def down do
    drop table(:signups)
  end

end

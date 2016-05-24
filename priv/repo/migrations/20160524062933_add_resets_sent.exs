defmodule Repo.Migrations.AddRestsSent do
  use Ecto.Migration

  def up do
    alter table(:resets) do
      add :sent, :boolean,default: false
    end

  end

  def down do

    alter table(:resets) do
        remove :sent
    end
  end
end

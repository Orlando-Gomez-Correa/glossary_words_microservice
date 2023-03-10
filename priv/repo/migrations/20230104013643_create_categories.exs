defmodule Glossary.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :description, :text, null: false
      add :code, :string, null: false

      timestamps()
    end

    create unique_index(:categories, [:code])
    create unique_index(:categories, [:name])
  end
end

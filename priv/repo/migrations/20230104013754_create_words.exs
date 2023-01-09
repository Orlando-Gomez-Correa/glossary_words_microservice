defmodule Glossary.Repo.Migrations.CreateWords do
  use Ecto.Migration

  def change do
    create table(:words, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:name, :string, null: false)
      add(:description, :text, null: false)
      add(:image, :string)
      add(:category_id, references(:categories, on_delete: :delete_all, type: :binary_id))

      timestamps()
    end

    create(index(:words, [:category_id]))
  end
end

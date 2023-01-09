defmodule Glossary.Words.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias Glossary.Words.Word

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "categories" do
    field :code, :string
    field :description, :string
    field :name, :string
    has_many :words, Word

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :description, :code])
    |> cast_assoc(:words)
    |> validate_required([:name, :description, :code])
    |> validate_length(:name, min: 3, message: "Name is to short")
    |> unique_constraint(:code, message: "Code already exist")
    |> unique_constraint(:name, message: "Name already exist")
  end
end

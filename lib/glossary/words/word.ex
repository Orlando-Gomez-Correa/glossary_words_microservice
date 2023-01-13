defmodule Glossary.Words.Word do
  use Ecto.Schema
  import Ecto.Changeset
  alias Glossary.Words.Category
  use Waffle.Ecto.Schema

  @timestamps_opts [type: :naive_datetime_usec]
  @type t :: %__MODULE__{}
  @derive {Jason.Encoder, except: [:__meta__]}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "words" do
    field :description, :string
    field :image, Glossary.ImageUploader.Type
    field :name, :string
    belongs_to :category, Category

    timestamps()
  end

  @doc false
  def changeset(word, attrs) do
    word
    |> cast(attrs, [:category_id, :name, :description])
    |> validate_required([:name, :description])
    |> assoc_constraint(:category)
  end

  def avatar_changeset(word, attrs) do
    word
    |> cast(attrs, [])
    |> cast_attachments(attrs, [:image], allow_paths: true)
  end
end

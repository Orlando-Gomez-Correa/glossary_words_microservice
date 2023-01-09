defmodule Glossary.WordsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Glossary.Words` context.
  """

  @doc """
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        code: "some code",
        description: "some description",
        name: "some name"
      })
      |> Glossary.Words.create_category()

    category
  end

  @doc """
  Generate a word.
  """
  def word_fixture(attrs \\ %{}) do
    {:ok, word} =
      attrs
      |> Enum.into(%{
        description: "some description",
        image: "some image",
        name: "some name"
      })
      |> Glossary.Words.create_word()

    word
  end
end

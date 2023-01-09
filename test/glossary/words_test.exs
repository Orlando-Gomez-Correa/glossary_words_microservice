defmodule Glossary.WordsTest do
  use Glossary.DataCase

  alias Glossary.Words

  describe "categories" do
    alias Glossary.Words.Category

    import Glossary.WordsFixtures

    @invalid_attrs %{code: nil, description: nil, name: nil}

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Words.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Words.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      valid_attrs = %{code: "some code", description: "some description", name: "some name"}

      assert {:ok, %Category{} = category} = Words.create_category(valid_attrs)
      assert category.code == "some code"
      assert category.description == "some description"
      assert category.name == "some name"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Words.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      update_attrs = %{code: "some updated code", description: "some updated description", name: "some updated name"}

      assert {:ok, %Category{} = category} = Words.update_category(category, update_attrs)
      assert category.code == "some updated code"
      assert category.description == "some updated description"
      assert category.name == "some updated name"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Words.update_category(category, @invalid_attrs)
      assert category == Words.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Words.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Words.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Words.change_category(category)
    end
  end

  describe "words" do
    alias Glossary.Words.Word

    import Glossary.WordsFixtures

    @invalid_attrs %{description: nil, image: nil, name: nil}

    test "list_words/0 returns all words" do
      word = word_fixture()
      assert Words.list_words() == [word]
    end

    test "get_word!/1 returns the word with given id" do
      word = word_fixture()
      assert Words.get_word!(word.id) == word
    end

    test "create_word/1 with valid data creates a word" do
      valid_attrs = %{description: "some description", image: "some image", name: "some name"}

      assert {:ok, %Word{} = word} = Words.create_word(valid_attrs)
      assert word.description == "some description"
      assert word.image == "some image"
      assert word.name == "some name"
    end

    test "create_word/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Words.create_word(@invalid_attrs)
    end

    test "update_word/2 with valid data updates the word" do
      word = word_fixture()
      update_attrs = %{description: "some updated description", image: "some updated image", name: "some updated name"}

      assert {:ok, %Word{} = word} = Words.update_word(word, update_attrs)
      assert word.description == "some updated description"
      assert word.image == "some updated image"
      assert word.name == "some updated name"
    end

    test "update_word/2 with invalid data returns error changeset" do
      word = word_fixture()
      assert {:error, %Ecto.Changeset{}} = Words.update_word(word, @invalid_attrs)
      assert word == Words.get_word!(word.id)
    end

    test "delete_word/1 deletes the word" do
      word = word_fixture()
      assert {:ok, %Word{}} = Words.delete_word(word)
      assert_raise Ecto.NoResultsError, fn -> Words.get_word!(word.id) end
    end

    test "change_word/1 returns a word changeset" do
      word = word_fixture()
      assert %Ecto.Changeset{} = Words.change_word(word)
    end
  end
end

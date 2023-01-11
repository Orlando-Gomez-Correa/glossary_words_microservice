defmodule GlossaryWeb.CategoryView do
  use GlossaryWeb, :view
  alias GlossaryWeb.{CategoryView, WordView}

  # def render("index.json", %{categories: categories}) do
  #   %{data: render_many(categories, CategoryView, "category_with_words.json")}
  # end

  def render("show.json", %{category: category}) do
    %{data: render_one(category, CategoryView, "category_with_words.json")}
  end

  def render("category.json", %{category: category}) do
    %{
      id: category.id,
      name: category.name,
      description: category.description,
      code: category.code
    }
  end

  def render("category_with_words.json", %{category: category}) do
    %{
      id: category.id,
      name: category.name,
      description: category.description,
      code: category.code,
      words: render_many(category.words, WordView, "word.json")
    }
  end

  def render("index.json", %{categories: categories}) do
    %{
      first: categories.first,
      has_next: categories.has_next,
      has_prev: categories.has_prev,
      last: categories.last,
      categories: render_many(categories.list, __MODULE__, "category_with_words.json"),
      next_page: categories.next_page,
      page: categories.page,
      prev_page: categories.prev_page,
      total_count: categories.total_count
    }
  end
end

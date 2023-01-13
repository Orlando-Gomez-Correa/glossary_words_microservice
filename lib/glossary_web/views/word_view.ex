defmodule GlossaryWeb.WordView do
  use GlossaryWeb, :view
  alias GlossaryWeb.WordView

  def render("show.json", %{word: word}) do
    %{data: render_one(word, WordView, "word.json")}
  end

  def render("word.json", %{word: word}) do
    %{
      id: word.id,
      name: word.name,
      description: word.description,
      image: word.image,
      category_id: word.category_id
    }
  end

  def render("index.json", %{words: words}) do
    %{
      first: words.first,
      has_next: words.has_next,
      has_prev: words.has_prev,
      last: words.last,
      words: render_many(words.list, __MODULE__, "word.json"),
      next_page: words.next_page,
      page: words.page,
      prev_page: words.prev_page,
      total_count: words.total_count
    }
  end
end

defmodule GlossaryWeb.WordController do
  use GlossaryWeb, :controller

  alias Glossary.Words
  alias Glossary.Words.{Word}

  action_fallback GlossaryWeb.FallbackController

  def index(conn, params) do
    page = params["page"] || 1
    page_size = params["page_size"] || 1
    category_id = params["category_id"]

    words = Words.list_words_with_pagination(:paged, page, page_size, category_id)

    case words != [] do
      true ->
        conn
        |> put_status(:ok)
        |> render("index.json", words: words)

      false ->
        conn
        |> put_status(200)
        |> json(%{error: "There are no words"})
    end
  end

  def create(conn, %{"category_id" => category_id, "word" => word_params}) do
    category = Words.get_category!(category_id)

    with {:ok, %Word{} = word} <- Words.create_word(category, word_params) do
      conn
      |> put_status(:created)
      |> render("show.json", word: word)
    end
  end

  def show(conn, %{"id" => id}) do
    word = Words.get_word!(id)
    render(conn, "show.json", word: word)
  end

  def update(conn, word_params) do
    word = Words.get_word!(conn.path_params["id"])

    with {:ok, %Word{} = word} <- Words.update_word(word, word_params) do
      render(conn, "show.json", word: word)
    end
  end

  def delete(conn, %{"id" => id}) do
    word = Words.get_word!(id)

    with {:ok, %Word{}} <- Words.delete_word(word) do
      send_resp(conn, :no_content, "")
    end
  end

  def upload_image(conn, params) do
    word = Words.get_word!(conn.path_params["id"])

    with {:ok, %Word{} = word} <- Words.update_word_image(word, params) do
      render(conn, "show.json", word: word)
    else
      {:error, _error} ->
        conn
        |> put_status(400)
        |> json(%{error: "Bad Request"})
        |> IO.inspect()
    end
  end

  def show_image(conn, %{"image" => image}) do
    file = File.read!("uploads/#{image}")

    conn
    |> put_status(200)
    |> send_resp(:ok, file)
  end

  def search_word(conn, params) do
    page = params["page"] || 1
    page_size = params["page_size"] || 1
    category_id = params["category_id"]
    term = params["name"]
    words = Words.list_search_words(:paged, page, page_size, category_id, term)

    case words != [] do
      true ->
        conn
        |> put_status(:ok)
        |> render("index.json", words: words)

      false ->
        conn
        |> put_status(200)
        |> json(%{error: "There are no words"})
    end
  end
end

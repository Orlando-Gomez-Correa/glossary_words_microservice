defmodule GlossaryWeb.WordController do
  use GlossaryWeb, :controller

  alias Glossary.Words
  alias Glossary.Words.{Word}

  action_fallback GlossaryWeb.FallbackController

  # def index(conn, _params) do
  #   words = Words.list_words()
  #   render(conn, "index.json", words: words)
  # end

  def index(conn, %{"category_id" => category_id}) do
    category = Words.get_category!(category_id)

    render(conn, "index.json", words: category.words)
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
end

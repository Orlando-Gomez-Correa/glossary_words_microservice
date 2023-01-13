defmodule GlossaryWeb.CategoryController do
  use GlossaryWeb, :controller

  alias Glossary.Words
  alias Glossary.Words.Category

  action_fallback GlossaryWeb.FallbackController

  def index(conn, params) do
    page = params["page"] || 1
    page_size = params["page_size"] || 1

    categories = Words.list_categories_with_pagination(:paged, page, page_size)

    case categories != [] do
      true ->
        conn
        |> put_status(:ok)
        |> render("index.json", categories: categories)

      false ->
        conn
        |> put_status(200)
        |> json(%{error: "There are no categories"})
    end
  end

  def create(conn, category_params) do
    with {:ok, %Category{} = category} <- Words.create_category(category_params) do
      conn
      |> put_status(:created)
      |> render("show.json", category: category)
    end
  end

  def show(conn, %{"id" => id}) do
    category = Words.get_category!(id)
    render(conn, "show.json", category: category)
  end

  def update(conn, category_params) do
    category = Words.get_category!(conn.path_params["id"])

    with {:ok, %Category{} = category} <- Words.update_category(category, category_params) do
      render(conn, "show.json", category: category)
    end
  end

  def delete(conn, %{"id" => id}) do
    category = Words.get_category!(id)

    with {:ok, %Category{}} <- Words.delete_category(category) do
      send_resp(conn, :no_content, "")
    end
  end

  def showTest(conn, %{"id" => id}) do
    category = Words.get_category!(id)
    render(conn, "show.json", category: category)
  end

  def search_category(conn, params) do
    page = params["page"] || 1
    page_size = params["page_size"] || 1
    term = params["name"]
    categories = Words.list_search_categories(:paged, page, page_size, term)

    case categories != [] do
      true ->
        conn
        |> put_status(:ok)
        |> render("index.json", categories: categories)

      false ->
        conn
        |> put_status(200)
        |> json(%{error: "There are no categories"})
    end
  end
end

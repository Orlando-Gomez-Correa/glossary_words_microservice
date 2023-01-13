defmodule Glossary.Words do
  @moduledoc """
  The Words context.
  """

  alias Glossary.Repo
  import Ecto.Query, warn: false

  alias Glossary.Words.{Category, Word}

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    q2 = from c in Category, preload: :words

    Repo.all(q2)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """

  # def get_category!(id), do: Repo.get!(Category, id)

  def get_category!(id) do
    Category
    |> Repo.get!(id)
    |> Repo.preload(:words)
  end

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, %Category{} = category} -> {:ok, Repo.preload(category, :words)}
      error -> error
    end
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{data: %Category{}}

  """
  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end

  alias Glossary.Words.Word

  @doc """
  Returns the list of words.

  ## Examples

      iex> list_words()
      [%Word{}, ...]

  """
  def list_words do
    Repo.all(Word)
  end

  @doc """
  Gets a single word.

  Raises `Ecto.NoResultsError` if the Word does not exist.

  ## Examples

      iex> get_word!(123)
      %Word{}

      iex> get_word!(456)
      ** (Ecto.NoResultsError)

  """
  def get_word!(id), do: Repo.get!(Word, id)

  @doc """
  Creates a word.

  ## Examples

      iex> create_word(%{field: value})
      {:ok, %Word{}}

      iex> create_word(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def create_word(%Category{} = category, attrs \\ %{}) do
    category
    |> Ecto.build_assoc(:words)
    |> Word.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a word.

  ## Examples

      iex> update_word(word, %{field: new_value})
      {:ok, %Word{}}

      iex> update_word(word, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_word(%Word{} = word, attrs) do
    word
    |> Word.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a word.

  ## Examples

      iex> delete_word(word)
      {:ok, %Word{}}

      iex> delete_word(word)
      {:error, %Ecto.Changeset{}}

  """
  def delete_word(%Word{} = word) do
    Repo.delete(word)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking word changes.

  ## Examples

      iex> change_word(word)
      %Ecto.Changeset{data: %Word{}}

  """
  def change_word(%Word{} = word, attrs \\ %{}) do
    Word.changeset(word, attrs)
  end

  def update_word_image(%Word{} = word, attrs) do
    word
    |> Word.avatar_changeset(attrs)
    |> Repo.update()
  end

  def change_word_image(%Word{} = word) do
    Word.avatar_changeset(word, %{})
  end

  # Pagination

  def list_categories_with_pagination(:paged, page, per_page) do
    Category
    |> order_by(asc: :name)
    |> Glossary.Words.page(page, per_page)
  end

  def list_words_with_pagination(:paged, page_word, per_page_word, category_id \\ nil) do
    Word
    |> order_by(asc: :name)
    |> Glossary.Words.page_word(page_word, per_page_word, category_id)
  end

  # PAGINATE TO CATEGORY

  def query(query, page, per_page) when is_nil(page) do
    query(query, 0, per_page)
  end

  def query(query, page, per_page) when is_nil(per_page) do
    query(query, page, 0)
  end

  def query(query, page, per_page) when is_binary(page) do
    query(query, String.to_integer(page), per_page)
  end

  def query(query, page, per_page) when is_binary(per_page) do
    query(query, page, String.to_integer(per_page))
  end

  def query(query, page, per_page) do
    query
    |> limit(^(per_page + 0))
    |> offset(^(per_page * (page - 1)))
    |> Repo.all()
  end

  def page(query, page, per_page) when is_binary(page) do
    page(query, String.to_integer(page), per_page)
  end

  def page(query, page, per_page) when is_binary(per_page) do
    page(query, page, String.to_integer(per_page))
  end

  def page(query, page, per_page) do
    results = query(query, page, per_page)
    has_next = length(results) > per_page
    has_prev = page > 1
    total_count = Repo.one(from(t in subquery(query), select: count("*")))

    %{
      has_next: has_next,
      has_prev: has_prev,
      prev_page: page - 1,
      page: page,
      next_page: page + 1,
      first: (page - 1) * per_page + 1,
      last: Enum.min([page * per_page, total_count]),
      total_count: total_count,
      list: Enum.slice(results, 0, per_page) |> Repo.preload(:words)
    }
  end

  # PAGINATE TO WORD

  def query_word(query_word, page_word, per_page_word, category_id) when is_nil(page_word) do
    query_word(query_word, 0, per_page_word, category_id)
  end

  def query_word(query_word, page_word, per_page_word, category_id) when is_nil(per_page_word) do
    query_word(query_word, page_word, 0, category_id)
  end

  # ---------------------------

  def query_word(query_word, page_word, per_page_word, category_id) when is_binary(page_word) do
    query_word(query_word, String.to_integer(page_word), per_page_word, category_id)
  end

  def query_word(query_word, page_word, per_page_word, category_id)
      when is_binary(per_page_word) do
    query_word(query_word, page_word, String.to_integer(per_page_word), category_id)
  end

  # -------------------------------

  def query_word(query_word, page_word, per_page_word, category_id)
      when not is_nil(category_id) do
    query_word
    |> where([word], word.category_id == ^category_id)
    |> query_word(page_word, per_page_word, nil)
  end

  # -------------------------------

  def query_word(query_word, page_word, per_page_word, nil) do
    results =
      query_word
      |> limit(^(per_page_word + 0))
      |> offset(^(per_page_word * (page_word - 1)))
      |> Repo.all()

    total_count = query_word |> Repo.aggregate(:count)
    {results, total_count}
  end

  # --------------------------
  def page_word(query_word, page_word, per_page_word, category_id) when is_binary(page_word) do
    page_word(query_word, String.to_integer(page_word), per_page_word, category_id)
  end

  def page_word(query_word, page_word, per_page_word, category_id)
      when is_binary(per_page_word) do
    page_word(query_word, page_word, String.to_integer(per_page_word), category_id)
  end

  # ------------------------------------------

  def page_word(query_word, page_word, per_page_word, category_id) do
    {results, total_count} = query_word(query_word, page_word, per_page_word, category_id)
    has_next = length(results) > per_page_word
    has_prev = page_word > 1

    %{
      has_next: has_next,
      has_prev: has_prev,
      prev_page: page_word - 1,
      page: page_word,
      next_page: page_word + 1,
      first: (page_word - 1) * per_page_word + 1,
      last: Enum.min([page_word * per_page_word, total_count]),
      total_count: total_count,
      list: Enum.slice(results, 0, per_page_word)
    }
  end

  # SEARCH
  def list_search_categories(:paged, page, per_page, term) do
    search_term = "%#{term}%"

    Category
    |> where([c], ilike(c.name, ^search_term))
    |> or_where([c], ilike(c.code, ^search_term))
    |> order_by(asc: :name)
    |> __MODULE__.page(page, per_page)
  end

  def list_search_words(:paged, page_word, per_page_word, category_id \\ nil, term) do
    search_term = "%#{term}%"

    Word
    |> where([c], ilike(c.name, ^search_term))
    |> order_by(asc: :name)
    |> __MODULE__.page_word(page_word, per_page_word, category_id)
  end
end

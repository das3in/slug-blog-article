defmodule Blog.Blogs.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Blog.Blogs.Post


  schema "posts" do
    field :body, :string
    field :title, :string
    field :slug, :string

    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    attrs = Map.merge(attrs, slugify_title(attrs))

    post
    |> cast(attrs, [:title, :body, :slug])
    |> validate_required([:title, :body])
  end

  defp slugify_title(%{"title" => title}) do
    slug =
      title
      |> String.downcase
      |> String.replace(~r/[^a-z0-9\s-]/, "")
      |> String.replace(~r/(\s|-)+/, "-")

    %{"slug" => slug}
  end

  defp slugify_title(_params) do
    %{}
  end
end

defimpl Phoenix.Param, for: Blog.Blogs.Post do
  def to_param(%{slug: slug}) do
    "#{slug}"
  end
end

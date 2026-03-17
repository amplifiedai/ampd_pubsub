defmodule Amplified.PubSubTest.Thing do
  @moduledoc false
  use Ecto.Schema
  use Amplified.PubSub

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "things" do
    field :name, :string
  end
end

defmodule Amplified.PubSubTest.Custom do
  @moduledoc false
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "customs" do
    field :name, :string
  end

  defimpl Amplified.PubSub.Protocol do
    use Amplified.PubSub, impl: true
    def channel(%{name: name}, _ns), do: "custom:#{name}"
  end
end

defmodule Amplified.PubSubTest.Handled do
  @moduledoc """
  A test struct with custom handle_info/3 and handle_info/4 implementations
  to verify that protocol dispatch calls schema-level handlers.
  """
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "handleds" do
    field :name, :string
  end

  use Amplified.PubSub do
    def handle_info(%Handled{} = handled, :updated, socket) do
      {:halt, Phoenix.Component.assign(socket, :handled, handled)}
    end

    def handle_info(%Handled{}, :updated, %{changed: changed}, socket) do
      {:halt, Phoenix.Component.assign(socket, :changed, changed)}
    end
  end
end

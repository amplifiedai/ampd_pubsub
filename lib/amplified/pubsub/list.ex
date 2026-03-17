defimpl Amplified.PubSub.Protocol, for: List do
  @moduledoc ~S'''
  Protocol implementation for lists.

  Maps PubSub operations across each element of the list. This lets you
  subscribe to or broadcast for a collection of structs in a single call.

  ## Broadcasting

  For a single-element list, `broadcast/2` delegates directly to the
  element's implementation.

  For multi-element lists, items are grouped by channel and a single
  `[{item, event}, ...]` message is sent per channel. This is more
  efficient than broadcasting individually and lets subscribers receive
  batch updates. Items wrapped in `{:ok, item}` are unwrapped; `{:error, _}`
  items are silently skipped.

  ## Subscribing

  `subscribe/1` subscribes to each element's channel individually.

  ## Channel

  `channel/1` returns a list of channel names, one per element.

  ## Message handling

  `handle_info/2` expects a list of `{struct, message}` tuples (as produced
  by the multi-element broadcast). It reduces over the list, calling each
  struct's `handle_info/3` and threading the socket through.

  ## Examples

      posts = [%Post{id: "1"}, %Post{id: "2"}]

      Amplified.PubSub.subscribe(posts)
      # subscribes to "post:1" and "post:2"

      Amplified.PubSub.channel(posts)
      #=> ["post:1", "post:2"]

      Amplified.PubSub.broadcast(posts, :archived)
      # groups by channel, sends [{post, :archived}] per channel
  '''

  use Amplified.PubSub, impl: true

  def broadcast([item], message), do: [PubSub.broadcast(item, message)]

  def broadcast(items, message) do
    items
    |> Stream.flat_map(&extract_tuple/1)
    |> Enum.group_by(&PubSub.channel/1)
    |> Enum.each(fn {channel, items} ->
      items |> Enum.map(&{&1, message}) |> then(&PubSub.broadcast(channel, &1))
    end)

    items
  end

  defp extract_tuple({:ok, item}), do: [item]
  defp extract_tuple({:error, _}), do: []
  defp extract_tuple(item), do: [item]

  def channel(list, ns \\ nil), do: Enum.map(list, &PubSub.channel(&1, ns))
  def subscribe(list), do: Enum.map(list, &PubSub.subscribe/1)
  def unsubscribe(list), do: Enum.map(list, &PubSub.subscribe/1)

  def handle_info(list, socket) do
    list
    |> Enum.reduce(socket, fn {struct, message}, socket ->
      struct |> PubSub.handle_info(message, socket) |> elem(1)
    end)
    |> then(&{:cont, &1})
  end
end

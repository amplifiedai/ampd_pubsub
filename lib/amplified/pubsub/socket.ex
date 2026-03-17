defimpl Amplified.PubSub.Protocol, for: Phoenix.LiveView.Socket do
  @moduledoc """
  Protocol implementation for `Phoenix.LiveView.Socket`.

  Derives a channel from the socket's session ID, enabling per-session
  PubSub messaging. This is useful for sending messages to a specific
  user's browser session.

  ## Behaviour

    * `channel/2` — returns `"socket:<session_id>"`, optionally with a
      namespace appended.

  All other protocol functions (`broadcast`, `subscribe`, `unsubscribe`,
  `handle_info`) use the defaults from `use Amplified.PubSub, impl: true`.

  ## Child LiveViews

  Raises for child LiveViews (those not mounted at the router) because
  their socket IDs are not unique — they inherit the parent's ID, which
  would cause channel collisions.

  ## Examples

      Amplified.PubSub.channel(socket)
      #=> "socket:phx-F1a2b3c4"

      Amplified.PubSub.channel(socket, :typing)
      #=> "socket:phx-F1a2b3c4:typing"

  """

  use Amplified.PubSub, impl: true

  def channel(socket, ns \\ nil)

  def channel(%{host_uri: :not_mounted_at_router, id: id, view: view}, _ns) do
    view = view |> Module.split() |> Enum.join(".")

    raise(
      "Cannot subscribe or broadcast to a socket for the child LiveView #{view}, because the " <>
        "socket ID is not unique (in this case it's '#{id}')"
    )
  end

  def channel(%{id: id}, ns), do: PubSub.channel("socket:#{id}", ns)
end

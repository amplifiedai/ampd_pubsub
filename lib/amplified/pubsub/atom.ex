defimpl Amplified.PubSub.Protocol, for: Atom do
  @moduledoc """
  Protocol implementation for atoms.

  Atoms are converted to string channels (e.g. `:users` becomes `"users"`).
  Broadcasting is a no-op — the message is returned without actually
  publishing anything. This is useful for placeholder or sentinel values
  where you want to derive a channel name but don't need to broadcast.

  ## Behaviour

    * `broadcast/2,3` — returns the message unchanged (no-op).

    * `channel/2` — converts the atom to a string and delegates to the
      `BitString` implementation for namespace handling.

  ## Examples

      Amplified.PubSub.channel(:users)
      #=> "users"

      Amplified.PubSub.channel(:users, :admin)
      #=> "users:admin"

      Amplified.PubSub.broadcast(:ignored, {:some, :message})
      #=> {:some, :message}

  """

  use Amplified.PubSub, impl: true
  def broadcast(_atom, message), do: message
  def broadcast(_atom, message, _attrs), do: message
  def channel(atom, ns \\ nil), do: PubSub.channel("#{atom}", ns)
end

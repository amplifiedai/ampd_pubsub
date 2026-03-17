Application.put_env(:ampd_pubsub, Amplified.PubSub.TestEndpoint,
  pubsub_server: :ampd_pubsub_test,
  secret_key_base: String.duplicate("a", 64)
)

{:ok, _} = Phoenix.PubSub.Supervisor.start_link(name: :ampd_pubsub_test)
{:ok, _} = Amplified.PubSub.TestEndpoint.start_link()

ExUnit.start()

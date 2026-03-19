{:ok, _} = Phoenix.PubSub.Supervisor.start_link(name: :ampd_pubsub_test)

ExUnit.start()

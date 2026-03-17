defmodule Amplified.PubSub.ConfigTest do
  use ExUnit.Case, async: true

  alias Amplified.PubSub

  describe "endpoint/0" do
    test "returns the configured endpoint module" do
      assert PubSub.endpoint() == Amplified.PubSub.TestEndpoint
    end
  end

  describe "pubsub_server/0" do
    test "returns the PubSub server name from the endpoint config" do
      assert PubSub.pubsub_server() == :ampd_pubsub_test
    end
  end
end

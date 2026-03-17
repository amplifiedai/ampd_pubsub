defmodule Amplified.PubSub.ImplForTest do
  use ExUnit.Case, async: true

  alias Amplified.PubSub
  alias Amplified.PubSubTest.Custom
  alias Amplified.PubSubTest.Handled
  alias Amplified.PubSubTest.Thing

  describe "impl_for/1" do
    test "returns the implementation module for each built-in type" do
      assert PubSub.impl_for("string") == Amplified.PubSub.Protocol.BitString
      assert PubSub.impl_for(:atom) == Amplified.PubSub.Protocol.Atom
      assert PubSub.impl_for({:ok, :value}) == Amplified.PubSub.Protocol.Tuple
      assert PubSub.impl_for([]) == Amplified.PubSub.Protocol.List
      assert PubSub.impl_for(%Thing{})
      assert PubSub.impl_for(%Custom{})
      assert PubSub.impl_for(%Handled{})
    end

    test "returns nil for types without an implementation" do
      refute PubSub.impl_for(42)
      refute PubSub.impl_for(%{plain: :map})
      refute PubSub.impl_for(self())
    end
  end

  describe "impl_for!/1" do
    test "returns the implementation module for known types" do
      assert PubSub.impl_for!("string") == Amplified.PubSub.Protocol.BitString
    end

    test "raises Protocol.UndefinedError for unknown types" do
      assert_raise Protocol.UndefinedError, fn ->
        PubSub.impl_for!(42)
      end
    end
  end
end

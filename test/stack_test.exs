defmodule StackTest do
  use ExUnit.Case
  doctest Stack

  test "stack can receive pushed integers and pop them back correctly" do
    assert Stack.Server.push(3) == :ok
    assert Stack.Server.push(2) == :ok
    assert Stack.Server.push(1) == :ok
    assert Stack.Server.pop()   == 1
    assert Stack.Server.pop()   == 2
    assert Stack.Server.pop()   == 3
  end

  test "stack pop raises error when empty" do
    assert_raise RuntimeError, fn ->
      Stack.Server.pop()
    end
  end
end

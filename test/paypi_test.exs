defmodule PaypiTest do
  use ExUnit.Case
  doctest Paypi

  test "greets the world" do
    assert Paypi.hello() == :world
  end
end

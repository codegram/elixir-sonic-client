defmodule SonicClient.Modes.SearchTest do
  use ExUnit.Case
  alias SonicClient.Modes.Search
  import SonicClient.TestConnectionHelper

  setup_all do
    add_data("user:1", "It is a common test")
    add_data("user:2", "It is a common testable text")
    add_data("user:3", "It should not appear in the common search")

    on_exit(fn -> flush() end)
  end

  describe "#query" do
    test "returns empty list" do
      conn = start_connection("search")
      assert {:ok, []} = Search.query(conn, "test_collection", "default_bucket", "non-existent")
      stop_connection(conn)
    end

    test "returns list of elements" do
      conn = start_connection("search")

      assert {:ok, ["user:1", "user:2"]} =
               Search.query(conn, "test_collection", "default_bucket", "test")

      stop_connection(conn)
    end

    test "returns list of elements based on alternate words" do
      conn = start_connection("search")

      assert {:ok, ["user:1"]} = Search.query(conn, "test_collection", "default_bucket", "tist")

      stop_connection(conn)
    end

    test "returns list of elements when limit 1" do
      conn = start_connection("search")

      assert {:ok, ["user:1"]} =
               Search.query(conn, "test_collection", "default_bucket", "test", limit: 1)

      stop_connection(conn)
    end

    test "returns list of elements when offset 1" do
      conn = start_connection("search")

      assert {:ok, ["user:2"]} =
               Search.query(conn, "test_collection", "default_bucket", "test", offset: 1)

      stop_connection(conn)
    end

    test "returns list of elements when limit 1 and offset 1" do
      conn = start_connection("search")

      assert {:ok, ["user:2"]} =
               Search.query(conn, "test_collection", "default_bucket", "common",
                 limit: 1,
                 offset: 1
               )

      stop_connection(conn)
    end
  end
end
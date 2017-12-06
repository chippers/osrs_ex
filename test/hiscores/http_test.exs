defmodule OsrsExTest.Hiscores.HttpTest do
  use ExUnit.Case, async: true

  # All tests will ping the Jagex Hiscores API
  @moduletag :hiscores_api

  test "fetches player from api" do
    case OsrsEx.Hiscores.fetch_hiscore("zezima") do
      {:ok, hiscore} -> assert hiscore.__struct__ == OsrsEx.Hiscores.Hiscore
      {:error, reason} -> assert reason == :player_not_found
    end
  end
end

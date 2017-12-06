defmodule OsrsExTest.Hiscores.HiscoresTest do
  use ExUnit.Case, async: true

  @raw_api_response "344102,1304,12889194\n380897,72,987257\n369808,70,770635\n608649,70,737679\n588948,70,755044\n1021823,43,53916\n549222,46,70401\n1029410,46,68002\n177227,77,1560984\n223287,73,1002461\n322548,68,657325\n151763,76,1444494\n79352,84,3207707\n536979,51,115396\n613800,42,49729\n408093,58,235157\n418775,41,44182\n263295,64,438227\n411374,52,132828\n328894,65,466146\n333503,40,37779\n388462,32,18003\n389431,33,19878\n430099,31,15964\n-1,-1\n-1,-1\n-1,-1\n-1,-1\n-1,-1\n-1,-1\n-1,-1\n-1,-1\n-1,-1\n"

  test "formats hiscores from raw api response" do
    {status, hiscore} = OsrsEx.Hiscores.new(@raw_api_response)
    assert status == :ok
    assert hiscore.__struct__ == OsrsEx.Hiscores.Hiscore
    assert hiscore.overall.level == 1304
  end

  test "formats raw hiscores url from username" do
    url = OsrsEx.Hiscores.raw_url("lynx titan")
    assert url == "http://services.runescape.com/m=hiscore_oldschool/index_lite.ws?player=lynx%20titan"
  end
end

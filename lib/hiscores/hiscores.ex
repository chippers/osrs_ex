defmodule OsrsEx.Hiscores do
  @moduledoc """
    For working with the Jagex Hiscores API.

    It is **EXTREMELY** important to note that this module transforms the data
    it recieves from the Jagex Hiscores API.  The Jagex Hiscores API will
    randomly return either `-1` or the true level/xp/score when a player is
    unranked in that skill or activity.  `OsrsEx.Hiscores` formats the incoming
    data so that if a skill or activity hiscore is unranked, the values that go
    with that are the absolute minimum.  This means `0` for activty scores and
    skill xp, and `1` for skill levels (`10` for `:hitpoints`).
  """

  alias HTTPoison.Response
  alias OsrsEx.Hiscores.Hiscore
  alias OsrsEx.Hiscores.{Skill, Activity}

  @skills [
    :overall,
    :attack,
    :defence,
    :strength,
    :hitpoints,
    :ranged,
    :prayer,
    :magic,
    :cooking,
    :woodcutting,
    :fletching,
    :fishing,
    :firemaking,
    :crafting,
    :smithing,
    :mining,
    :herblore,
    :agility,
    :thieving,
    :slayer,
    :farming,
    :runecraft,
    :hunter,
    :construction,
  ]

  @activities [
    :clue_scroll_easy,
    :clue_scroll_medium,
    :clue_scroll_all,
    :bounty_hunter_rogue,
    :bounty_hunter_hunter,
    :clue_scroll_hard,
    :last_man_standing,
    :clue_scroll_elite,
    :clue_scroll_master,
  ]

  @hiscore_order @skills ++ @activities

  @hiscore_length length(@hiscore_order)

  @url "http://services.runescape.com/m=hiscore_oldschool/index_lite.ws?player="

  @doc "Gives the raw url to a player's hiscores."
  @spec raw_url(String.t) :: String.t
  def raw_url(username), do: @url <> URI.encode(username)

  @doc """
    Fetches a player's hiscores from the Jagex Hiscore API.

    Results in a tuple containing the status `:ok` or `:error`
    and the appropriate result with the status.

    A Hiscore is retrievable from `{:ok, %OsrsEx.Hiscores.Hiscore{...}}`
  """
  @spec fetch_hiscore(String.t) ::
          {:ok, Hiscore.t} |
          {:error, :player_not_found} |
          {:error, :bad_api_response} |
          {:error, :bad_hiscores_format} |
          {:error, HTTPoison.Error.t}
  def fetch_hiscore(username) do
    with {:ok, response} <- HTTPoison.get(@url <> username),
         {:ok, raw_body} <- get_body(response),
         do: new(raw_body)
  end

  @spec get_body(Response.t)
        :: {:ok, term} |
           {:error, :player_not_found} |
           {:error, :bad_api_response}
  defp get_body(%Response{status_code: 200, body: body}), do: {:ok, body}
  defp get_body(%Response{status_code: 404}), do: {:error, :player_not_found}
  defp get_body(_), do: {:error, :bad_api_response}

  @doc """
    Takes a raw Jagex Hiscore API response and transforms it
    into a `OsrsEx.Hiscores.Hiscore`.
  """
  @spec new(String.t) :: {:ok, Hiscore.t} | {:error, :bad_hiscores_format}
  def new(raw_api_response) do
    with {:ok, raw_hiscores} <- parse_raw_api_response(raw_api_response),
         hiscore <- parse_raw_hiscores(raw_hiscores),
         do: {:ok, hiscore}
  end

  @spec parse_raw_api_response(String.t)
        :: {:ok, {atom, map}} |
           {:error, :bad_hiscores_format}
  defp parse_raw_api_response(raw_api_response) do
    raw_api_response
    |> String.split()
    |> align_hiscores()
  end

  @spec align_hiscores(list(String.t))
        :: {:ok, {atom, map}} |
           {:error, :bad_hiscores_format}
  defp align_hiscores(data) when length(data) == @hiscore_length do
    datum = Enum.map(data, &parse_data/1)
    {:ok, Enum.zip(@hiscore_order, datum)}
  end
  defp align_hiscores(_) do
    {:error, :bad_hiscores_format}
  end

  @typep aligned :: %{rank: Skill.rank, level: Skill.level, xp: Skill.xp} |
                    %{rank: Activity.rank, score: Activity.score}

  @spec parse_data(String.t) :: aligned
  defp parse_data(data) do
    data
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> align_data()
  end

  @spec align_data(list(integer)) :: aligned
  defp align_data([-1, _level, _xp]), do: %{rank: nil, level: 1, xp: 0}
  defp align_data([rank, level, xp]), do: %{rank: rank, level: level, xp: xp}
  defp align_data([-1, _score]), do: %{rank: nil, score: 0}
  defp align_data([rank, score]), do: %{rank: rank, score: score}

  @spec parse_raw_hiscores([{atom, map}]) :: Hiscore.t
  defp parse_raw_hiscores(raw_hiscores) do
    Enum.reduce(raw_hiscores, %Hiscore{}, &parse_hiscore/2)
  end

  @spec parse_hiscore({atom, map}, Hiscore.t) :: Hiscore.t
  defp parse_hiscore({:hitpoints, hiscore}, acc) do
    hiscore = Map.put(hiscore, :level, max(10, hiscore.level))
    skill_hiscore = struct(Skill, hiscore)
    Map.put(acc, :hitpoints, skill_hiscore)
  end
  defp parse_hiscore({skill, hiscore}, acc) when skill in @skills do
    skill_hiscore = struct(Skill, hiscore)
    Map.put(acc, skill, skill_hiscore)
  end
  defp parse_hiscore({activity, hiscore}, acc) when activity in @activities do
    activity_hiscore = struct(Activity, hiscore)
    Map.put(acc, activity, activity_hiscore)
  end
end

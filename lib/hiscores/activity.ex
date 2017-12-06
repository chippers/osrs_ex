defmodule OsrsEx.Hiscores.Activity do
  @moduledoc "A Hiscores Activity."

  alias OsrsEx.Hiscores

  defstruct [
    :rank,
    :score,
  ]

  @typedoc """
    The rank of the player compared to all other players in the activity.

    If the player is not in the top `2_000_000`, then they are unranked
    and represented as `nil`.
  """
  @type rank :: 1..2_000_000 | nil

  @typedoc """
    The score a player has in an Activity.

    While the Jagex Hiscore API will return `-1` for unranked players,
    `OsrsEx` ensures that the minimum score is `0`.
  """
  @type score :: non_neg_integer

  @typedoc "A struct for representing an anonymous skill tuple as returned from the hiscores"
  @type t :: %__MODULE__{
               rank: rank,
               score: score,
             }
end

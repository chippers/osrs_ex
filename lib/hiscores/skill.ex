defmodule OsrsEx.Hiscores.Skill do
  @moduledoc "A Hiscores Skill."

  alias OsrsEx.Hiscores

  defstruct [
    :rank,
    :xp,
    :level,
  ]

  @typedoc """
    The rank of the player compared to all other players in the skill.

    If the player is not in the top `2_000_000`, then they are unranked
    and represented as `nil`.
  """
  @type rank :: 1..2_000_000 | nil

  @typedoc """
    The amount of experience a player has in a skill.

    The xp is capped between having none (`0`) and the maximum experience
    achievable before no more experience is rewarded (`200_000_000`).

    The Jagex Hiscore API is inconsistent when the player is unranked. It
    will randomly return either the players true xp or `-1`.
    `OsrsEx` makes sure the minimum is always `0`.
  """
  @type xp :: 0..200_000_000

  @typedoc """
    The level a player has in a skill.

    The level is capped between what an account starts with (`1`) and the
    maximum level achievable (`99`).  The minimum level for `:hitpoints`
    is `10` instead of `1` due to all accounts starting at level `10`.

    The Jagex Hiscore API is inconsistent when the player is unranked. It
    will randomly return either the players true level or `-1`.
    `OsrsEx` makes sure the minimum is always `1`.
  """
  @type level :: 0..99

  @typedoc "A struct for representing an anonymous skill tuple as returned from the hiscores"
  @type t :: %__MODULE__{
               rank: rank,
               xp: xp,
               level: level,
             }
end

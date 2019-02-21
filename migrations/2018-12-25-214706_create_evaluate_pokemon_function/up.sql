CREATE OR REPLACE FUNCTION evaluate_pokemon(primary_type INT, secondary_type INT, fast_attack_type INT, charged_attack_type INT, second_charged_attack_type INT)
RETURNS TABLE (
  score NUMERIC,
  primary_type_name VARCHAR,
  secondary_type_name VARCHAR,
  fast_attack_dmg_multiplier NUMERIC,
  charged_attack_dmg_multiplier NUMERIC,
  dmg_received_from_primary_type_multiplier NUMERIC,
  dmg_received_from_secondary_type_multiplier NUMERIC,
  charged_attack_type_name VARCHAR,
  number_of_pokemon BIGINT,
  max_cp INT,
  best_pokemon_name VARCHAR
) AS
$func$
BEGIN
  RETURN QUERY
  SELECT
    matchup.fast_attack_dmg_multiplier
      + matchup.charged_attack_dmg_multiplier
      - matchup.dmg_received_from_primary_type_multiplier
      - matchup.dmg_received_from_secondary_type_multiplier
    AS score,
    matchup.primary_type,
    matchup.secondary_type,
    matchup.fast_attack_dmg_multiplier,
    matchup.charged_attack_dmg_multiplier,
    matchup.dmg_received_from_primary_type_multiplier,
    matchup.dmg_received_from_secondary_type_multiplier,
    matchup.charged_attack_type,
    matchup.number_of_pokemon,
    matchup.max_cp,
    pokemon.name AS best_pokemon_name
  FROM
    (
      SELECT
        pokemon_types_1.id AS primary_type_id,
        pokemon_types_1.name AS primary_type,
        CASE WHEN pokemon_types_1.id = pokemon_types_2.id
             THEN NULL
             ELSE pokemon_types_2.id
        END AS secondary_type_id,
        CASE WHEN pokemon_types_1.id = pokemon_types_2.id
             THEN NULL
             ELSE pokemon_types_2.name
        END AS secondary_type,
        CASE WHEN pokemon_types_1.id = pokemon_types_2.id
             THEN CASE WHEN fast_attack_type IN (primary_type, secondary_type)
                       THEN 1.2 * fast_attack_effectiveness_vs_primary_type.effectiveness
                       ELSE fast_attack_effectiveness_vs_primary_type.effectiveness
                  END
             ELSE CASE WHEN fast_attack_type IN (primary_type, secondary_type)
                       THEN 1.2 * fast_attack_effectiveness_vs_primary_type.effectiveness * fast_attack_effectiveness_vs_secondary_type.effectiveness
                       ELSE fast_attack_effectiveness_vs_primary_type.effectiveness * fast_attack_effectiveness_vs_secondary_type.effectiveness
                  END
        END AS fast_attack_dmg_multiplier,
        CASE WHEN pokemon_types_1.id = pokemon_types_2.id
             THEN CASE WHEN charged_attack_types.id IN (primary_type, secondary_type)
                       THEN 1.2 * charged_attack_effectiveness_vs_primary_type.effectiveness
                       ELSE charged_attack_effectiveness_vs_primary_type.effectiveness
                  END
             ELSE CASE WHEN charged_attack_types.id IN (primary_type, secondary_type)
                       THEN 1.2 * charged_attack_effectiveness_vs_primary_type.effectiveness * charged_attack_effectiveness_vs_secondary_type.effectiveness
                       ELSE charged_attack_effectiveness_vs_primary_type.effectiveness * charged_attack_effectiveness_vs_secondary_type.effectiveness
                  END
        END AS charged_attack_dmg_multiplier,
        CASE WHEN primary_type = secondary_type
             THEN dmg_received_from_primary_type_vs_primary_type.effectiveness
             ELSE dmg_received_from_primary_type_vs_primary_type.effectiveness * dmg_received_from_primary_type_vs_secondary_type.effectiveness
        END AS dmg_received_from_primary_type_multiplier,
        CASE WHEN primary_type = secondary_type
             THEN dmg_received_from_secondary_type_vs_primary_type.effectiveness
             ELSE dmg_received_from_secondary_type_vs_primary_type.effectiveness * dmg_received_from_secondary_type_vs_secondary_type.effectiveness
        END AS dmg_received_from_secondary_type_multiplier,
        charged_attack_types.name AS charged_attack_type,
        MAX(pokemon.max_cp) AS max_cp,
        COUNT(pokemon.id) AS number_of_pokemon
      FROM
        pokemon,
        pokemon_types AS charged_attack_types,
        pokemon_types AS pokemon_types_1
          JOIN pokemon_type_effectivenesses fast_attack_effectiveness_vs_primary_type
            ON fast_attack_effectiveness_vs_primary_type.defending_type_id = pokemon_types_1.id
              AND fast_attack_effectiveness_vs_primary_type.attacking_type_id = fast_attack_type
          JOIN pokemon_type_effectivenesses charged_attack_effectiveness_vs_primary_type
            ON charged_attack_effectiveness_vs_primary_type.defending_type_id = pokemon_types_1.id
          JOIN pokemon_type_effectivenesses dmg_received_from_primary_type_vs_primary_type
            ON dmg_received_from_primary_type_vs_primary_type.attacking_type_id = pokemon_types_1.id
              AND dmg_received_from_primary_type_vs_primary_type.defending_type_id = primary_type
          JOIN pokemon_type_effectivenesses dmg_received_from_primary_type_vs_secondary_type
            ON dmg_received_from_primary_type_vs_secondary_type.attacking_type_id = pokemon_types_1.id
              AND dmg_received_from_primary_type_vs_secondary_type.defending_type_id = secondary_type,
        pokemon_types AS pokemon_types_2
          JOIN pokemon_type_effectivenesses fast_attack_effectiveness_vs_secondary_type
            ON fast_attack_effectiveness_vs_secondary_type.defending_type_id = pokemon_types_2.id
              AND fast_attack_effectiveness_vs_secondary_type.attacking_type_id = fast_attack_type
          JOIN pokemon_type_effectivenesses charged_attack_effectiveness_vs_secondary_type
            ON charged_attack_effectiveness_vs_secondary_type.defending_type_id = pokemon_types_2.id
          JOIN pokemon_type_effectivenesses dmg_received_from_secondary_type_vs_primary_type
            ON dmg_received_from_secondary_type_vs_primary_type.attacking_type_id = pokemon_types_2.id
              AND dmg_received_from_secondary_type_vs_primary_type.defending_type_id = primary_type
          JOIN pokemon_type_effectivenesses dmg_received_from_secondary_type_vs_secondary_type
            ON dmg_received_from_secondary_type_vs_secondary_type.attacking_type_id = pokemon_types_2.id
              AND dmg_received_from_secondary_type_vs_secondary_type.defending_type_id = secondary_type
      WHERE
        (
          (
            pokemon.primary_type_id = pokemon_types_1.id AND pokemon.secondary_type_id = pokemon_types_2.id
          ) OR (
            pokemon.primary_type_id = pokemon_types_1.id AND pokemon.primary_type_id = pokemon_types_2.id AND pokemon.secondary_type_id IS NULL
          ) OR (
            pokemon.primary_type_id = pokemon_types_2.id AND pokemon.secondary_type_id = pokemon_types_1.id
          )
        )
        AND pokemon_types_1.id <= pokemon_types_2.id
        AND charged_attack_types.id IN (charged_attack_type, second_charged_attack_type)
        AND charged_attack_effectiveness_vs_primary_type.attacking_type_id = charged_attack_types.id
        AND charged_attack_effectiveness_vs_secondary_type.attacking_type_id = charged_attack_types.id
      GROUP BY
        pokemon_types_1.id,
        pokemon_types_2.id,
        fast_attack_effectiveness_vs_primary_type.effectiveness,
        fast_attack_effectiveness_vs_secondary_type.effectiveness,
        charged_attack_effectiveness_vs_primary_type.effectiveness,
        charged_attack_effectiveness_vs_secondary_type.effectiveness,
        dmg_received_from_primary_type_vs_primary_type.effectiveness,
        dmg_received_from_primary_type_vs_secondary_type.effectiveness,
        dmg_received_from_secondary_type_vs_primary_type.effectiveness,
        dmg_received_from_secondary_type_vs_secondary_type.effectiveness,
        charged_attack_types.id
    ) matchup
  JOIN pokemon ON pokemon.max_cp = matchup.max_cp
  WHERE
  (
    pokemon.primary_type_id = matchup.primary_type_id AND pokemon.secondary_type_id IS NULL AND matchup.secondary_type_id IS NULL
  ) OR (
    pokemon.primary_type_id = matchup.primary_type_id AND pokemon.secondary_type_id = matchup.secondary_type_id
  ) OR (
    pokemon.primary_type_id = matchup.secondary_type_id AND pokemon.secondary_type_id = matchup.primary_type_id
  )
  ORDER BY score DESC, matchup.max_cp DESC, matchup.number_of_pokemon DESC, matchup.primary_type, matchup.secondary_type;
END
$func$ LANGUAGE plpgsql;

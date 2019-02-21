table! {
    pokemon (id) {
        id -> Int4,
        pokedex_number -> Int4,
        name -> Varchar,
        primary_type_id -> Int4,
        secondary_type_id -> Nullable<Int4>,
        attack -> Int4,
        defense -> Int4,
        stamina -> Int4,
        max_cp -> Int4,
        created_at -> Timestamp,
    }
}

table! {
    pokemon_type_effectivenesses (attacking_type_id, defending_type_id) {
        attacking_type_id -> Int4,
        defending_type_id -> Int4,
        effectiveness -> Numeric,
        created_at -> Timestamp,
    }
}

table! {
    pokemon_types (id) {
        id -> Int4,
        name -> Varchar,
        key -> Varchar,
        created_at -> Timestamp,
    }
}

allow_tables_to_appear_in_same_query!(
    pokemon,
    pokemon_type_effectivenesses,
    pokemon_types,
);

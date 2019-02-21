CREATE TABLE pokemon (
  id SERIAL PRIMARY KEY,
  pokedex_number INTEGER NOT NULL,
  name VARCHAR NOT NULL,
  primary_type_id INTEGER REFERENCES pokemon_types(id) NOT NULL,
  secondary_type_id INTEGER REFERENCES pokemon_types(id),
  attack INTEGER NOT NULL,
  defense INTEGER NOT NULL,
  stamina INTEGER NOT NULL,
  max_cp INTEGER NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

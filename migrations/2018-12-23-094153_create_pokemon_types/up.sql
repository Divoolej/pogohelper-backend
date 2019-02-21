CREATE TABLE pokemon_types (
  id SERIAL PRIMARY KEY,
  name VARCHAR NOT NULL,
  key VARCHAR NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO "pokemon_types"("id", "name", "key") VALUES (1, 'Normal', 'normal');
INSERT INTO "pokemon_types"("id", "name", "key") VALUES (2, 'Fighting', 'fighting');
INSERT INTO "pokemon_types"("id", "name", "key") VALUES (3, 'Flying', 'flying');
INSERT INTO "pokemon_types"("id", "name", "key") VALUES (4, 'Poison', 'poison');
INSERT INTO "pokemon_types"("id", "name", "key") VALUES (5, 'Ground', 'ground');
INSERT INTO "pokemon_types"("id", "name", "key") VALUES (6, 'Rock', 'rock');
INSERT INTO "pokemon_types"("id", "name", "key") VALUES (7, 'Bug', 'bug');
INSERT INTO "pokemon_types"("id", "name", "key") VALUES (8, 'Ghost', 'ghost');
INSERT INTO "pokemon_types"("id", "name", "key") VALUES (9, 'Steel', 'steel');
INSERT INTO "pokemon_types"("id", "name", "key") VALUES (10, 'Fire', 'fire');
INSERT INTO "pokemon_types"("id", "name", "key") VALUES (11, 'Water', 'water');
INSERT INTO "pokemon_types"("id", "name", "key") VALUES (12, 'Grass', 'grass');
INSERT INTO "pokemon_types"("id", "name", "key") VALUES (13, 'Electric', 'electric');
INSERT INTO "pokemon_types"("id", "name", "key") VALUES (14, 'Psychic', 'psychic');
INSERT INTO "pokemon_types"("id", "name", "key") VALUES (15, 'Ice', 'ice');
INSERT INTO "pokemon_types"("id", "name", "key") VALUES (16, 'Dragon', 'dragon');
INSERT INTO "pokemon_types"("id", "name", "key") VALUES (17, 'Dark', 'dark');
INSERT INTO "pokemon_types"("id", "name", "key") VALUES (18, 'Fairy', 'fairy');

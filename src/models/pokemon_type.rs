use chrono::{NaiveDateTime};

#[derive(Clone, Debug, Serialize, Deserialize, PartialEq, Queryable)]
pub struct PokemonType {
  pub id: i32,
  pub name: String,
  pub key: String,
  pub created_at: NaiveDateTime,
}

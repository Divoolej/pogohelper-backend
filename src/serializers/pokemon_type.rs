use diesel::{self, RunQueryDsl};
use actix_web::{error, Error, actix::{Handler, Message}};
use crate::models::pokemon_type::PokemonType;
use crate::db::conn::ConnDsl;

pub struct PokemonTypesSerializer;

#[derive(Deserialize, Serialize, Debug)]
pub struct PokemonTypesSerializerResponse {
  pub data: Vec<PokemonType>,
}

impl Message for PokemonTypesSerializer {
  type Result = Result<PokemonTypesSerializerResponse, Error>;
}

impl Handler<PokemonTypesSerializer> for ConnDsl {
  type Result = Result<PokemonTypesSerializerResponse, Error>;

  fn handle(&mut self, _pokemon_types_serializer: PokemonTypesSerializer, _: &mut Self::Context) -> Self::Result {
    use crate::db::schema::pokemon_types::dsl::*;
    let conn = &self.0.get().map_err(error::ErrorInternalServerError)?;
    let results = pokemon_types.load::<PokemonType>(conn).map_err(error::ErrorInternalServerError)?;
    Ok(PokemonTypesSerializerResponse {
      data: results,
    })
  }
}

use actix_web::{HttpRequest, HttpResponse, AsyncResponder, FutureResponse};
use futures::future::Future;

use crate::shared::state::AppState;
use crate::serializers::pokemon_type::PokemonTypesSerializer;

pub fn index(req: HttpRequest<AppState>) -> FutureResponse<HttpResponse> {
  req.state().db.send(PokemonTypesSerializer)
    .from_err()
    .and_then(|res| {
      match res {
        Ok(pokemon_types) =>
          Ok(HttpResponse::Ok().json(pokemon_types)),
        Err(_) =>
          Ok(HttpResponse::InternalServerError().into()),
      }
    }).responder()
}

pub fn evaluate(req: HttpResponse<AppState>) -> FutureResponse<HttpResponse> {
  req.state().db.send()
}

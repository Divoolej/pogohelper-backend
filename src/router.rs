use actix_web::{App, middleware, http::Method};
use crate::shared::state::AppState;
use crate::db;

use crate::api::pokemon_types;

pub fn app() -> App<AppState> {
  let db_connection = db::conn::init();

  App::with_state(AppState { db: db_connection.clone() })
    .middleware(middleware::Logger::default())
    .prefix("/api")
    .resource("/pokemon_types", |r| { r.method(Method::GET).with(pokemon_types::index); })
}

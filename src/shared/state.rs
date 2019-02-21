use actix_web::actix::Addr;
use crate::db::conn::ConnDsl;

pub struct AppState {
  pub db: Addr<ConnDsl>,
}

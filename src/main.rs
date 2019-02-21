#![allow(proc_macro_derive_resolution_fallback)]

use actix_web::{actix::System, server};

#[macro_use] extern crate diesel;
#[macro_use] extern crate serde_derive;

mod db;
mod shared;
mod api;
mod models;
mod serializers;
mod router;

fn main() {
  ::std::env::set_var("RUST_LOG", "pogohelper=info");
  ::std::env::set_var("RUST_BACKTRACE", "1");
  env_logger::init();

  let sys = System::new("pogohelper");

  server::new(move || vec![router::app().boxed()])
    .bind("localhost:8000")
    .unwrap()
    .shutdown_timeout(2)
    .start();

  sys.run();
}

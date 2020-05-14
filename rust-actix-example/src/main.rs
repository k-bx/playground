use actix_web::{middleware, post, web, App, HttpRequest, HttpServer, Responder};
use serde::{Deserialize, Serialize};
use std::env;

#[post("/api/test1.json")]
async fn test1(req: HttpRequest) -> impl Responder {
    format!("Hello! {:?}", req)
}

#[derive(Debug, Serialize, Deserialize)]
struct Test2Data {
    contents: String,
}

#[post("/api/test2.json")]
async fn test2(test2data: web::Json<Test2Data>) -> impl Responder {
    format!("Hello! {:?}", test2data)
}

#[actix_rt::main]
async fn main() -> std::io::Result<()> {
    env::set_var("RUST_LOG", "actix_web=debug,actix_server=info");
    env_logger::init();

    HttpServer::new(|| {
        App::new()
            // enable logger - always register actix-web Logger middleware last
            .wrap(middleware::Logger::default())
            .service(test1)
            .service(test2)
    })
    .bind("127.0.0.1:8080")?
    .run()
    .await
}

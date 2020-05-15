use actix_web::{middleware, post, web, App, HttpRequest, HttpServer, Responder};
use serde::{Deserialize, Serialize};
use std::env;
// use std::sync::Mutex;
// use tokio::sync::Mutex;
use tokio::sync::RwLock;

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

#[derive(Debug, Serialize, Deserialize)]
struct Test3Req {
    hello: String,
}

#[derive(Debug, Serialize, Deserialize)]
struct Test3Resp {
    world: String,
}

#[post("/api/test3.json")]
async fn test3(inp: web::Json<Test3Req>) -> actix_web::Result<web::Json<Test3Resp>> {
    Ok(web::Json(Test3Resp {
        world: inp.hello.clone(),
    }))
}

#[derive(Debug, Serialize, Deserialize)]
struct Test4Resp {
    world: String,
    counter: u64,
}

#[post("/api/test4.json")]
async fn test4(env: web::Data<Env>) -> web::Json<Test4Resp> {
    let app_name = env.app_name.clone();
    let mut counter = env.counter.write().await;
    *counter += 1;

    web::Json(Test4Resp {
        world: app_name,
        counter: *counter,
    })
}

struct Env {
    app_name: String,
    counter: RwLock<u64>,
}

#[actix_rt::main]
async fn main() -> std::io::Result<()> {
    env::set_var("RUST_LOG", "actix_web=debug,actix_server=info");
    env_logger::init();

    let env = Env {
        app_name: String::from("kon-test"),
        counter: RwLock::new(0),
    };
    let env_data = web::Data::new(env);

    HttpServer::new(move || {
        App::new()
            // enable logger - always register actix-web Logger middleware last
            .wrap(middleware::Logger::default())
            .app_data(env_data.clone())
            // .data(Env {
            //     app_name: String::from("kon-test"),
            //     counter: Mutex::new(0),
            // })
            .service(test1)
            .service(test2)
            .service(test3)
            .service(test4)
    })
    .bind("127.0.0.1:8080")?
    .run()
    .await
}

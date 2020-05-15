use actix_web::{middleware, post, web, App, HttpRequest, HttpServer, Responder};
use serde::{Deserialize, Serialize};
use std::env;
// use std::sync::Mutex;
// use tokio::sync::Mutex;
use async_std::sync::Arc;
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
    counter2: u64,
}

#[post("/api/test4.json")]
async fn test4(env: web::Data<Env>) -> web::Json<Test4Resp> {
    let app_name = env.app_name.clone();
    let mut counter = env.counter.write().await;
    let mut counter2 = env.counter2.write().await;
    *counter += 1;
    *counter2 += 1;

    web::Json(Test4Resp {
        world: app_name,
        counter: *counter,
        counter2: *counter2,
    })
}

struct Env {
    app_name: String,
    counter: Arc<RwLock<u64>>,
    counter2: RwLock<u64>,
}

#[actix_rt::main]
async fn main() -> std::io::Result<()> {
    env::set_var("RUST_LOG", "actix_web=debug,actix_server=info");
    env_logger::init();

    let counter = Arc::new(RwLock::new(0));
    // let env = Env {
    //     app_name: String::from("kon-test"),
    //     counter: ,
    //     counter2: RwLock::new(0),
    // };
    // let env_data = web::Data::new(env);

    HttpServer::new(move || {
        App::new()
            // enable logger - always register actix-web Logger middleware last
            .wrap(middleware::Logger::default())
            // .app_data(env_data.clone())
            .data(Env {
                app_name: String::from("kon-test"),
                counter: counter.clone(),
                counter2: RwLock::new(0),
            })
            .service(test1)
            .service(test2)
            .service(test3)
            .service(test4)
    })
    .bind("127.0.0.1:8080")?
    .run()
    .await
}

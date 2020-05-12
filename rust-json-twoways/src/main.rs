use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize)]
struct User {
    name: String,
}

#[derive(Debug)]
struct AppError {
    kind: String,
    message: String,
}

impl From<std::io::Error> for AppError {
    fn from(error: std::io::Error) -> Self {
        AppError {
            kind: String::from("io"),
            message: error.to_string(),
        }
    }
}

impl From<serde_json::error::Error> for AppError {
    fn from(error: serde_json::error::Error) -> Self {
        AppError {
            kind: String::from("serde_json"),
            message: error.to_string(),
        }
    }
}

fn main() -> Result<(), AppError> {
    let kon = User {
        name: "Kon".to_string(),
    };
    let kon_str = serde_json::to_string(&kon).unwrap();
    println!("Hello, {:?}!", kon);
    println!("Serialized: {:?}!", kon_str);
    println!(
        "Deserialized: {:?}!",
        serde_json::from_str::<User>(&kon_str).unwrap()
    );
    let kon_val = serde_json::from_str(&kon_str)?;
    println!("Deserialized Value kon_val: {:?}!", kon_val);
    let kon_val2 = match kon_val {
        serde_json::Value::Object(map) => {
            let mut map2 = map.clone();
            map2.insert(
                "ext".to_string(),
                serde_json::Value::String("testing".to_string()),
            );
            Ok(serde_json::Value::Object(map2))
        }
        _ => Err(AppError {
            kind: "knd".to_string(),
            message: "msg".to_string(),
        }),
    }?;
    println!("Deserialized Value kon2: {:?}!", kon_val2);
    Ok(())
}

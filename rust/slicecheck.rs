pub fn greeting(name: &str) -> String {
    format!("Hello {}!", name)
}

// fails:
// pub fn greeting2(name: &str) -> &str {
//     &format!("Hello {}!", name)
// }

fn main() {
    // let _s = greeting("Kon");
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn greeting_contains_name() {
        let result = greeting("Carol");
        assert!(result.contains("Carol"));
    }
}

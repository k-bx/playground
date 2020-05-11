use clap::{App, Arg};

#[derive(Debug)]
enum Cmd {
    LaunchMissiles { num: u32 },
}

fn main() {
    let matches = App::new("Testing App")
        .subcommand(
            App::new("launch-missiles")
                .about("launches missiles")
                .arg(Arg::with_name("num").required(true)),
        )
        .setting(clap::AppSettings::ArgRequiredElseHelp)
        .get_matches();
    let cmd: Cmd = if let Some(ref matches) = matches.subcommand_matches("launch-missiles") {
        let num_s = matches.value_of("num").unwrap();
        match num_s.parse::<u32>() {
            Err(_) => {
                eprintln!("num must be an int");
                std::process::exit(1);
            }
            Ok(num) => Cmd::LaunchMissiles { num: num },
        }
    } else {
        panic!("Forgot some subcommand handlers");
    };
    println!("cmd: {:?}", cmd);
}

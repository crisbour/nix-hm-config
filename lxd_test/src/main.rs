use lxd::{Container, Location, Info};
use std::io::stdin;
use anyhow::Result;

fn main() -> Result<()> {
    println!("Wellcome to configuring your container");
    println!("Enter the name of the container");

    let mut container_name = String::new();
    stdin().read_line(&mut container_name)?;

    //TODO: Add config for the container to enable nesting
    let mut container = Container::new(Location::Local, container_name.trim(), "ubuntu:20.04")?;
    //TODO: Privileged or ID translation from host user to container user
    // TODO: Mount Documents
    let mut info = Info::new(Location::Local, &container.name())?;

    println!("Container created is:\n{:?}",info);

    Ok(())
}

extern crate inotify;

use inotify::{Inotify, WatchMask};
use std::process::Command;

fn decode() {
    Command::new("touch")
        .arg("/tmp/hi.txt")
        .status()
        .expect("failed to execute touch");
}

fn main() {
    let mut inotify = Inotify::init().expect("Error while initializing inotify service");

    inotify
        .watches()
        .add("/tmp", WatchMask::CREATE | WatchMask::ATTRIB | WatchMask::MODIFY)
        .expect("Failed to add file watch");

    // Ensure we actually cause a CREATE at least once
    let _ = std::fs::remove_file("/tmp/hi.txt");

    println!("about to create...");
    decode();

    let mut buffer = [0u8; 4096];
    let events = inotify
        .read_events_blocking(&mut buffer)
        .expect("Error while reading events");

    println!("Unblocked");

    for event in events {
        println!("event: {:?}", event.mask);
    }
}

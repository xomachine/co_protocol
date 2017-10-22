# Package

version       = "0.1.0"
author        = "xomachine"
description   = "Protocol headers for Cooperation."
license       = "MIT"
skipDirs      = @["tests"]

# Dependencies

requires "nim >= 0.17.1"
requires "nesm >= 0.2.0"
requires "jser"

task tests, "Run autotests":
  let test_files = listFiles("tests")
  for file in test_files:
    exec("nim c --run -d:debug -o:tmpfile -p:" & thisDir() & " " & file)
    rmfile("tmpfile")


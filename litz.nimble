# Package

version       = "0.1.0"
author        = "zacharycarter"
description   = "Tagged template literal web app lib"
license       = "MIT"
bin           = @["litz.js"]
binDir        = "bin"
installExt    = @["nim"]
srcDir        = "src"
backend       = "js"

# Dependencies

requires "nim >= 0.18.1"
requires "https://github.com/yglukhov/nim-only-uuid.git"


task test, "run litz tests":
  withDir "tests":
    exec "nim js test_hello_world.nim"
    exec "node runner.js"

task dtest, "run litz tests w/ nes debug flag on":
  withDir "tests":
    exec "nim js -d:debugNES test_hello_world.nim"
    exec "node runner.js"
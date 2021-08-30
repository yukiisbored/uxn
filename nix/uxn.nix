{ lib, stdenv, SDL2
, version ? "unknown"
}:

stdenv.mkDerivation {
  inherit version;
  pname = "uxn";

  src = ./..;

  buildInputs = [ SDL2 ];

  buildFlags = lib.concatStringsSep " "
    ["-std=c89" "-Wall" "-Wno-unknown-pragmas"
     "-DNDEBUG" "-Os" "-g0" "-s"];
  core = "src/uxn-fast.c";

  buildPhase = ''
    gcc $buildFlags $(sdl2-config --cflags --libs) \
        $core src/devices/ppu.c src/devices/apu.c src/uxnemu.c \
        -o uxnemu

    gcc $buildFlags src/uxnasm.c -o uxnasm
    gcc $buildFlags $core src/uxncli.c -o uxncli
  '';

  installPhase = ''
    install -D -m 755 uxnasm $out/bin/uxnasm
    install -D -m 755 uxnemu $out/bin/uxnemu
    install -D -m 755 uxncli $out/bin/uxncli
  '';

  meta = {
    description = "An assembler and emulator for the Uxn stack-machine";
    license = lib.licenses.mit;
    homepage = "https://100r.co/site/uxn.html";
  };
}

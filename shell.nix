{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  name = "fastfetch";
  buildInputs = [
    pkgs.fastfetch
  ];
  shellHook = ''
    fastfetch
    exit
  '';
}

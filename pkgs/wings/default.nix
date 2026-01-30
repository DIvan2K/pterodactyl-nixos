{ lib, stdenv, buildGoModule, fetchFromGitHub }:

let
  version = "1.12.1";
in
buildGoModule rec {
  pname = "pterodactyl-wings";
  inherit version;

  src = fetchFromGitHub {
    owner = "pterodactyl";
    repo = "wings";
    rev = "v${version}";
    sha256 = "sha256-VfUGm7uJwEo6Xl274KL3SsSOct4kix230gIF2QNdviE=";
  };

  vendorHash = "sha256-BtATik0egFk73SNhawbGnbuzjoZioGFWeA4gZOaofTI=";

  # CGO отключаем через buildFlags
  buildFlags = ["CGO_ENABLED=0"];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/pterodactyl/wings/system.Version=${version}"
  ];

  subPackages = [ "." ];

  meta = with lib; {
    description = "Daemon for Pterodactyl panel to manage servers";
    homepage = "https://pterodactyl.io";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}

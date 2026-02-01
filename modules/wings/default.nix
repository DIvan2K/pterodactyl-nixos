{ config, lib, pkgs, ... }:

let
  cfg = config.services.wings;
  wings = cfg.package or pkgs.wings;
in
{
  options.services.wings = {
    enable = lib.mkEnableOption "Enable Pterodactyl Wings";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.wings;
      defaultText = "pkgs.wings";
      description = "Package to use for Wings daemon";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker.enable = true;

    systemd.services.pterodactyl-wings = {
      description = "Pterodactyl Wings";
      after = [ "docker.service" ];
      requires = [ "docker.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${wings}/bin/wings --config /etc/pterodactyl/config.yml";
        Restart = "on-failure";
        RestartSec = 5;

        User = "root";
        Group = "root";

        BindPaths = [ "/var/run/docker.sock" ];
        LimitNOFILE = 1048576;
      };
    };
  };
}

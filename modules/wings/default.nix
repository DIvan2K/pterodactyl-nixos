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
      default = null;
      description = "Package to use for Wings daemon";
    };
    configFile = lib.mkOption {
      type = lib.types.path;
      default = "/etc/pterodactyl/config.yml";
      description = "Path to Wings configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker.enable = true;

    systemd.services.wings = {
      description = "Pterodactyl Wings";
      after = [ "docker.service" ];
      requires = [ "docker.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${wings}/bin/wings --config ${cfg.configFile}";
        Restart = "on-failure";
        RestartSec = 5;
        DynamicUser = true;
        StateDirectory = "wings";
        BindPaths = [ "/var/run/docker.sock" ];
        LimitNOFILE = 1048576;
      };
    };
  };
}

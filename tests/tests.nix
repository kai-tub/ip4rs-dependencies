{ config, pkgs, ... }:

let
  lib = pkgs.lib;
in
{
  dockerUnitTest = pkgs.nixosTest
    ({
      name = "docker-test";
      nodes = {
        host = { config, pkgs, ... }: {
          virtualisation.graphics = false;
          virtualisation.docker.enable = true;
        };
      };
      skipLint = true;
      testScript = ''
        start_all()
        print("booting")
        host.wait_for_unit("multi-user.target")
        host.succeed("docker pull --platform=linux/amd64 ghcr.io/kai-tub/ip4rs-dependencies")
        host.console_interact()
      '';

    });
}

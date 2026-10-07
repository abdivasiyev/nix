{den, ...}: {
  den.aspects.development.k8s = {
    includes = [
      den.aspects.overlays.kubectl-readonly
    ];

    darwin.homebrew.casks = ["lens"];
    darwin.system.defaults.dock.persistent-apps = [
      "/Applications/Lens.app"
    ];

    homeManager = {
      pkgs,
      config,
      ...
    }: {
      sops = {
        secrets = {
          kubeconfig = {
            path = "${config.home.homeDirectory}/.kube/config";
            mode = "0400";
          };
          awsConfig = {
            path = "${config.home.homeDirectory}/.aws/config";
            mode = "0400";
          };
          awsCredentials = {
            path = "${config.home.homeDirectory}/.aws/credentials";
            mode = "0400";
          };
        };
      };

      home.packages = with pkgs; [
        awscli2
        kubectl
        (pkgs.werf.overrideAttrs (oldAttrs: {
          doCheck = false;
        }))
      ];
    };
  };
}

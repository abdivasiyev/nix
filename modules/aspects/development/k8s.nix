{den, ...}: {
  den.aspects.development.k8s = {home, ...}: {
    includes = [
      den.aspects.overlays.kubectl-readonly
    ];

    darwin.homebrew.casks = ["lens"];
    os = {
      pkgs,
      config,
      ...
    }: {
      sops = {
        secrets = {
          kubeconfig = {
            path = "${home}/.kube/config";
            mode = "0400";
          };
          awsConfig = {
            path = "${home}/.aws/config";
            mode = "0400";
          };
          awsCredentials = {
            path = "${home}/.aws/credentials";
            mode = "0400";
          };
        };
      };

      environment.systemPackages = with pkgs; [
        awscli2
        kubectl
        werf
      ];
    };
  };
}

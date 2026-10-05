{
  den.aspects.development.k8s = {
    darwin.homebrew.casks = ["lens"];
    os = {
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

      environment.systemPackages = with pkgs; [
        awscli2
        kubectl
        werf
      ];
    };
  };
}

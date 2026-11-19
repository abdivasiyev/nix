{
  # Local code completion: llama.cpp serving Qwen2.5-Coder 3B for
  # fill-in-the-middle on 127.0.0.1:8012.  The Emacs aspect points minuet at it
  # when this agent is enabled.  llama-server downloads the weights (~3.3 GB)
  # on first start into ~/.cache/huggingface, not the nix store.
  den.aspects.llm.completion = {
    homeManager = {
      pkgs,
      lib,
      config,
      ...
    }:
      lib.mkIf pkgs.stdenv.isDarwin {
        launchd.agents.llama-completion = {
          enable = true;
          config = {
            ProgramArguments = [
              "${pkgs.llama-cpp}/bin/llama-server"
              "--fim-qwen-3b-default"
              "--host"
              "127.0.0.1"
              "--port"
              "8012"
              # The prompt cache defaults to 8 GiB of RAM; keep it small.
              "--cache-ram"
              "512"
            ];
            RunAtLoad = true;
            KeepAlive = true;
            StandardOutPath = "${config.home.homeDirectory}/Library/Logs/llama-completion.log";
            StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/llama-completion.log";
          };
        };
      };
  };
}

{
  den.aspects.development.wakatime = {
    homeManager = {
      pkgs,
      config,
      ...
    }: {
      sops.secrets.wakatimeApiKey = {};

      # wakatime-cli reads the key from sops at run time.
      home.file.".wakatime.cfg".text = ''
        [settings]
        api_key_vault_cmd = ${pkgs.coreutils}/bin/cat ${config.sops.secrets.wakatimeApiKey.path}
        debug = false
        hidefilenames = false
        ignore =
            COMMIT_EDITMSG$
            PULLREQ_EDITMSG$
            MERGE_MSG$
            TAG_EDITMSG$
      '';
    };
  };
}

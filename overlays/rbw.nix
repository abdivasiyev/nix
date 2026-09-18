(self: super: {
  # Upstream's git-credential-rbw uses a GNU-sed-only construct ("}" on the
  # same line as an s/// flag), which BSD sed on macOS rejects with
  # "bad flag in substitute command: '}'". It also emits the item's URI as
  # the credential "host" field, which isn't a valid host value.
  rbw =
    super.runCommand "rbw-${super.rbw.version}" {
      inherit (super.rbw) meta;
      passthru = super.rbw.passthru or [];
    } ''
      cp -a ${super.rbw} $out
      chmod -R u+w $out
      substituteInPlace $out/bin/git-credential-rbw \
        --replace-fail 's/^/password=/p }' 's/^/password=/p;}' \
        --replace-fail 's/^URI: /host=/p' 's/^URI: //'
    '';
})

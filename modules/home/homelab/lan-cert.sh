# homelab-lan-cert: the client certificate your devices show the homelab at
# home, for apps that are behind Cloudflare Access elsewhere.
#
# Makes, once, a small CA (kept in this repo's sops secrets, so more devices
# can get certificates later), and a client certificate signed by it:
#
#   secrets/secrets.yaml  homelabLanCaKey, homelabLanCaCert   (the CA)
#                         homelabLanClientP12                 (base64 PKCS#12)
#   homelab repo          lan/client-ca.pem                   (what Caddy trusts)
#
# Nothing secret is printed or left on disk. Run it again to issue a fresh
# client certificate from the same CA (e.g. after one leaked; then also
# remove the old one from the keychain).

NIX=$HOME/Development/git.azizovich.uz/abdivasiyev/worktrees/nix/master
HOMELAB=$HOME/Development/git.azizovich.uz/abdivasiyev/worktrees/homelab/master
SECRETS=$NIX/secrets/secrets.yaml
export SOPS_AGE_KEY_FILE=${SOPS_AGE_KEY_FILE:-$HOME/.config/sops/age/keys.txt}

[ -f "$SECRETS" ] || { echo "no $SECRETS" >&2; exit 1; }
[ -d "$HOMELAB" ] || { echo "no homelab repo at $HOMELAB" >&2; exit 1; }

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
umask 077
cd "$work"

has() { grep -q "^$1:" "$SECRETS"; }
put() { sops set --value-stdin "$SECRETS" "[\"$1\"]"; } # value (JSON) on stdin
json() { jq -Rs . < "$1"; }

if has homelabLanCaKey; then
  echo "using the existing CA"
  sops decrypt --extract '["homelabLanCaKey"]' "$SECRETS" > ca.key
  sops decrypt --extract '["homelabLanCaCert"]' "$SECRETS" > ca.pem
else
  echo "creating the CA"
  openssl req -x509 -newkey ec -pkeyopt ec_paramgen_curve:P-256 -nodes \
    -keyout ca.key -out ca.pem -days 3650 -subj "/CN=homelab client CA" \
    -addext "basicConstraints=critical,CA:TRUE" -addext "keyUsage=critical,keyCertSign,cRLSign" 2>/dev/null
  json ca.key | put homelabLanCaKey
  json ca.pem | put homelabLanCaCert
fi

echo "issuing the client certificate"
openssl req -newkey ec -pkeyopt ec_paramgen_curve:P-256 -nodes \
  -keyout client.key -out client.csr -subj "/CN=homelab client" 2>/dev/null
printf 'basicConstraints=CA:FALSE\nkeyUsage=critical,digitalSignature\nextendedKeyUsage=clientAuth\n' > ext
openssl x509 -req -in client.csr -CA ca.pem -CAkey ca.key -CAcreateserial \
  -days 1825 -extfile ext -out client.pem 2>/dev/null
# -legacy: macOS's keychain cannot read the newer PKCS#12 encryption.
openssl pkcs12 -export -legacy -inkey client.key -in client.pem -certfile ca.pem \
  -name "homelab client" -passout pass:homelab -out client.p12
base64 < client.p12 | tr -d '\n' > client.b64
json client.b64 | put homelabLanClientP12

install -d "$HOMELAB/lan"
cp ca.pem "$HOMELAB/lan/client-ca.pem"
chmod 0644 "$HOMELAB/lan/client-ca.pem"

cat <<EOF

Done. Next:
  1. homelab repo: commit lan/client-ca.pem, then deploy (just deploy) and push
  2. nix repo: commit secrets/secrets.yaml, then switch each Mac
     (the certificate lands in the login keychain as "homelab client")
EOF

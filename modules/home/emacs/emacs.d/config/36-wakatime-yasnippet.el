;; ---------------------------------------------------------------------------
;; Time tracking and snippets
;; ---------------------------------------------------------------------------

(require 'wakatime-mode)
(when (boundp 'my/nix-wakatime-cli)
  (setq wakatime-cli-path my/nix-wakatime-cli))
(global-wakatime-mode 1)

(require 'yasnippet)
(yas-global-mode 1)
(yas-reload-all)

;; Loading `yasnippet-snippets' registers the snippets installed by Nix.
(require 'yasnippet-snippets)


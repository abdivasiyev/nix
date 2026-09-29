;; ---------------------------------------------------------------------------
;; Eglot / Flymake
;; ---------------------------------------------------------------------------

(require 'eglot)

(setq eglot-autoshutdown t
      eglot-events-buffer-config '(:size 0 :format full))

;; Eglot documents `eglot-workspace-configuration' as a directory-local
;; variable.  `setq-default' gives every project these defaults while still
;; allowing a project-specific .dir-locals.el to override them.
(setq-default eglot-workspace-configuration
              '(:gopls
                (:analyses
                 (:unusedparams t
                  :unusedwrite t
                  :nilness t
                  :shadow t
                  :unusedvariable t))
                :haskell
                (:formattingProvider "fourmolu"
                 :plugin (:fourmolu (:config (:external t))))
                :nil
                (:formatting (:command ["alejandra"]))))

;; These entries are explicit so the choice of server is deterministic even if
;; Eglot learns additional alternatives in a future Emacs release.
(add-to-list 'eglot-server-programs '(nix-mode . ("nil")))
(add-to-list 'eglot-server-programs
             '(((haskell-mode :language-id "haskell")
                (haskell-literate-mode :language-id "haskell")
                (haskell-cabal-mode :language-id "cabal"))
               . ("haskell-language-server-wrapper" "--lsp")))
(add-to-list 'eglot-server-programs '(yaml-ts-mode . ("yaml-language-server" "--stdio")))
(add-to-list 'eglot-server-programs '(json-ts-mode . ("vscode-json-language-server" "--stdio")))
(add-to-list 'eglot-server-programs '(dockerfile-ts-mode . ("docker-langserver" "--stdio")))
(add-to-list 'eglot-server-programs '((c-mode c-ts-mode c++-mode c++-ts-mode) . ("clangd")))

(defun my/eglot-format-before-save ()
  "Format the current buffer before saving when Eglot manages it."
  (when (eglot-managed-p)
    (condition-case nil
        (eglot-format-buffer)
      (error nil))))

(defun my/eglot-organize-imports-before-save ()
  "Ask the active language server to organize imports before saving."
  (when (eglot-managed-p)
    (condition-case nil
        (eglot-code-action-organize-imports)
      (error nil))))

(defun my/eglot-managed-setup ()
  "Install buffer-local save actions for Eglot-managed buffers."
  ;; add-hook prepends by default, so organize-imports runs before formatting.
  (add-hook 'before-save-hook #'my/eglot-format-before-save nil t)
  (add-hook 'before-save-hook #'my/eglot-organize-imports-before-save nil t))

(add-hook 'eglot-managed-mode-hook #'my/eglot-managed-setup)

;; Keep the familiar C-c l namespace, now backed by Eglot.
(define-key eglot-mode-map (kbd "C-c l a") #'eglot-code-actions)
(define-key eglot-mode-map (kbd "C-c l r") #'eglot-rename)
(define-key eglot-mode-map (kbd "C-c l f") #'eglot-format-buffer)
(define-key eglot-mode-map (kbd "C-c l o") #'eglot-code-action-organize-imports)
(define-key eglot-mode-map (kbd "C-c l h") #'eldoc-doc-buffer)
(define-key eglot-mode-map (kbd "C-c l R") #'eglot-reconnect)
(define-key eglot-mode-map (kbd "C-c l q") #'eglot-shutdown)
(define-key eglot-mode-map (kbd "C-c l g i") #'eglot-find-implementation)

;; Eglot uses Flymake for diagnostics. Enabling it in programming buffers also
;; preserves diagnostics from any non-Eglot Flymake backend.
(add-hook 'prog-mode-hook #'flymake-mode)

;; Dape provides Debug Adapter Protocol support independently of Eglot.
(autoload 'dape "dape" nil t)
(global-set-key (kbd "C-c d") #'dape)


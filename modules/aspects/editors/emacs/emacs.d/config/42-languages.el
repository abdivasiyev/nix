;; ---------------------------------------------------------------------------
;; Languages
;; ---------------------------------------------------------------------------

;; golangci flymake
(require 'flymake-golangci)
(setq flymake-golangci-container nil)

(add-to-list 'auto-mode-alist '("\\.el\\'" . emacs-lisp-mode))

(autoload 'go-mode "go-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))
(add-hook 'go-mode-hook #'eglot-ensure)
(add-hook 'go-mode-hook #'flymake-golangci-enable)

(autoload 'nix-mode "nix-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode))
(add-hook 'nix-mode-hook #'eglot-ensure)

(autoload 'haskell-mode "haskell-mode" nil t)
(autoload 'haskell-literate-mode "haskell-mode" nil t)
(autoload 'haskell-cabal-mode "haskell-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.hs\\'" . haskell-mode))
(add-to-list 'auto-mode-alist '("\\.lhs\\'" . haskell-literate-mode))
(add-to-list 'auto-mode-alist '("\\.cabal\\'" . haskell-cabal-mode))
(add-hook 'haskell-mode-hook #'eglot-ensure)
(add-hook 'haskell-literate-mode-hook #'eglot-ensure)
(add-hook 'haskell-cabal-mode-hook #'eglot-ensure)

(add-to-list 'auto-mode-alist '("\\.ya?ml\\'" . yaml-ts-mode))
(add-hook 'yaml-ts-mode-hook #'eglot-ensure)

(add-to-list 'auto-mode-alist '("\\.json\\'" . json-ts-mode))
(add-hook 'json-ts-mode-hook #'eglot-ensure)

(add-to-list 'auto-mode-alist '("\\(?:^\\|/\\)Dockerfile\\(?:\\..*\\)?\\'" . dockerfile-ts-mode))
(add-hook 'dockerfile-ts-mode-hook #'eglot-ensure)

(autoload 'gfm-mode "markdown-mode" nil t)
(autoload 'markdown-mode "markdown-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.md\\'" . gfm-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(setq markdown-command "pandoc"
      markdown-fontify-code-blocks-natively t)

(add-to-list 'auto-mode-alist '("\\.c\\'" . c-mode))
(add-to-list 'auto-mode-alist '("\\.cpp\\'" . c++-mode))
(add-hook 'c-mode-hook #'eglot-ensure)
(add-hook 'c++-mode-hook #'eglot-ensure)


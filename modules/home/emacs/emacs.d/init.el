;; init.el --- Emacs configuration file -*- lexical-binding: t; -*-
;;; Commentary:
;; This is the main Emacs configuration file.
;;; Code:

;; extend package archives
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; enable use package
(eval-when-compile
  (require 'use-package))

(setq use-package-always-defer t
      use-package-always-ensure t)

(use-package emacs
  :init
  ;; mappings for darwin
  (when (eq system-type 'darwin)
    (setq mac-command-modifier 'super
          mac-option-modifier 'meta
          mac-control-modifier 'control))
  ;; default values for global variables
  (setq-default show-trailing-whitespace t
                indent-tabs-mode nil
                global-auto-revert-non-file-buffer t ;; auto update non file buffers
                whitespace-style '(face tabs trailing tab-mark spaces space-mark)
                ;; scroll defaults
                scroll-margin 8
                scroll-conservatively 101
                scroll-preserve-screen-position t
                auto-window-vscroll nil
                ;; fill column
                fill-column 120)
  ;; global emacs variables
  (setq initial-scratch-message nil
        confirm-kill-emacs 'yes-or-no-p
        tab-width 2
        ;; backup directory
        backup-directory-alist `(("." . ,"~/.config/emacs/backups"))
        ;; auto-save directory
        auto-save-file-name-transforms `((".*" ,"~/.config/emacs/auto-saves" t))
        ;; tramp
        tramp-auto-save-directory "/tmp"
        display-line-numbers-type t
        display-line-numbers-width-start t
        ;; deleting files into trash
        delete-by-moving-to-trash t
        ;; auto save session timeout
        desktop-auto-save-timeout 3)
  ;; aliases
  (defalias 'yes-or-no-p 'y-or-n-p)
  ;; hooks
  (add-hook 'prog-mode-hook 'whitespace-mode)
  (add-hook 'prog-mode-hook 'display-line-numbers-mode)
  (add-hook 'prog-mode-hook 'global-display-fill-column-indicator-mode)
  (add-hook 'before-save-hook 'whitespace-cleanup)
  (global-auto-revert-mode t)
  (desktop-save-mode 1)
  (global-hl-line-mode 1)
  ;; set font
  (set-face-attribute 'default nil
                      :font "JetBrainsMono Nerd Font"
                      :height 160)
  (set-face-attribute 'fill-column-indicator nil
                      :foreground "#717C7C"
                      :background "transparent"))

;; move lines up and down
(use-package move-text
  :bind
  (("M-p" . move-text-up)
   ("M-n" . move-text-down)))

;; load the nerds' theme
(use-package gruber-darker-theme)

(load-theme 'gruber-darker t)

;; ido mode
(use-package ido-completing-read+
  :init
  (ido-mode 1)
  (ido-everywhere 1)
  (ido-ubiquitous-mode 1))

;; better M-x
(use-package smex
  :bind
  (("M-x" . smex)
   ("C-c C-c M-x" . execute-extended-command)))

;; auto-close parens for lispish languages
(use-package paredit
  :init
  (add-hook 'emacs-lisp-mode-hook 'paredit-mode))

;; multiline editing
(use-package multiple-cursors
  :bind
  (("s->" . 'mc/mark-next-like-this)
   ("s-<" . 'mc/mark-previous-like-this)
   ("C-s-l" . 'mc/mark-all-like-this)))

;; Magit(c) - magic of the Git
(use-package magit
  :init
  (setq magit-auto-revert-mode t)
  :bind
  (("C-x g" . magit)))

;; Highlight differences on buffer
(use-package diff-hl
  :init
  (add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  (add-hook 'dired-mode-hook 'diff-hl-dired-mode)
  (global-diff-hl-mode)
  (diff-hl-flydiff-mode))

(use-package difftastic-bindings
  :ensure difftastic
  :config
  (difftastic-bindings-mode))

;; magically undo changes
(use-package vundo
  :custom
  (setq vundo-compact-display t
        vundo-glyph-alist vundo-unicode-symbols
        undo-limit (* 80 1024 1024)
        undo-strong-limit (* 120 1024 1024)
        undo-outer-limit (* 360 1024 1024))
  :init
  (add-hook 'prog-mode-hook 'vundo-popup-mode)
  :bind
  (("C-M-/" . 'vundo)))

;; load .envrc
(use-package envrc
  :init
  (add-hook 'after-init-hook 'envrc-global-mode)
  :bind
  (("C-c r" . 'envrc-reload)))

;; inherit environment into temporary buffers also when envrc loads them up
(use-package inheritenv)

;; show git info on dired
(use-package dired-git-info
  :config
  (setq dgi-auto-hide-details-p nil)
  (add-hook 'dired-after-readin-hook 'dired-git-info-auto-enable))

;; enable dired-extra
(use-package dired-x
  :ensure nil
  :config
  (setq dired-omit-files
        (concat dired-omit-files "\\|^\\..+$")
        dired-listing-switches "-lah")
  (setq-default dired-dwim-target t))

(use-package dired-toggle
  :bind (("s-p" . #'dired-toggle)
         :map dired-mode-map
         ("q" . #'dired-toggle-quit)
         ([remap dired-find-file] . #'dired-toggle-find-file)
         ([remap dired-up-directory] . #'dired-toggle-up-directory))
  :config
  (setq dired-toggle-window-size 80)
  (setq dired-toggle-window-side 'right)

  ;; Optional, enable =visual-line-mode= for our narrow dired buffer:
  (add-hook 'dired-toggle-mode-hook
            (lambda () (interactive)
              (visual-line-mode 1)
              (setq-local visual-line-fringe-indicators '(nil right-curly-arrow))
              (setq-local word-wrap nil))))

;; I don't know which key does what
(use-package which-key
  :init
  (setq which-key-idle-delay 0.5)
  (which-key-mode))

;; organizing projects
(use-package project
  :ensure nil)

;; featured dashboard
(use-package nerd-icons)
(use-package dashboard
  :init
  (setq initial-buffer-choice 'dashboard-open)
  :config
  (setq dashboard-startup-banner 'official
        dashboard-items '((recents  . 10)
                          (projects . 10))
        dashboard-banner-logo-title ""
        dashboard-startup-banner 1
        dashboard-center-content t
        dashboard-vertically-center-content t
        dashboard-display-icons-p t
        dashboard-icon-type 'nerd-icons
        dashboard-set-heading-icons t
        dashboard-set-file-icons t)
  (dashboard-setup-startup-hook))

;; tracking coding time
(use-package wakatime-mode
  :ensure t
  :init
  (global-wakatime-mode))

;; dev tools for real engineers
(use-package yasnippet
  :init
  (yas-global-mode)
  (yas-reload-all))

(use-package yasnippet-snippets
  :after 'yasnippet)

(use-package company
  :init
  (add-hook 'after-init-hook 'global-company-mode))

;; a real devil
(use-package lsp-mode
  :commands lsp lsp-deferred
  :init
  (setq lsp-prefer-flymake nil
        lsp-completion-provider :capf
        lsp-keymap-prefix "C-c l"
        lsp-eldoc-render-all t)
  (defun lsp/auto-format-on-save ()
    (add-hook 'before-save-hook #'lsp-format-buffer nil t))

  (defun lsp/organize-imports-on-save ()
    (add-hook 'before-save-hook #'lsp-organize-imports nil t))
  (add-hook 'lsp-mode-hook #'lsp/auto-format-on-save)
  (add-hook 'lsp-mode-hook #'lsp/organize-imports-on-save))

(use-package dap-mode
  :after lsp-mode
  :init
  (dap-mode 1)
  (dap-ui-mode 1)
  (dap-ui-controls-mode 1)
  (setq dap-print-io t)
  (add-hook 'dap-stopped-hook (lambda (arg) (call-interactively #'dap-hydra))))

(use-package flycheck
  :init
  (global-flycheck-mode t))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-show-with-cursor nil)
  (lsp-ui-doc-show-with-mouse t)
  (lsp-ui-sideline-show-diagnostics t)
  (lsp-ui-sideline-show-code-actions t))

;; Enable native emacs-lisp-mode
(use-package emacs-lisp-mode
  :ensure nil
  :mode "\\.el\\'")

(use-package go-mode
  :hook (go-mode . lsp-deferred)
  :mode "\\.go\\'"
  :config
  (require 'dap-dlv-go)
  (setq lsp-gopls-analyses
        '((unusedparams . t)
          (unusedwrite . t)
          (nilness . t)
          (shadow . t)
          (unusedvariable . t))))

(use-package nix-mode
  :hook (nix-mode . lsp-deferred)
  :mode "\\.nix\\'")

;; haskell mode for .hs, .lhs files
(use-package haskell-mode
  :ensure t
  :hook (haskell-mode . lsp-deferred)
  :hook (literate-haskell-mode . lsp-deferred)
  :mode ("\\.hs\\'" . haskell-mode)
        ("\\.lhs\\'" . literate-haskell-mode))

(use-package lsp-haskell
  :after lsp-mode
  :config
  (setq lsp-haskell-server-path "haskell-language-server-wrapper"
        lsp-haskell-server-args nil
        lsp-haskell-formatting-provider "fourmolu")) ;; or "brittany"/"ormolu"

;; yaml mode for .yml, .yaml files
(use-package yaml-mode
  :hook (yaml-mode . lsp-deferred))

;; json mode for .json files
(use-package json-mode
  :hook (json-mode . lsp-deferred)
  :mode "\\.json\\'")

;; dockerfile mode for Dockerfile files
(use-package dockerfile-mode
  :hook (dockerfile-mode . lsp-deferred)
  :mode "Dockerfile\\'")

;; docker-compose mode
(use-package docker-compose-mode
  :hook (docker-compose-mode . lsp-deferred))

;; markdown mode for .md files
(use-package markdown-mode
  :ensure t
  :mode (("\\.md\\'" . gfm-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init
  (setq markdown-command "pandoc")
  :config
  (setq markdown-fontify-code-blocks-natively t))

;; hacker mode
(use-package vterm
  :init
  (setq vterm-max-scrollback 1000000)
  (add-hook 'vterm-mode-hook (lambda ()
                               (display-fill-column-indicator-mode -1)
                               (setq show-trailing-whitespace nil)))
  :custom
  (setq vterm-module-cmake-args "-DUSE_SYSTEM_LIBVTERM=yes"))

(use-package vterm-toggle
  :init
  (setq vterm-toggle-scope 'project)
  :bind
  (("C-c t" . #'vterm-toggle)))

;; highlight todos
(use-package hl-todo
  :init
  (setq hl-todo-keyword-faces
      '(("TODO" . (:inherit warning :inverse-video t))
        ("WARNING" . (:inherit warning :inverse-video t))
        ("FIXME" . (:inherit error :inverse-video t))
        ("HACK" . (:inherit font-lock-constant-face :inverse-video t))
        ("NOTE" . (:inherit success :inverse-video t))))
  (add-hook 'prog-mode-hook 'hl-todo-mode))

(provide 'init)
;;; init.el ends here

;; init.el --- Emacs configuration file -*- lexical-binding: t; -*-
;;; Commentary:
;; This is the main Emacs configuration file.
;;; Code:
;; Disable GUI elements
(tool-bar-mode 0)
(scroll-bar-mode 0)
(setq inhibit-splash-screen t)
(setq use-file-dialog nil)
(setq ring-bell-function 'ignore)
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(defvar bootstrap-version)
(let ((bootstrap-file
    (expand-file-name
      "straight/repos/straight.el/bootstrap.el"
      (or (bound-and-true-p straight-base-dir)
        user-emacs-directory)))
    (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
       'silent 'inhibit-cookies)
    (goto-char (point-max))
    (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Use use-package for package management
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)
(setq use-package-always-defer t)

(use-package emacs
  :init
  (setq initial-scratch-message nil)
  (setq confirm-kill-emacs 'yes-or-no-p)

  (defun display-startup-echo-area-message ()
    (message "")))

(use-package emacs
  :init
  (defalias 'yes-or-no-p 'y-or-n-p))

(use-package emacs
  :init
  (set-charset-priority 'unicode)
  (setq locale-coding-system 'utf-8
        coding-system-for-read 'utf-8
        coding-system-for-write 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (set-selection-coding-system 'utf-8)
  (prefer-coding-system 'utf-8)
  (setq default-process-coding-system '(utf-8-unix . utf-8-unix)))

(use-package emacs
  :init
  (setq-default indent-tabs-mode nil)
  (setq-default tab-width 2)
  (global-auto-revert-mode 1))

(use-package emacs
  :init
	(when (eq system-type 'darwin)
		(setq mac-command-modifier 'super)
		(setq mac-option-modifier 'meta)
		(setq mac-control-modifier 'control)))

(use-package emacs
  :init
  (set-face-attribute 'default nil
    :font "JetBrainsMono Nerd Font"
    :height 160))

(use-package emacs
  :config
  (setq backup-directory-alist `(("." . ,"~/.emacs.d/backups")))
  (setq auto-save-file-name-transforms `((".*" ,"~/.emacs.d/auto-saves" t))))

;; Gruvbox theme
(use-package gruvbox-theme
  :ensure t)

(use-package doom-themes
  :ensure t
  :config
  (doom-themes-org-config)
  (doom-themes-treemacs-config))

;; Auto switch between dark and light mode
(setq custom-safe-themes t) ; Trust all themes
(use-package auto-dark
  :ensure t
  :custom
  (auto-dark-themes '((doom-gruvbox) (doom-bluloco-light)))
  (auto-dark-polling-interval-seconds 2)
  (auto-dark-allow-osascript t)
  :init (auto-dark-mode))

(use-package emacs
  :init
  (defun ab/enable-line-numbers ()
    "Enable relative line numbers"
    (interactive)
    (display-line-numbers-mode)
    (setq display-line-numbers 'relative))
  (add-hook 'prog-mode-hook #'ab/enable-line-numbers))

(use-package emacs
  :init
  (setq-default fill-column 120)
  (set-face-attribute 'fill-column-indicator nil
                      :foreground "#717C7C" ; katana-gray
                      :background "transparent")
  (global-display-fill-column-indicator-mode 1))

(use-package doom-modeline
  :ensure t
  :init
  (doom-modeline-mode 1)
  (column-number-mode 1)
  :config
  (setq doom-modeline-height 18)
  (setq doom-modeline-total-line-number t))

(use-package nerd-icons)

(use-package which-key
  :demand
  :init
  (setq which-key-idle-delay 0.5) ; Open after .5s instead of 1s
  :config
  (which-key-mode))

;; MiniBuffer
(use-package ido-completing-read+
  :config
  (ido-mode 1)
  (ido-everywhere 1)
  (ido-ubiquitous-mode 1))

(use-package smex
  :config
  (global-set-key (kbd "M-x") 'smex)
  (global-set-key (kbd "C-c C-c M-x") 'execute-extended-command))

;; Multiline editing
(use-package multiple-cursors)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; Magic of magit
(use-package magit
  :ensure t
  :config
  (setq magit-auto-revert-mode nil))

(global-set-key (kbd "C-c m s") 'magit-status)
(global-set-key (kbd "C-c m l") 'magit-log)

;; Diff highlight
(use-package diff-hl
  :demand t
  :init
  (add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  :config
  (global-diff-hl-mode))

;; Magic of environment
(use-package direnv
  :ensure t
  :config
  (direnv-mode)
  :bind-keymap
  ("C-c r" . direnv-update-environment))

;; Project files
(use-package treemacs
  :ensure t
  :defer t
  :init
  (setq treemacs-is-never-other-window t)
  :config
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-git-commit-diff-mode t)
  (treemacs-project-follow-mode t)
  (treemacs-icons-dired-mode t)
  :bind
  ("s-P" . treemacs))

(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :config
  (setq projectile-completion-system 'default
        projectile-enable-caching t
        projectile-indexing-method 'alien
        projectile-project-search-path '("~/Development/"))
  :bind-keymap
  ("C-c p" . projectile-command-map))

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :ensure t)

(use-package treemacs-magit
    :after (treemacs magit)
    :ensure t)

(use-package dashboard
  :ensure t
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
        dashboard-set-file-icons t
        dashboard-projects-backend 'projectile)
  (dashboard-setup-startup-hook))

;; disable autosave for tramp buffers
(setq tramp-auto-save-directory "/tmp")

;; yasnippet
(use-package yasnippet
  :init
  (yas-global-mode 1)
  :config
  (setq yas/triggers-in-field nil)
  (setq yas-snippet-dirs '("~/.emacs.d/snippets/")))

;; company mode
(use-package company
  :init
  (add-hook 'after-init-hook 'global-company-mode))

;; auto format hook
(defun my/lsp-auto-format-on-save ()
  (add-hook 'before-save-hook #'lsp-format-buffer nil t))

;; auto import hook
(defun my/lsp-auto-import-on-save ()
  (add-hook 'before-save-hook #'lsp-organize-imports nil t))

;; lsp mode
(use-package lsp-mode
  :commands lsp lsp-deferred
  :init
  (setq lsp-prefer-flymake nil
        lsp-completion-provider :capf
        lsp-keymap-prefix "C-c l"
        lsp-eldoc-render-all t)
  (add-hook 'lsp-mode-hook #'my/lsp-auto-format-on-save)
  (add-hook 'lsp-mode-hook #'my/lsp-auto-import-on-save))

(use-package flycheck
  :init (global-flycheck-mode))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-show-with-cursor nil)
  (lsp-ui-doc-show-with-mouse t)
  (lsp-ui-sideline-show-diagnostics t)
  (lsp-ui-sideline-show-code-actions t))

(use-package lsp-treemacs
  :after lsp)

(use-package go-mode
  :hook (go-mode . lsp-deferred)
  :mode "\\.go\\'"
  :config
  (setq lsp-gopls-analyses
      '((unusedparams . t)
        (unusedwrite . t)
        (nilness . t)
        (shadow . t)
        (unusedvariable . t))))

(use-package nix-mode
  :hook (nix-mode . lsp-deferred)
  :mode "\\.nix\\'")

(use-package copilot
  :ensure t
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . copilot-accept-completion)
              ("C-<tab>" . copilot-accept-completion-by-word)
              ("C-c C-c" . copilot-accept-completion)))
(setq copilot-disable-predicates '(company--active-p))
;; disable copilot warnings
(setq copilot-indent-offset-warning-disabled t)
(setq copilot-indent-offset-warning-disable t)

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

;; end of LSP configurations

;; Open a term buffer in a given shell
(defun my/open-term ()
  "Open a terminal in the current project or default directory."
  (interactive)
  (let ((default-directory
          (if-let ((proj (project-current)))
              (project-root proj)
            default-directory)))
    (term (getenv "SHELL"))))  ; uses default shell

(global-set-key (kbd "C-c t") #'my/open-term)

(provide 'init)
;;; init.el ends here

(tool-bar-mode 0)
(scroll-bar-mode 0)
(setq inhibit-splash-screen t)
(setq use-file-dialog nil)
(setq ring-bell-function 'ignore)

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

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)
(setq use-package-always-defer t)

;; Load the environment from system
(use-package exec-path-from-shell
  :ensure t
  :init
  (exec-path-from-shell-initialize))

(when (memq window-system '(mac ns x))
  (use-package exec-path-from-shell
    :ensure t
    :init
    (setq exec-path-from-shell-arguments '("-l"))
    :config
    (exec-path-from-shell-initialize)))

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

;; Gruvbox theme
(use-package gruvbox-theme
  :demand
  :config
  (load-theme 'gruvbox-dark-medium t))

(use-package emacs
  :init
  (defun ab/enable-line-numbers ()
    "Enable relative line numbers"
    (interactive)
    (display-line-numbers-mode)
    (setq display-line-numbers 'relative))
  (add-hook 'prog-mode-hook #'ab/enable-line-numbers))

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

;; Magic of magit
(use-package magit
  :ensure t
  :config
  (setq magit-auto-revert-mode nil))

(global-set-key (kbd "C-c m s") 'magit-status)
(global-set-key (kbd "C-c m l") 'magit-log)

;; Magic of environment
(use-package envrc
  :init
  (envrc-global-mode))

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
        lsp-completion-provider :capf)
  (add-hook 'lsp-mode-hook #'my/lsp-auto-format-on-save)
  (add-hook 'lsp-mode-hook #'my/lsp-auto-import-on-save))

(use-package flycheck
  :init (global-flycheck-mode))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode))

(use-package go-mode
  :hook (go-mode . lsp-deferred))

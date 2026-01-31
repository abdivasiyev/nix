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
        display-line-numbers-type t
        display-line-numbers-width-start t)
  ;; aliases
  (defalias 'yes-or-no-p 'y-or-n-p)
  ;; hooks
  (add-hook 'prog-mode-hook 'whitespace-mode)
  (add-hook 'prog-mode-hook 'display-line-numbers-mode)
  (add-hook 'prog-mode-hook 'global-display-fill-column-indicator-mode)
  (add-hook 'before-save-hook 'whitespace-cleanup)
  (global-auto-revert-mode t)
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

(provide 'init)
;;; init.el ends here

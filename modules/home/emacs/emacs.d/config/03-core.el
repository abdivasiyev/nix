;; ---------------------------------------------------------------------------
;; General settings
;; ---------------------------------------------------------------------------

(when (eq system-type 'darwin)
  (setq mac-command-modifier 'super
        mac-option-modifier 'meta
        mac-control-modifier 'control))

(setq-default show-trailing-whitespace t
              indent-tabs-mode nil
              ;; The original config used the singular variable name, which is
              ;; a typo.  This is the actual auto-revert option.
              global-auto-revert-non-file-buffers t
              whitespace-style '(face tabs trailing tab-mark spaces space-mark)
              fill-column 120
              scroll-margin 8
              scroll-conservatively 101
              scroll-preserve-screen-position t
              auto-window-vscroll nil
              desktop-restore-frames nil)

(setq initial-scratch-message nil
      confirm-kill-emacs 'yes-or-no-p
      tab-width 2
      backup-directory-alist `(("." . ,(expand-file-name "backups" user-emacs-directory)))
      auto-save-file-name-transforms `((".*" ,(expand-file-name "auto-saves" user-emacs-directory) t))
      tramp-auto-save-directory temporary-file-directory
      display-line-numbers-type 'relative
      display-line-numbers-width-start t
      delete-by-moving-to-trash t
      desktop-auto-save-timeout 3
      enable-recursive-minibuffers t
      completion-ignore-case t
      read-buffer-completion-ignore-case t
      read-file-name-completion-ignore-case t
      read-extended-command-predicate #'command-completion-default-include-p)

(make-directory (expand-file-name "backups" user-emacs-directory) t)
(make-directory (expand-file-name "auto-saves" user-emacs-directory) t)

(defalias 'yes-or-no-p 'y-or-n-p)

(add-hook 'prog-mode-hook #'whitespace-mode)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
;; Use the local mode.  The old `global-display-fill-column-indicator-mode'
;; toggled a global state every time a programming buffer was opened.
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)
(add-hook 'before-save-hook #'whitespace-cleanup)

(electric-pair-mode 1)
(add-hook 'prog-mode-hook #'auto-composition-mode)
(global-auto-composition-mode -1)
(global-auto-revert-mode 1)
(desktop-save-mode 1)
(global-hl-line-mode 1)
(column-number-mode 1)

(set-face-attribute 'default nil
                    :font "JetBrainsMono Nerd Font"
                    :height 160)
(set-face-attribute 'fill-column-indicator nil
                    :foreground "#717C7C"
                    :background "transparent")

(global-set-key (kbd "s-n") #'duplicate-line)
(global-set-key (kbd "M-&") #'project-async-shell-command)
(global-set-key (kbd "M-!") #'project-shell-command)
(global-set-key (kbd "C-x c") #'project-compile)


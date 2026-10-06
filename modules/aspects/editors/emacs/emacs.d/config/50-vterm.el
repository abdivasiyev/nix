;; ---------------------------------------------------------------------------
;; Terminal
;; ---------------------------------------------------------------------------

(require 'vterm)

(setq vterm-max-scrollback 1000000)

(defun my/vterm-setup ()
  "Disable programming-buffer visual helpers that do not suit Vterm."
  (display-fill-column-indicator-mode -1)
  (setq-local show-trailing-whitespace nil))

(add-hook 'vterm-mode-hook #'my/vterm-setup)

(setq vterm-toggle-scope 'project
      vterm-shell "/bin/zsh")
(autoload 'vterm-toggle "vterm-toggle" nil t)
(global-set-key (kbd "C-c t") #'vterm-toggle)


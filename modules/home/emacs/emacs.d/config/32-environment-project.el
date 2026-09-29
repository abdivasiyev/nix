;; ---------------------------------------------------------------------------
;; Project-local environment
;; ---------------------------------------------------------------------------

(require 'envrc)
(autoload 'envrc-global-mode "envrc" nil t)
(autoload 'envrc-reload "envrc" nil t)
(add-hook 'after-init-hook #'envrc-global-mode 90)
(global-set-key (kbd "C-c r") #'envrc-reload)

;; Emacs 30 includes EditorConfig.
(require 'editorconfig)
(editorconfig-mode 1)


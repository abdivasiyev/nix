;; ---------------------------------------------------------------------------
;; Dired
;; ---------------------------------------------------------------------------

(require 'dired-x)
(setq-default dired-dwim-target t)
(when (boundp 'my/nix-coreutils-ls)
  (setq insert-directory-program my/nix-coreutils-ls))

(autoload 'dired-toggle "dired-toggle" nil t)
(global-set-key (kbd "s-p") #'dired-toggle)
(with-eval-after-load 'dired-toggle
  (define-key dired-mode-map (kbd "q") #'dired-toggle-quit)
  (define-key dired-mode-map [remap dired-find-file] #'dired-toggle-find-file)
  (define-key dired-mode-map [remap dired-up-directory] #'dired-toggle-up-directory)
  (setq dired-toggle-window-size 80
        dired-toggle-window-side 'right)
  (add-hook 'dired-toggle-mode-hook
            (lambda ()
              (visual-line-mode 1)
              (setq-local visual-line-fringe-indicators '(nil right-curly-arrow))
              (setq-local word-wrap nil))))

;; Emacs 30 includes which-key.
(require 'which-key)
(setq which-key-idle-delay 0.5)
(which-key-mode 1)


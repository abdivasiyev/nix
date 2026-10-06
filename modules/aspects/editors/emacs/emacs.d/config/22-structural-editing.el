;; ---------------------------------------------------------------------------
;; Structural editing / multiple cursors
;; ---------------------------------------------------------------------------

(autoload 'paredit-mode "paredit" nil t)
(add-hook 'emacs-lisp-mode-hook #'paredit-mode)

(require 'multiple-cursors)
(global-set-key (kbd "s->") #'mc/mark-next-like-this)
(global-set-key (kbd "s-<") #'mc/mark-previous-like-this)
(global-set-key (kbd "C-s-l") #'mc/mark-all-like-this)


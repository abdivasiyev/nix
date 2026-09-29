;; ---------------------------------------------------------------------------
;; Undo visualization
;; ---------------------------------------------------------------------------

(require 'vundo)

(setq vundo-compact-display t
      undo-limit (* 80 1024 1024)
      undo-strong-limit (* 120 1024 1024)
      undo-outer-limit (* 360 1024 1024))

(autoload 'vundo "vundo" nil t)
(autoload 'vundo-popup-mode "vundo-popup" nil t)
(add-hook 'prog-mode-hook #'vundo-popup-mode)
(global-set-key (kbd "C-M-/") #'vundo)

(with-eval-after-load 'vundo
  (setq vundo-glyph-alist vundo-unicode-symbols))

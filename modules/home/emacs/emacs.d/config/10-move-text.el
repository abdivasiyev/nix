;; ---------------------------------------------------------------------------
;; Editing helpers
;; ---------------------------------------------------------------------------

(autoload 'move-text-up "move-text" nil t)
(autoload 'move-text-down "move-text" nil t)
(global-set-key (kbd "M-p") #'move-text-up)
(global-set-key (kbd "M-n") #'move-text-down)


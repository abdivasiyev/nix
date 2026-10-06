;; ---------------------------------------------------------------------------
;; Window movement and pulse feedback
;; ---------------------------------------------------------------------------

(global-set-key (kbd "M-h") #'windmove-left)
(global-set-key (kbd "M-l") #'windmove-right)
(global-set-key (kbd "M-k") #'windmove-up)
(global-set-key (kbd "M-j") #'windmove-down)

(require 'pulse)

(defun pulse-line (&rest _)
  "Pulse the current line."
  (pulse-momentary-highlight-one-line (point)))

(defun pulse-copy (orig-fn &rest args)
  "Pulse the region after ORIG-FN is called with ARGS."
  (apply orig-fn args)
  (pulse-momentary-highlight-region (region-beginning) (region-end)))

(dolist (command '(windmove-left
                   windmove-right
                   windmove-up
                   windmove-down
                   move-to-window-line-top-bottom
                   recenter-top-bottom
                   other-window))
  (advice-add command :after #'pulse-line))
(advice-add 'kill-ring-save :around #'pulse-copy)


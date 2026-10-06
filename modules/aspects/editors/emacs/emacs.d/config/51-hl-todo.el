;; ---------------------------------------------------------------------------
;; TODO highlighting
;; ---------------------------------------------------------------------------

(setq hl-todo-keyword-faces
      '(("TODO" . (:inherit warning :inverse-video t))
        ("WARNING" . (:inherit warning :inverse-video t))
        ("DEPRECATED" . (:inherit font-lock-warning-face :inverse-video t))
        ("FIXME" . (:inherit error :inverse-video t))
        ("HACK" . (:inherit font-lock-constant-face :inverse-video t))
        ("NOTE" . (:inherit success :inverse-video t))))
(autoload 'hl-todo-mode "hl-todo" nil t)
(add-hook 'prog-mode-hook #'hl-todo-mode)


;; ---------------------------------------------------------------------------
;; Completion
;; ---------------------------------------------------------------------------

(autoload 'company-coq-mode "company-coq" nil t)
(add-hook 'coq-mode-hook #'company-coq-mode)

(autoload 'global-company-mode "company" nil t)
(add-hook 'after-init-hook #'global-company-mode)


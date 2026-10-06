;; ---------------------------------------------------------------------------
;; Minibuffer completion
;; ---------------------------------------------------------------------------

(require 'vertico)
(setq vertico-cycle t
      vertico-count 15)
(vertico-mode 1)

(require 'vertico-directory)
(define-key vertico-map (kbd "RET") #'vertico-directory-enter)
(define-key vertico-map (kbd "DEL") #'vertico-directory-delete-char)
(define-key vertico-map (kbd "M-DEL") #'vertico-directory-delete-word)
(add-hook 'rfn-eshadow-update-overlay-hook #'vertico-directory-tidy)

(require 'orderless)
(setq completion-styles '(orderless basic)
      completion-category-overrides '((file (styles basic partial-completion))))

(savehist-mode 1)

(autoload 'smex "smex" nil t)
(global-set-key (kbd "M-x") #'smex)
(global-set-key (kbd "C-c C-c M-x") #'execute-extended-command)


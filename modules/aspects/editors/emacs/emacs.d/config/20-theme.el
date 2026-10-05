;; ---------------------------------------------------------------------------
;; Theme
;; ---------------------------------------------------------------------------

;; (load-theme 'doom-molokai t)

;; `gruber-darker-theme' is installed by Nix too.  Switch with:
;; (when-let ((theme-file
;;             (locate-library "gruber-darker-theme")))
;;   (add-to-list 'custom-theme-load-path
;;                (file-name-directory theme-file)))

;; (load-theme 'gruber-darker t)

(when-let ((theme-file
            (locate-library "gruvbox-theme")))
  (add-to-list 'custom-theme-load-path
               (file-name-directory theme-file)))

(load-theme 'gruvbox-dark-hard)

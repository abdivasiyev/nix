;; ---------------------------------------------------------------------------
;; Dashboard / icons
;; ---------------------------------------------------------------------------

(require 'nerd-icons)

(autoload 'nerd-icons-dired-mode "nerd-icons-dired" nil t)
(add-hook 'dired-mode-hook #'nerd-icons-dired-mode)

(require 'dashboard)
(setq initial-buffer-choice 'dashboard-open
      dashboard-items '((recents . 10)
                        (projects . 10))
      dashboard-banner-logo-title ""
      dashboard-startup-banner 1
      dashboard-center-content t
      dashboard-vertically-center-content t
      dashboard-display-icons-p t
      dashboard-icon-type 'nerd-icons
      dashboard-set-heading-icons t
      dashboard-set-file-icons t)
(dashboard-setup-startup-hook)


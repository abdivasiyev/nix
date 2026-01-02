;;; early-init.el --- Early initialization for Emacs -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
;; Disable GUI elements
(tool-bar-mode 0)
(scroll-bar-mode 0)
(menu-bar-mode 0)
(setq inhibit-splash-screen t)
(setq use-file-dialog nil)
(setq ring-bell-function 'ignore)
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror 'nomessage)

(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

(setq package-enable-at-startup nil)

(setq ns-use-native-fullscreen :true)
(add-to-list 'default-frame-alist '(fullscreen . fullscreen))

;; temporarily increase gc threshold to speed up startup
(setq gc-cons-threshold most-positive-fixnum)

;; restore gc threshold after startup
(add-hook 'emacs-startup-hook
            (lambda ()
              (setq gc-cons-threshold (* 50 1024 1024))))

(provide 'early-init)
;;; early-init.el ends here

;;; early-init.el --- Early initialization for Emacs -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; Disable GUI elements before the first frame is created.
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)

(setq inhibit-splash-screen t
      use-file-dialog nil
      ring-bell-function #'ignore
      custom-file (expand-file-name "custom.el" user-emacs-directory)
      ;; Packages are supplied by Nix, not package.el.
      package-enable-at-startup nil)

(load custom-file 'noerror 'nomessage)

(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

(when (eq system-type 'darwin)
  (setq ns-use-native-fullscreen t))

(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Temporarily increase the GC threshold while loading init.el.
(setq gc-cons-threshold most-positive-fixnum)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 50 1024 1024))))

(provide 'early-init)
;;; early-init.el ends here

;;; 01-environment.el --- Environment -*- lexical-binding: t; -*-

;; Nix generates `my/nix-tool-path`.
;;
;; Put Nix-managed tools at the front of PATH used by child processes
;; and Emacs' own executable lookup.

(when (boundp 'my/nix-tool-path)
  (setenv
   "PATH"
   (concat
    my/nix-tool-path
    path-separator
    (or (getenv "PATH") "")))

  (setq exec-path
        (append
         (parse-colon-path my/nix-tool-path)
         exec-path)))

;; ---------------------------------------------------------------------------
;; Git
;; ---------------------------------------------------------------------------

(require 'diff-hl)
(require 'diff-hl-flydiff)
(require 'diff-hl-dired)

(setq magit-auto-revert-mode t)
(autoload 'magit "magit" nil t)
(global-set-key (kbd "C-x g") #'magit)

(with-eval-after-load 'magit
  ;; `% b' / `% c' default to a sibling of the *bare* repo.  Keep your
  ;; <root>/worktrees/<repo>/<branch> convention instead.
  (defun my/magit-read-worktree-directory (prompt commit)
    "Read a worktree directory following the <root>/worktrees/<repo>/ layout."
    (let* ((top (directory-file-name (or (magit-toplevel) default-directory)))
           (parent (file-name-directory top))
           (grand (file-name-nondirectory
                   (directory-file-name
                    (file-name-directory (directory-file-name parent))))))
      (if (equal grand "worktrees")
          (read-directory-name prompt parent nil nil
                               (and commit (string-replace "/" "-" commit)))
        (magit-read-worktree-directory-sibling prompt commit))))
  (setq magit-read-worktree-directory-function
        #'my/magit-read-worktree-directory)
  (require 'forge))

(add-hook 'magit-pre-refresh-hook #'diff-hl-magit-pre-refresh)
(add-hook 'magit-post-refresh-hook #'diff-hl-magit-post-refresh)
(add-hook 'dired-mode-hook #'diff-hl-dired-mode)
(global-diff-hl-mode 1)
(diff-hl-flydiff-mode 1)


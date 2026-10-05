;; ---------------------------------------------------------------------------
;; Projects
;; ---------------------------------------------------------------------------

;; Repos use a bare + worktree layout:
;;   <root>/git/<repo>.git            bare repository
;;   <root>/worktrees/<repo>/<name>   worktrees, one project each
(defvar my/project-root "~/Development"
  "Directory tree scanned by `my/rescan-projects'.")

(defun my/rescan-projects (&optional dir)
  "Register every project under `my/project-root' and drop dead entries.
With a prefix argument, prompt for DIR to scan a single subtree instead."
  (interactive
   (list (when current-prefix-arg
           (read-directory-name "Scan for projects: " my/project-root))))
  (require 'project)
  (project-forget-zombie-projects)
  (project-remember-projects-under (or dir my/project-root) t)
  (project-forget-zombie-projects)
  (message "%d projects known" (length (project-known-project-roots))))

(defun my/worktree-dired (&optional as-magit)
  "Pick a worktree of the current repository and open Dired there.
With a prefix argument, open its Magit status buffer instead."
  (interactive "P")
  (require 'magit)
  (let* ((wts (seq-remove (lambda (w) (nth 3 w))
                          (magit-list-worktrees)))
         (cands (mapcar (lambda (w)
                          (cons (format "%-30s %s"
                                        (file-name-nondirectory
                                         (directory-file-name (car w)))
                                        (or (nth 2 w) "(detached)"))
                                (car w)))
                        wts))
         (dir (cdr (assoc (completing-read "Worktree: " cands nil t) cands))))
    (if as-magit
        (magit-status-setup-buffer dir)
      (dired dir))))

(require 'project)
(define-key project-prefix-map (kbd "R") #'my/rescan-projects)
(define-key project-prefix-map (kbd "w") #'my/worktree-dired)
(add-to-list 'project-switch-commands '(project-dired "Dired" ?D) t)

;; Without this every worktree project is named after its directory,
;; so dozens of them can all be called "develop".
(cl-defmethod project-name ((project (head vc)))
  (let* ((root (directory-file-name (project-root project)))
         (wt (file-name-nondirectory root))
         (pdir (directory-file-name (file-name-directory root)))
         (parent (file-name-nondirectory pdir))
         (grand (file-name-nondirectory
                 (directory-file-name (file-name-directory pdir)))))
    (cond ((equal grand "worktrees")
           (format "%s:%s" parent wt))
          ((string-suffix-p ".git" parent)
           (format "%s:%s" (string-remove-suffix ".git" parent) wt))
          (t wt))))


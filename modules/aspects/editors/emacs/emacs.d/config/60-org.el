;; ---------------------------------------------------------------------------
;; Org
;; ---------------------------------------------------------------------------

(setq org-directory "~/Documents/notes"
      org-agenda-files '("~/Documents/notes/inbox.org"
                         "~/Documents/notes/todo.org"
                         "~/Documents/notes/someday.org"
                         "~/Documents/notes/verb.org")
      org-default-notes-file "~/Documents/notes/inbox.org"
      org-todo-keywords
      '((sequence "TODO(t)" "IN-PROGRESS(i!)" "WAITING(w@)" "|"
                  "DONE(d!)" "CANCELLED(c@)"))
      org-log-done 'time
      org-log-into-drawer t
      org-return-follows-link t
      org-hide-emphasis-markers t
      org-pretty-entities t
      org-ellipsis " ▾"
      org-startup-folded 'content
      org-refile-targets '((org-agenda-files :maxlevel . 3))
      org-refile-use-outline-path t
      org-outline-path-complete-in-steps nil
      org-agenda-start-on-weekday 1
      org-agenda-span 'day
      org-agenda-window-setup 'current-window
      org-capture-templates
      '(("t" "Task" entry
         (file+headline "~/Documents/notes/inbox.org" "Inbox")
         "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n%a"
         :empty-lines 1)
        ("n" "Note" entry
         (file+headline "~/Documents/notes/notes.org" "Notes")
         "* %? :note:\n:PROPERTIES:\n:CREATED: %U\n:END:"
         :empty-lines 1)
        ("j" "Journal" entry
         (file+datetree "~/Documents/notes/journal.org")
         "* %<%H:%M> %?\n"
         :empty-lines 1)
        ("s" "Someday" entry
         (file+headline "~/Documents/notes/someday.org" "Someday")
         "* %?\n:PROPERTIES:\n:CREATED: %U\n:END:"
         :empty-lines 1)))

(add-hook 'org-mode-hook #'visual-line-mode)
(add-hook 'org-mode-hook #'org-indent-mode)

(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)
(global-set-key (kbd "C-c C-l") #'org-store-link)

(with-eval-after-load 'org
  (require 'org-tempo)
  (require 'verb)
  (define-key org-mode-map (kbd "C-c C-r") verb-command-map)
  (advice-add 'org-refile :after #'org-save-all-org-buffers))

(setq org-modern-star '("◉" "○" "◈" "◇" "✸")
      org-modern-table nil)
(autoload 'org-modern-mode "org-modern" nil t)
(add-hook 'org-mode-hook #'org-modern-mode)

;; `impostman' is installed by Nix and autoloads its interactive commands.


;; ----------------------------------------------------------
;; Browser setup
;; ----------------------------------------------------------
(setq browse-url-browser-function #'xwidget-webkit-browse-url)

;; open browser on the right side
(define-advice xwidget-webkit-goto-url
    (:around (orig &rest args) my/xwidget-side-window)
  (let ((switch-to-buffer-obey-display-actions t))
    (apply orig args)))

(add-to-list 'display-buffer-alist
             '("\\*xwidget-webkit"
               (display-buffer-in-side-window)
               (side . right) (window-width . 0.5)))

(defun my/web-search (base &optional prompt)
  "Search BASE (a URL ending so the query can be appended) with the
active region, or a prompted string (PROMPT) when there's no region."
  (browse-url
   (concat base
           (url-hexify-string
            (if (use-region-p)
                (buffer-substring-no-properties (region-beginning) (region-end))
              (read-string (or prompt "Search: ")))))))

(defun my/google ()
  "Search Google."
  (interactive)
  (my/web-search "https://www.google.com/search?q=" "Google: "))

(defun my/marginalia ()
  "Search Marginalia (indie-web search engine)."
  (interactive)
  (my/web-search "https://marginalia-search.com/search?query=" "Marginalia: "))

(defun my/browse-url-at-point-or-prompt ()
  "Open the URL at point in xwidget, or prompt if there isn't one."
  (interactive)
  (let ((url (browse-url-url-at-point)))   ; built-in finder, verified present
    (if url
        (browse-url url)
      (browse-url (read-string "URL: ")))))

(define-prefix-command 'my/web-map)
(global-set-key (kbd "C-c w") 'my/web-map)                           ;; w = web
(define-key my/web-map (kbd "g") #'my/google)                        ;; C-c w g
(define-key my/web-map (kbd "m") #'my/marginalia)                    ;; C-c w g
(define-key my/web-map (kbd "o") #'browse-url)                       ;; C-c w o  (open any URL)
(define-key my/web-map (kbd "u") #'my/browse-url-at-point-or-prompt) ;; C-c w u (open any URL under cursor)


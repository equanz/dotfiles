(use-package markdown-mode
  :init
  (setq markdown-command "marked --gfm")
  ;; ignore auto cleanup whitespace
  (add-hook 'markdown-mode-hook
            '(lambda ()
               (set (make-local-variable 'whitespace-action) nil)))
  :mode (("\\.md\\'" . markdown-mode))
  :bind (("C-c p" . markdown-open-in-firefox-macos))
  )

;; open to Firefox (only use in macOS)
(defun markdown-open-in-firefox-macos ()
  "Open path in Firefox (macOS)"
  (interactive)
  (message (mapconcat #'shell-quote-argument
                      (list "open" "-a" "Firefox" buffer-file-name)
                      " "))
  (async-shell-command
   (mapconcat #'shell-quote-argument
              (list "open" "-a" "Firefox" buffer-file-name)
              " ")))

;; config of markdown-mode
(setq markdown-command "marked --gfm")
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; command setting
(bind-key "C-c p" 'markdown-open-in-firefox-macos)

;; open to Firefox (only use in macOS)
(defun markdown-open-in-firefox-macos ()
  "Open path in Firefox (macOS)"
  (interactive)
  (message    (mapconcat #'shell-quote-argument
              (list "open" "-a" "Firefox" buffer-file-name)
              " "))
  (async-shell-command
   (mapconcat #'shell-quote-argument
              (list "open" "-a" "Firefox" buffer-file-name)
              " "))
  )
;; end of config

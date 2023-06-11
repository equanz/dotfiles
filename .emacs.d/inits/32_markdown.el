(use-package markdown-mode
  :init
  (setq markdown-command "marked --gfm")
  ;; ignore auto cleanup whitespace
  (add-hook 'gfm-mode-hook
            '(lambda ()
               (set (make-local-variable 'whitespace-action) nil)))
  :mode (("\\.md\\'" . gfm-mode))
  :bind (:map gfm-mode-map
         ("C-c p" . open-buffer-file-in-firefox-macos)
         ("C-j" . markdown-enter-key)))

;; open to Firefox (only use in macOS)
(defun open-buffer-file-in-firefox-macos ()
  "Open a file in Firefox (macOS)"
  (interactive)
  (call-process-shell-command
   (mapconcat #'shell-quote-argument
              (list "open" "-a" "Firefox" buffer-file-name)
              " ")
   nil 0))

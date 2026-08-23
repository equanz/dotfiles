(use-package mermaid-mode
  :init
  (setq mermaid-output-format ".svg")
  :config
  (unbind-key "C-c C-o" mermaid-mode-map)
  ;; do nothing to avoid remote connection
  (defun mermaid--make-browser-string (diagram)
    "http://localhost:8080/")
  (defun mermaid-open-browser ())

  ;; compile and show the result in the browser
  (defun mermaid-compile-file (file-name)
    "Compile the given mermaid file using mmdc."
    (interactive "fFilename: ")
    (let* ((input file-name)
           (output (concat (file-name-sans-extension input) mermaid-output-format))
           (exit-code (apply #'call-process mermaid-mmdc-location nil "*mmdc*" nil (append (split-string mermaid-flags " " t) (list "-i" input "-o" output)))))
      (if (zerop exit-code)
          ()
          ;; (let ((buffer (find-file-noselect output t)))
          ;;   (display-buffer buffer)
          ;;   (with-current-buffer buffer
          ;;     (auto-revert-mode)))
        (pop-to-buffer "*mmdc*")))))

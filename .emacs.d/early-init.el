;; Homebrew tools must be visible before asynchronous native compilation starts.
(when (eq system-type 'darwin)
  (dolist (dir '("/opt/homebrew/bin" "/usr/local/bin"))
    (when (file-directory-p dir)
      (add-to-list 'exec-path dir)
      (setenv "PATH"
              (concat dir path-separator (or (getenv "PATH") ""))))))

(require 'migemo)

;; migemo command
;; TODO: shouldn't add environment specific path
(setq migemo-command "cmigemo")
(setq migemo-options '("-q" "--emacs"))

;; migemo dict path
(setq migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict")

(setq migemo-user-dictionary nil)
(setq migemo-regex-dictionary nil)
(setq migemo-coding-system 'utf-8-unix)
(migemo-init)

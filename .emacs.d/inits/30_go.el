;; require
(require 'go-mode)

(add-hook 'go-mode-hook
  (lambda ()
    (setq indent-tabs-mode nil)))

;; lsp config
(add-hook 'go-mode-hook #'lsp-deferred)


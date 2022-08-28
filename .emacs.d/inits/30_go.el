(use-package go-mode
  :commands (go-mode)
  :config
  (add-hook 'go-mode-hook #'lsp-deferred))

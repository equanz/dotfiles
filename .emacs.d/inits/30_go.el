(use-package go-mode
  :init
  (add-hook 'go-mode-hook #'lsp-deferred))

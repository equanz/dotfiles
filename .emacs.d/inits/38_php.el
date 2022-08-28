(use-package php-mode
  :commands (php-mode)
  :config
  (add-hook 'php-mode-hook #'lsp-deferred))

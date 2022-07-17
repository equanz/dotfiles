(use-package php-mode
  :init
  (add-hook 'php-mode-hook #'lsp-deferred))

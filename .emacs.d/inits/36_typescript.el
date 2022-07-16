(use-package typescript-mode
  :init
  (setq typescript-indent-level 2) ;; indent level
  (sp-local-pair 'typescript-mode "<" ">") ;; brackets pair
  (add-hook 'typescript-mode-hook #'lsp-deferred)
  :mode (("\\.ts\\'" . typescript-mode)))

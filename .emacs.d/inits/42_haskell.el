(use-package haskell-mode
  :init
  (use-package lsp-haskell
    :init
    (add-hook 'haskell-mode-hook #'lsp-deferred)
    (add-hook 'haskell-literate-mode-hook #'lsp-deferred))
  :bind (:map haskell-mode-map
         ("C-j" . haskell-indentation-newline-and-indent)))

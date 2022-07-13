(require 'typescript-mode)
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))

;; indent level
(setq typescript-indent-level 2)

;; brackets pair
(sp-local-pair 'typescript-mode "<" ">")

;; lsp config
(add-hook 'typescript-mode-hook #'lsp-deferred)

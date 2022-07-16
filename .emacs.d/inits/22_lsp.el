(use-package lsp-mode
  :init
  ;; disable yasnippet
  (setq lsp-enable-snippet nil)

  ;;(setq lsp-document-sync-method 'incremental)
  (setq lsp-response-timeout 5)
  (setq lsp-completion-enable t)
  (setq lsp-enable-xref t)
  (setq lsp-eldoc-enable-hover nil)

  (use-package lsp-ui
    :init
    ;; lsp-ui-sideline
    (setq lsp-ui-sideline-enable t)
    (setq lsp-ui-sideline-show-diagnostics t)
    (setq lsp-ui-sideline-show-hover t)
    (setq lsp-ui-sideline-show-code-actions t)
    (setq lsp-ui-sideline-delay 2)
    ;; lsp-ui-peek
    (setq lsp-ui-peek-enable t)
    ;; lsp-ui-doc
    (setq lsp-ui-doc-enable nil)
    ;; lsp-ui-imenu
    (setq lsp-ui-imenu-enable nil)
    ;; use flycheck instead of flymake
    (setq lsp-ui-flycheck-enable t)
    (setq lsp-prefer-flymake nil)
    )

  ;; treemacs
  (use-package lsp-treemacs
    :config
    (lsp-treemacs-sync-mode 1))

  (use-package docker-tramp)

  :bind (:map lsp-ui-mode-map
         ([remap xref-find-definitions] . lsp-ui-peek-find-definitions)
         ([remap xref-find-references] . lsp-ui-peek-find-references)))

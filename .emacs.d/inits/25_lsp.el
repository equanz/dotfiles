(require 'lsp-mode)

(require 'lsp-ui)

;; lsp-ui-sideline
(setq lsp-ui-sideline-enable t)
(setq lsp-ui-sideline-show-diagnostics t)
(setq lsp-ui-sideline-show-hover t)
(setq lsp-ui-sideline-show-code-actions t)
(setq lsp-ui-sideline-delay 2)

;; lsp-ui-peek
(setq lsp-ui-peek-enable t)
(bind-key [remap xref-find-definitions] 'lsp-ui-peek-find-definitions lsp-ui-mode-map)
(bind-key [remap xref-find-references] 'lsp-ui-peek-find-references lsp-ui-mode-map)

;; lsp-ui-doc
(setq lsp-ui-doc-enable nil)

;; lsp-ui-imenu
(setq lsp-ui-imenu-enable nil)

;; use flycheck instead of flymake
(setq lsp-ui-flycheck-enable t)
(setq lsp-prefer-flymake nil)

;; disable yasnippet
(with-eval-after-load 'lsp-mode
  (setq lsp-enable-snippet nil))

;; treemacs
(lsp-treemacs-sync-mode 1)

;;(setq lsp-document-sync-method 'incremental)
(setq lsp-response-timeout 5)
(setq lsp-completion-enable t)
(setq lsp-enable-xref t)
(setq lsp-eldoc-enable-hover nil)

(require 'lsp-mode)

;; option
(require 'lsp-ui)
(require 'company-lsp)

;; enable xref
(setq lsp-enable-xref t)

;; disable lsp-ui
(setq lsp-ui-doc-enable nil)
(setq lsp-ui-peek-enable nil)
(setq lsp-ui-sideline-enable nil)
(setq lsp-ui-imenu-enable nil)

;; use flycheck instead of flymake
(setq lsp-ui-flycheck-enable t)
(setq lsp-prefer-flymake nil)


(add-hook 'c-mode-hook #'lsp-deferred)
(add-hook 'c++-mode-hook #'lsp-deferred)

;; run lsp server on docker container and use it through TRAMP
;; (lsp-register-client
;;  (make-lsp-client :new-connection (lsp-tramp-connection "clangd")
;;                   :major-modes '(c-mode c++-mode)
;;                   :remote? t
;;                   :server-id 'clangd-12-remote))

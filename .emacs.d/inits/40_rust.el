(use-package rust-mode
  :init
  (add-to-list 'exec-path (expand-file-name "~/.cargo/bin"))
  (setq lsp-rust-server 'rust-analyzer)

  (use-package cargo
    :init
    (add-hook 'rust-mode-hook 'cargo-minor-mode))

  (add-hook 'before-save-hook (lambda () (when (eq 'rust-mode major-mode) (lsp-format-buffer))))

  (add-hook 'rust-mode-hook #'lsp-deferred))

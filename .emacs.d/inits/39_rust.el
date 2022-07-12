(require 'rust-mode)
(add-to-list 'exec-path (expand-file-name "~/.cargo/bin"))
(setq rust-format-on-save t)
(add-hook 'rust-mode-hook 'cargo-minor-mode)

(add-hook 'rust-mode-hook 'lsp)

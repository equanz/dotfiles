(require 'yatex)

(add-to-list 'auto-mode-alist '("\\.tex\\'" . yatex-mode))
(autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)

;; disable blacket paren
;(setq YaTeX-modify-mode 'nil)
;(setq YaTeX-close-paren-always 'never)

;; execution commands
;; TODO: shouldn't add environment specific path
(setq tex-command "platex")
(setq dviprint-command-format "dvipdfmx %s")
(setq dvi2-command "open -a Skim")

;; set intelligent-newline keymap (M-j)
(bind-key "M-j" 'YaTeX-intelligent-newline YaTeX-mode-map)

(use-package yatex
  :init
  ;; disable bracket paren
  ;; (setq YaTeX-modify-mode 'nil)
  ;; (setq YaTeX-close-paren-always 'never)
  ;; execution commands
  (setq tex-command "platex")
  (setq dviprint-command-format "dvipdfmx %s")
  (setq dvi2-command "open -a Skim")
  :commands (yatex-mode)
  :mode (("\\.tex\\'" . yatex-mode))
  :bind (:map YaTeX-mode-map
         ("M-j" . YaTeX-intelligent-newline)))

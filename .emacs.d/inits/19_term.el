(use-package term+
  :commands (term+mux-new)
  :config
  (use-package term+mux)
  :bind (("C-c t" . term+mux-new)
         :map term-mode-map
         ("C-h" . term-send-backspace)))

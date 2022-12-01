(use-package company
  :init
  (setq company-selection-wrap-around t) ;; go to next of end of line, then go to begin of line
  (add-hook 'after-init-hook 'global-company-mode)
  :bind ((:map company-active-map
          ("M-n" . nil)
          ("M-p" . nil)
          ("C-n" . company-select-next)
          ("C-p" . company-select-previous)
          ("C-j" . company-complete-selection)
          ("C-h" . nil))))

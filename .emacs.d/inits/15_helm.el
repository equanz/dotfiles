(use-package helm
  :init
  (setq helm-split-window-inside-p t)
  (setq helm-split-window-default-side 'below)
  (helm-mode t)
  :bind (("C-x C-f" . helm-find-files)
         ("M-x" . helm-M-x)))

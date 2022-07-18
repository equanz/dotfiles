(use-package helm
  :init
  (setq helm-split-window-inside-p t)
  (setq helm-split-window-default-side 'below)

  (use-package helm-swoop
    :init
    ;; split window inside the current window
    (setq helm-swoop-split-with-multiple-windows t)
    (setq helm-swoop-split-direction 'split-window-vertically)
    (setq helm-swoop-move-to-line-cycle t)
    :bind (("C-s" . helm-swoop-from-isearch)
           :map helm-swoop-map
           ("C-s" . helm-next-line)
           ("C-r" . helm-previous-line)
           :map helm-multi-swoop-map
           ("C-s" . helm-next-line)
           ("C-r" . helm-previous-line)))

  (helm-mode t)
  :bind (("C-x C-f" . helm-find-files)
         ("M-x" . helm-M-x)))

(use-package helm
  :commands (helm)
  :config
  (setq helm-split-window-inside-p t)
  (setq helm-split-window-default-side 'below)

  (use-package helm-swoop
    :commands (helm-swoop)
    :config
    ;; split window inside the current window
    (setq helm-swoop-split-with-multiple-windows t)
    (setq helm-swoop-split-direction 'split-window-vertically)
    (setq helm-swoop-move-to-line-cycle t)
    :bind (("C-S-s" . helm-swoop-from-isearch)
           :map helm-swoop-map
           ("C-s" . helm-next-line)
           ("C-r" . helm-previous-line)
           :map helm-multi-swoop-map
           ("C-s" . helm-next-line)
           ("C-r" . helm-previous-line)))

  (use-package migemo
    :init
    ;; migemo command
    (setq migemo-command "cmigemo")
    (setq migemo-options '("-q" "--emacs"))

    ;; migemo dict path
    (setq migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict")

    (setq migemo-user-dictionary nil)
    (setq migemo-regex-dictionary nil)
    (setq migemo-coding-system 'utf-8-unix)
    :config
    (migemo-init)
    (helm-migemo-mode 1))

  (helm-mode t)
  :bind (("C-x C-f" . helm-find-files)
         ("M-x" . helm-M-x)))

(require 'helm)
(require 'helm-config)

(setq helm-split-window-inside-p t)
(setq helm-split-window-default-side 'below)

(bind-key "C-x C-f" 'helm-find-files)
(bind-key "M-x" 'helm-M-x)

(helm-mode t)

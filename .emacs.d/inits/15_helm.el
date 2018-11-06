(require 'helm)
(require 'helm-config)

(setq helm-split-window-in-side-p t)
(setq helm-split-window-default-side 'below)

;; helm-find-filesの割り当て(C-x C-f)
(bind-key "C-x C-f" 'helm-find-files)

;; helm-M-xの割り当て(M-x)
(bind-key "M-x" 'helm-M-x)

;; helm-modeの起動
(helm-mode t)


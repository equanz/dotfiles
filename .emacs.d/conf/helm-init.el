(require 'helm)
(require 'helm-config)

;; helm-modeの起動
(helm-mode t)

;; helm-find-filesの割り当て(C-x C-f)
(bind-key "C-x C-f" 'helm-find-files)

;; helm-M-xの割り当て(M-x)
(bind-key "M-x" 'helm-M-x)

;; 補完キーの割り当て(TAB)
(bind-key "<tab>" 'helm-execute-persistent-action helm-read-file-map)

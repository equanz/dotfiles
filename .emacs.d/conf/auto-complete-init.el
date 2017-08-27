(require 'auto-complete)
(require 'auto-complete-config) ;; 必須ではない
(global-auto-complete-mode t)   ;; 自動補完の方法変更
(push 'ac-source-filename ac-sources)

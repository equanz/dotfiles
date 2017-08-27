;; markdown-modeの設定
(setq markdown-command "marked --gfm")
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
;; ここまで

;; aspellの使用
(setq-default ispell-program-name "aspell")

;; 日本語まじりでも判断可能
(eval-after-load "ispell"
 '(add-to-list 'ispell-skip-region-alist '("[^\000-\377]+")))

;; yatex-modeで起動
(add-hook 'yatex-mode-hook' flyspell-mode)

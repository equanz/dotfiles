(require 'emmet-mode)
(add-hook 'sgml-mode-hook 'emmet-mode) ;; すべてのマークアップモードで自動起動
(add-hook 'css-mode-hook 'emmet-mode)  ;; CSSにも適用
(add-hook 'emmet-mode-hook (lambda () (setq emmet-indentation 2))) ;;インデント幅を設定
(eval-after-load "emmet-mode"
  '(bind-key "C-j" nil emmet-mode-keymap))


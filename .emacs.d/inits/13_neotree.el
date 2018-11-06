;; all-the-iconsの設定
(require 'all-the-icons)
;; ここまで

;; neotreeの設定
(require 'neotree)
(setq neo-theme (if (display-graphic-p) 'icons 'arrow)) ;; setup neotree's theme
(bind-key "<f8>" 'neotree-toggle) ;; f8キーでトグル
(bind-key* "C-c o" 'neotree-show) ;; C-c oでカレントバッファをneotreeに
(bind-key "C-u" 'neotree-select-up-and-unfold-node neotree-mode-map) ;; 親ディレクトリをアンフォールド
(bind-key "C-c C-o" 'neotree-open-command neotree-mode-map) ;; shellコマンド "open" を起動
(setq neo-show-hidden-files t)  ;; 隠しファイルの表示
(neotree-show)  ;; emacs起動時に自動起動
(setq neo-theme (if (display-graphic-p) 'icons 'arrow)) ;; themeの変更

;; 親ディレクトリをアンフォールドする関数
(defun neotree-select-up-and-unfold-node ()
  "select-up node and unfold"
  (interactive)
  (neotree-select-up-node)
  (neotree-quick-look)
)
;; ここまで

(defun neotree-open-command ()
  "shell open command"
  (interactive)
  (shell-command "open ./")
)

;; gitプロジェクトの反映
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(neo-vc-integration (quote (face char)))
 '(package-selected-packages
   (quote
    (typescript-mode flycheck yascroll atom-one-dark-theme web-mode magit markdown-mode xpm smooth-scroll smartparens rainbow-mode powerline neotree mozc evil emmet-mode auto-complete all-the-icons))))
;; ここまで

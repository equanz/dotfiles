;; =================
;; | Emacs init.el |
;; =================
;;
;; ※秘伝のソースにならないようコメントを書くこと

(package-initialize) ;; packageの初期化

(setq load-path (append '("~/.emacs.d/conf") load-path)) ;; 分割ファイルの読み込み
(load "load-repo") ;; リポジトリのロード
(load "common")    ;; 基本設定
(load "rainbow-mode-init") ;; rainbow-modeの設定
(load "auto-complete-init") ;; auto-completeの設定
(load "smartparens-config-init") ;; smartparens-configの設定
(load "emmet-mode-init") ;; emmet-modeの設定
(load "smooth-scroll-init") ;; smooth-scrollの設定
(load "web-init") ;; web-modeの設定
(load "markdown-mode-init") ;; markdown-modeの設定
(load "neotree-init") ;; neotreeの設定
(load "undo-tree-init.el") ;;undo-treeの設定
(load "latex-init") ;; latex記述環境の設定
(load "powerline-init") ;; powerlineの設定
(load "magit-init") ;; magitの設定
(load "typescript-mode-init") ;; typescript-modeの設定
(load "flycheck-init") ;; flycheck関係の設定
(load "term-init") ;; term関係の設定
(load "diminish-init") ;; diminishの設定
(load "helm-init") ;; helmの設定
(load "flyspell-init") ;; flyspell関係の設定
(load "bind-key-init") ;; bind-keyの設定
(load "pdf-view-mode-init") ;; pdf-view-modeの設定
(load "calendar-init") ;; calendar系の設定


(load "keybind")   ;; キーバインドの設定

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#282C34" :foreground "#ABB2BF" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 110 :width normal :foundry "nil" :family "Source Han Code JP"))))
 '(mode-line ((t (:background "#6600ff" :foreground "#ffffff"))))
 '(neo-vc-ignored-face ((t (:foreground "#585858"))))
 '(powerline-active1 ((t (:inherit mode-line :background "#9966ff" :foreground "#fff"))))
 '(powerline-active2 ((t (:inherit mode-line :background "#b9aeff" :foreground "#000"))))
 '(trailing-whitespace ((t (:background "red"))))
 '(whitespace-empty ((t (:foreground "#585858"))))
 '(whitespace-hspace ((t (:foreground "#585858"))))
 '(whitespace-indentation ((t (:foreground "#585858"))))
 '(whitespace-line ((t (:foreground "#585858"))))
 '(whitespace-newline ((t (:foreground "#585858" :weight normal))))
 '(whitespace-space ((t (:foreground "#585858"))))
 '(whitespace-tab ((t (:foreground "#7f7f7f"))))
 '(whitespace-trailing ((t (:foreground "#585858" :weight bold))))
 '(widget-documentation ((t (:foreground "#00cd00"))))
 '(window-divider-first-pixel ((t (:foreground "#585858")))))

;; CUI時のみの設定
(if (not window-system) (progn
  ;; list-face-displayでのcolor設定
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#292c30" :foreground "color-248" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 1 :width normal :foundry "default" :family "源ノ角ゴシック Code JP"))))
 '(custom-button-pressed-unraised ((t (:inherit custom-button-unraised :foreground "color-99"))))
 '(custom-comment-tag ((t (:foreground "color-27"))))
 '(custom-group-tag ((t (:inherit variable-pitch :foreground "color-27" :weight bold :height 1.2))))
 '(custom-state ((t (:foreground "green"))))
 '(custom-variable-tag ((t (:foreground "color-27" :weight bold))))
 '(escape-glyph ((t (:foreground "brightred"))))
 '(font-lock-comment-face ((t (:foreground "color-241"))))
 '(font-lock-function-name-face ((t (:foreground "blue"))))
 '(font-lock-keyword-face ((t (:foreground "color-105"))))
 '(font-lock-string-face ((t (:foreground "brightgreen"))))
 '(font-lock-variable-name-face ((t (:foreground "color-172"))))
 '(fringe ((t (:background "grey95" :foreground "brightblack"))))
 '(highlight ((t (:background "color-238"))))
 '(lazy-highlight ((t (:background "paleturquoise" :foreground "brightblack"))))
 '(link-visited ((t (:inherit link :foreground "brightmagenta"))))
 '(match ((t (:background "yellow1" :foreground "brightblack"))))
 '(minibuffer-prompt ((t (:foreground "color-27"))))
 '(mozc-preedit-selected-face ((t (:foreground "brightwhite" :inverse-video t))))
 '(popup-isearch-match ((t (:background "sky blue" :foreground "brightblack"))))
 '(popup-scroll-bar-background-face ((t (:background "gray" :foreground "brightblack"))))
 '(region ((t (:background "color-59"))))
 '(secondary-selection ((t (:background "yellow1" :foreground "brightblack"))))
 '(shadow ((t (:foreground "brightwhite"))))
 '(show-paren-match ((t (:background "blue"))))
 '(show-paren-mismatch ((t (:background "purple"))))
 '(sp-wrap-overlay-opening-pair ((t (:inherit sp-wrap-overlay-face :foreground "color-22"))))
 '(success ((t (:foreground "green" :weight bold))))
 '(tool-bar ((t (:foreground "brightblack" :box (:line-width 1 :style released-button)))))
)
))
;; ここまで

;; GUI時のみの設定
(if window-system (progn
  (load-theme 'atom-one-dark t) ;; atom-one-darkテーマの適用

  ;; yascrollの設定
  (scroll-bar-mode 0)
  (require 'yascroll)
  (global-yascroll-bar-mode 1)
  ;; ここまで
))
;; ここまで

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flycheck-disabled-checkers (quote (javascript-jshint javascript-jscs)))
 '(neo-vc-integration (quote (face char)))
 '(package-selected-packages
   (quote
    (company calfw howm go-mode bind-key term+mux helm expand-region diminish less-css-mode term+ init-loader yatex pdf-tools exec-path-from-shell typescript-mode flycheck yascroll atom-one-dark-theme magit markdown-mode smooth-scroll smartparens rainbow-mode powerline neotree mozc evil emmet-mode auto-complete all-the-icons))))

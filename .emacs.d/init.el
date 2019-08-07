;; =================
;; | Emacs init.el |
;; =================

(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

(package-initialize) ;; initialize package
(setq load-path (append '("~/.emacs.d/conf") load-path)) ;; append to load-path
(load "load-repo") ;; load repository config directly
(init-loader-load) ;; load el with init-loader

;; common(CUI or GUI) face config
;; by list-face-display command
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#282C34" :foreground "#ABB2BF" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 110 :width normal :foundry "nil" :family "Source Han Code JP"))))
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

;; only GUI config
(if window-system (progn
  (load-theme 'atom-one-dark t) ;; enable atom-one-dark theme

  ;; disable scroll bar
  (scroll-bar-mode 0)
))
;; end of block

;; only CUI config
(if (not window-system) (progn
  (custom-set-faces
   ;; custom-set-faces was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   '(default ((t (:inherit nil :stipple nil :background "#292c30" :foreground "color-248" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 1 :width normal :foundry "default" :family "Source Han Code JP"))))
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
;; end of block

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(eclim-eclipse-dirs (quote ("/Applications/Eclipse_Java.app")))
 '(eclim-executable
   "/Applications/Eclipse_Java.app/Contents/Eclipse/plugins/org.eclim_2.8.0/bin/eclim")
 '(eclimd-default-workspace "~/eclipse-workspace")
 '(flycheck-disabled-checkers (quote (javascript-jshint javascript-jscs)))
 '(neo-vc-integration (quote (face char)))
 '(package-selected-packages
   (quote
    (let-alist lsp-ui doom-modeline smart-tab company-emacs-eclim eclim ripgrep lsp-mode company-lsp migemo ein dockerfile-mode which-key undo-tree web-mode yaml-mode company calfw howm go-mode bind-key term+mux helm expand-region diminish less-css-mode term+ init-loader yatex exec-path-from-shell typescript-mode atom-one-dark-theme magit markdown-mode smartparens rainbow-mode powerline neotree mozc emmet-mode auto-complete all-the-icons))))

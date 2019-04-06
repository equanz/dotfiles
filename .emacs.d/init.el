;; =================
;; | Emacs init.el |
;; =================

(package-initialize) ;; initialize package
(setq load-path (append '("~/.emacs.d/conf") load-path)) ;; append to load-path
(load "load-repo") ;; load repository config directly
(init-loader-load) ;; load el with init-loader

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
    (company-emacs-eclim eclim smart-tab ein dockerfile-mode which-key undo-tree web-mode yaml-mode company calfw howm go-mode bind-key term+mux helm expand-region diminish less-css-mode term+ init-loader yatex exec-path-from-shell typescript-mode flycheck atom-one-dark-theme magit markdown-mode smooth-scroll smartparens rainbow-mode powerline neotree mozc emmet-mode auto-complete all-the-icons))))
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

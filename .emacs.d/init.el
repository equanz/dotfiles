;; =================
;; | Emacs init.el |
;; =================

(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;; use straight.el for package management
(setq package-enable-at-startup nil)
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; install use-package
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;; install and setup init-loader
(use-package init-loader
  :init
  (setq init-loader-show-log-after-init 'error-only)
  :config
  ;; load el with init-loader
  (init-loader-load))

;; common(CUI or GUI) face config
;; by list-face-display command
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#282C34" :foreground "#ABB2BF" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 110 :width normal :foundry "nil" :family "Source Han Code JP"))))
 '(lsp-ui-sideline-global ((t (:background "#031A25"))))
 '(neo-vc-ignored-face ((t (:foreground "#585858"))))
 '(powerline-active1 ((t (:inherit mode-line :background "#9966ff" :foreground "#fff"))))
 '(powerline-active2 ((t (:inherit mode-line :background "#b9aeff" :foreground "#000"))))
 '(trailing-whitespace ((t (:background "red"))))
 '(treemacs-root-face ((t (:inherit font-lock-constant-face :underline t :weight bold))))
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
  ;; enable atom-one-dark theme
  (use-package atom-one-dark-theme
    :config
    (load-theme 'atom-one-dark t))

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
 '(flycheck-disabled-checkers
   '(javascript-jshint javascript-jscs emacs-lisp-checkdoc chef-foodcritic))
 '(neo-vc-integration '(face char)))

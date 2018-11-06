;; 言語,文字コード
(setq language-environment 'Japanese)
(prefer-coding-system 'utf-8)
;; ここまで

;; バックアップファイルを作成しない
(setq make-backup-files nil)
(setq auto-save-default nil)
;; ここまで

;; Syntax Highlightの設定
(global-font-lock-mode t)
(setq font-lock-maximum-decoration nil)
;; ここまで

(global-linum-mode t) ;; 行番号を表示
(global-hl-line-mode t) ;; 現在行をハイライト
(setq scroll-step 3) ;; スクロールを3行ずつ
(show-paren-mode t) ;; 対応する括弧をハイライト
(setq show-paren-style 'mixed) ;; 括弧のハイライトの設定
(transient-mark-mode t) ;; 選択範囲をハイライト
(electric-indent-mode 0) ;; 改行時の自動インデント
(fset 'yes-or-no-p 'y-or-n-p) ;; change (yes-no) to (y-n)
(tool-bar-mode -1) ;; hide toolbar
(setq inhibit-startup-message t) ;; ignore startup screen
(global-auto-revert-mode 1) ;; autorevert when file changed
(setq ring-bell-function 'ignore) ;; ignore beep
;; オートインデントでタブを使用しない
(setq-default indent-tabs-mode nil)
(setq indent-line-function 'indent-relative-maybe)
;; ここまで
;; タブサイズをデフォルトで2
(setq-default tab-width 2)
(setq default-tab-width 2)
(setq tab-stop-list '(2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50 52 54 56 58 60))
;; ここまで

;; 日付の表示
(setq display-time-day-and-date t)
(setq display-time-string-forms
 '((format "%s/%s/%s(%s) %s:%s" year month day dayname 24-hours minutes
   )))

(display-time)
;; ここまで

;;環境変数をシェルから引き継ぐ
(require 'exec-path-from-shell)
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))
;; ここまで

;; 不可視文字の表示
(global-whitespace-mode t)
(setq whitespace-style '(space-mark tab-mark face spaces trailing))
(setq whitespace-display-mappings
  '(
    (trailing ?\n    [?¬ ?\n] [?$ ?\n])    ; end-of-line
    (tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t]) ; tab - left quote mark
    (space-mark   ?\     [?\u00B7]     [?.]) ; space - centered dot
  ))

(set-face-attribute 'whitespace-trailing nil
                    :foreground "#585858")

;; ここまで

;; whitespaceの補完, 削除
(setq whitespace-action '(auto-cleanup))

(add-hook 'markdown-mode-hook
          '(lambda ()
             (set (make-local-variable 'whitespace-action) nil)))
;; ここまで

(setq-default require-final-newline t) ;; final-newlineの設定

;; hoge
(if window-system (progn
(if (eq system-type 'darwin)
    mouse-wheel-scroll-amount '(1 ((shift) . 2) ((control)))
    ;; マウススクロールの速度を無視
    (setq mouse-wheel-progressive-speed nil))


  ;; ここまで
))


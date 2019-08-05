;; set langugage, encoding
(setq language-environment 'Japanese)
(prefer-coding-system 'utf-8)

;; ignore backup files
(setq make-backup-files nil)
(setq auto-save-default nil)

;; show syntax highlight
(global-font-lock-mode t)
(setq font-lock-maximum-decoration nil)

 ;; show line number
(if (version<= "26.0.50" emacs-version)
    (global-display-line-numbers-mode t)
  (global-linum-mode t))
 ;; highlight current line
(global-hl-line-mode t)
 ;; scroll by 1 step
;(setq scroll-step 1)
(setq scroll-conservatively 1)
 ;; highlight pair brackets
(show-paren-mode t)
(setq show-paren-style 'mixed)
 ;; highlight selected region
(transient-mark-mode t)
 ;; auto indent
(electric-indent-mode 0)
 ;; change (yes-no) to (y-n)
(fset 'yes-or-no-p 'y-or-n-p)
 ;; hide toolbar
(tool-bar-mode -1)
 ;; ignore startup screen
(setq inhibit-startup-message t)
 ;; autorevert when file changed
(global-auto-revert-mode 1)
 ;; ignore beep
(setq ring-bell-function 'ignore)

;; ignore tab indent by default
(setq-default indent-tabs-mode nil)
(setq indent-line-function 'indent-relative-maybe)

;; set default indent space size to 2
(setq-default tab-width 2)
(setq default-tab-width 2)
(setq tab-stop-list '(2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50 52 54 56 58 60))

;; format of date
(setq display-time-day-and-date t)
(setq display-time-string-forms
 '((format "%s/%s/%s(%s) %s:%s" year month day dayname 24-hours minutes
   )))

(display-time)

;; use env from shell
(require 'exec-path-from-shell)
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; show invisible characters
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


;; auto cleanup whitespace
(setq whitespace-action '(auto-cleanup))
;; config of final-newline
(setq-default require-final-newline t)

;; scroll config on macOS
(if window-system
    (progn
      (if (eq system-type 'darwin)
          mouse-wheel-scroll-amount '(1 ((shift) . 2) ((control)))
          (setq mouse-wheel-progressive-speed nil))))


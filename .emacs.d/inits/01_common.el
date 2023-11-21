;; set langugage, encoding
(setq language-environment 'Japanese)
(prefer-coding-system 'utf-8)

(setq default-input-method "MacOSX")

;; ignore backup files
(setq make-backup-files nil)
(setq auto-save-default nil)

;; show syntax highlight
(global-font-lock-mode t)
(setq font-lock-maximum-decoration '((t . 2)))

;; show line number
(if (version<= "26.0.50" emacs-version)
    (progn
      (setq-default display-line-numbers-width 3)
      (global-display-line-numbers-mode t))
  (global-linum-mode t))
;; highlight current line
(global-hl-line-mode t)
;; scroll by 1 step
(setq scroll-step 1)
(setq scroll-conservatively 10000)
(setq auto-window-vscroll nil)
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
(setq tab-stop-list (number-sequence 2 60 2))

;; format of date
(setq display-time-day-and-date t)
(setq display-time-string-forms
 '((format "%s/%s/%s(%s) %s:%s" year month day dayname 24-hours minutes
   )))

(display-time)

;; use env from shell
(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :config
  (exec-path-from-shell-initialize))

;; show invisible characters
(setq whitespace-style '(face newline spaces tabs trailing newline-mark space-mark tab-mark trailing-mark))
(setq whitespace-display-mappings
  '(
    (newline-mark ?\n [?\u00AC ?\n]) ; newline - not sign
    (tab-mark ?\t [?\u00BB ?\t]) ; tab - right-pointing double angle quotation mark
    (space-mark ?\ [?\u00B7]) ; space - middle dot
  ))
(global-whitespace-mode t)

;; auto cleanup whitespace
(setq whitespace-action '(auto-cleanup))
;; config of final-newline
(setq-default require-final-newline t)

;; disable eol conversion
(setq inhibit-eol-conversion t)

;; scroll config on macOS
(if window-system
    (progn
      (if (eq system-type 'darwin)
          mouse-wheel-scroll-amount '(1 ((shift) . 2) ((control)))
          (setq mouse-wheel-progressive-speed nil))))

;; fonts
(use-package all-the-icons)
(use-package nerd-icons)

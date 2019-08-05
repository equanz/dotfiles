(require 'package)

;; add MELPA to list
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; add MELPA-stable to list
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(package-initialize)

(package-refresh-contents)

;; package list
(defvar my-packages
  '(
    ;; installed
    all-the-icons
    atom-one-dark-theme
    auto-complete
    bind-key
    calfw
    company
    company-emacs-eclim
    company-lsp
    diminish
    dockerfile-mode
    eclim
    ein
    emmet-mode
    exec-path-from-shell
    expand-region
    flycheck
    go-mode
    helm
    howm
    init-loader
    less-css-mode
    lsp-mode
    lsp-ui
    magit
    markdown-mode
    migemo
    mozc
    neotree
    powerline
    rainbow-mode
    ripgrep
    smart-tab
    smartparens
    term+
    term+mux
    typescript-mode
    undo-tree
    web-mode
    which-key
    yaml-mode
    yatex
  ))

;; (require 'request)

;; check the connection to MELPA
;; (defun can-retreive-packages ()
;;   (setq status "ponyanza")
;;   (request "https://melpa.org/packages/"
;;            :parser 'buffer-string
;;            :timeout 5
;;            :error (lambda (&rest _) (setf status nil))
;;            :success (lambda (&rest _) (setf status t)))
;;   status)

;; (message status)

;; (can-retreive-packages)

;; (if (can-retreive-packages) "true" "false")


;; my-packagesからパッケージをインストール
(dolist (package my-packages)
  (unless (package-installed-p package)
    (package-install package)))


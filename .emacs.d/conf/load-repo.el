(require 'package)

;; MELPAを追加
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
;; MELPA-stableを追加
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)

(package-initialize)

(package-refresh-contents)

;; インストールするパッケージ
(defvar my-packages
  '(
    ;; dependency
    async
    dash
    epl
    font-lock+
    git-commit
    goto-chg
    helm-core
    magit-popup
    memoize
    pkg-info
    popup
    tab-group
    tablist
    undo-tree
    web-mode
    with-editor

    ;; installed
    all-the-icons
    atom-one-dark-theme
    auto-complete
    bind-key
    calfw
    company
    diminish
    emmet-mode
    evil
    exec-path-from-shell
    expand-region
    flycheck
    go-mode
    helm
    howm
    init-loader
    less-css-mode
    magit
    markdown-mode
    mozc
    neotree
    pdf-tools
    powerline
    rainbow-mode
    smartparens
    smooth-scroll
    term+
    term+mux
    typescript-mode
    web-mode
    yascroll
    yatex
  ))

;; my-packagesからパッケージをインストール
(dolist (package my-packages)
  (unless (package-installed-p package)
    (package-install package)))


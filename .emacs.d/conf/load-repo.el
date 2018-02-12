(require 'package)

;; MELPAを追加
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; MELPA-stableを追加
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(package-initialize)

(package-refresh-contents)

;; インストールするパッケージ
(defvar my-packages
  '(
    ;; dependency
    async
    dash
    epl
    ghub
    git-commit
    helm-core
    let-alist
    magit-popup
    memoize
    pkg-info
    popup
    tab-group
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
    powerline
    rainbow-mode
    smartparens
    smooth-scroll
    term+
    term+mux
    typescript-mode
    undo-tree
    web-mode
    which-key
    yaml-mode
    yatex
  ))

;; my-packagesからパッケージをインストール
(dolist (package my-packages)
  (unless (package-installed-p package)
    (package-install package)))


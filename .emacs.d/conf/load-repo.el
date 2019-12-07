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
    company-lsp
    diminish
    dockerfile-mode
    doom-modeline
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

;; (setq lexical-binding t)

;; (require 'url)
;; ;; callbackの時点でこの関数の返り値として定義できない
;; (defun is-archive-alive (archives)
;;   (if (null archive-list)
;;       t
;;     (url-retrieve (cdr (car archive-list))
;;                   #'(lambda (status)
;;                       (if (null (assoc 'error status))
;;                           (ris-archive-alive (cdr archive-list))
;;                         nil)))))
;; (labels ((rec (archive-list)
;;               (if (null archive-list)
;;                   t
;;                 (url-retrieve (cdr (car archive-list))
;;                               #'(lambda (status)
;;                                   (if (null (assoc 'error status))
;;                                       (rec (cdr archive-list))
;;                                     nil))))))
;;   (rec archives))

;; (print (is-archive-alive package-archives))

;; (url-retrieve (cdr (car package-archives))
;;               #'(lambda (status)
;;                   (if (null (assoc 'error status))
;;                       (print "foo")
;;                     nil)))

;; (defun our-length (lst)
;;   (labels ((rec (lst acc)
;;            (if (null lst)
;;                acc
;;                (rec (cdr lst) (1+ acc)))))
;;     (rec lst 0)))

;; (our-length '(1 2 3 4))

; (require 'request)

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


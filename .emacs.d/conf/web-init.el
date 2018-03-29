;; web-modeの設定
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.json\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.js[x]?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.css\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.vue\\'" . web-mode))

(setq web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'")))
(setq web-mode-content-types-alist '(("json" . "\\.json\\'")))

(setq web-mode-engines-alist
      '(("php"    . "\\.phtml\\'")
        ("blade"  . "\\.blade\\."))
)

(defun web-mode-indent (num)
  (interactive "nIndent: ")
  (setq web-mode-markup-indent-offset num)
  (setq web-mode-css-indent-offset num)
  (setq web-mode-style-padding num)
  (setq web-mode-code-indent-offset num)
  (setq web-mode-script-padding num)
  (setq web-mode-block-padding num)
)
(web-mode-indent 2)

;; タグの自動補完
(setq web-mode-auto-close-style 2)
(setq web-mode-tag-auto-close-style 2)
(setq web-mode-enable-auto-pairing nil)
;; ここまで
;; ここまで

;; less-css-modeの設定
(require 'less-css-mode)
;; ここまで

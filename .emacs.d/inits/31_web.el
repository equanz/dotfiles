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

;; set indent size to 2
(let ((offset 2))
  (setq web-mode-markup-indent-offset offset)
  (setq web-mode-css-indent-offset offset)
  (setq web-mode-style-padding offset)
  (setq web-mode-code-indent-offset offset)
  (setq web-mode-script-padding offset)
  (setq web-mode-block-padding offset))

;; disable auto indent
(setq web-mode-enable-auto-indentation nil)

;; autocomplete tag
(setq web-mode-auto-close-style 2)
(setq web-mode-tag-auto-close-style 2)
(setq web-mode-enable-auto-pairing nil)

;; less-css-mode config
(require 'less-css-mode)

;; lsp config
(add-hook 'web-mode-hook
          (lambda () (when (and (stringp buffer-file-name)
                                (or (string-match "\\.js\\'" buffer-file-name))) (lsp-deferred))))

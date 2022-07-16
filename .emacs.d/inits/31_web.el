(use-package web-mode
  :init
  (setq web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'")))
  (setq web-mode-content-types-alist '(("json" . "\\.json\\'")))
  (setq web-mode-engines-alist
        '(("php"    . "\\.phtml\\'")
          ("blade"  . "\\.blade\\.")))
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
  ;; use lsp-mode
  (add-hook 'web-mode-hook
            (lambda () (when (and (stringp buffer-file-name)
                                  (or (string-match "\\.js\\'" buffer-file-name)))
                         (lsp-deferred))))
  :mode (("\\.html\\'" . web-mode)
         ("\\.json\\'" . web-mode)
         ("\\.js[x]?\\'" . web-mode)
         ("\\.phtml\\'" . web-mode)
         ("\\.tpl\\.php\\'" . web-mode)
         ("\\.[agj]sp\\'" . web-mode)
         ("\\.as[cp]x\\'" . web-mode)
         ("\\.erb\\'" . web-mode)
         ("\\.mustache\\'" . web-mode)
         ("\\.djhtml\\'" . web-mode)
         ("\\.css\\'" . web-mode)
         ("\\.vue\\'" . web-mode))
  )

(use-package less-css-mode)

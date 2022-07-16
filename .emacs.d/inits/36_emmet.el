(use-package emmet-mode
  :init
  ;; use emmet-mode in any markup languages and css
  (add-hook 'sgml-mode-hook 'emmet-mode)
  (add-hook 'css-mode-hook 'emmet-mode)
  :config
  (setq emmet-indentation 2) ;; set indent
  :bind (:map emmet-mode-keymap
         ("C-j" . nil)))

(require 'emmet-mode)

;; use emmet-mode in any markup languages and css
(add-hook 'sgml-mode-hook 'emmet-mode)
(add-hook 'css-mode-hook 'emmet-mode)

;; set indent
(add-hook 'emmet-mode-hook (lambda () (setq emmet-indentation 2)))

(eval-after-load "emmet-mode"
  '(bind-key "C-j" nil emmet-mode-keymap))

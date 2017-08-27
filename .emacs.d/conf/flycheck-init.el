(require 'flycheck)

(add-hook 'after-init-hook #'global-flycheck-mode)

;; web-modeへの適用
(add-hook 'web-mode-hook
          (lambda ()
            (when (equal web-mode-content-type "jsx")
              (flycheck-add-mode 'javascript-eslint 'web-mode)
              (flycheck-mode))))

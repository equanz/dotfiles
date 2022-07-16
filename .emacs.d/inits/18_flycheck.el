(use-package flycheck
  :init
  (add-hook 'after-init-hook #'global-flycheck-mode)
  ;; apply flycheck to web-mode
  (add-hook 'web-mode-hook
            (lambda ()
              (when (equal web-mode-content-type "jsx")
                (flycheck-add-mode 'javascript-eslint 'web-mode)
                (flycheck-mode)))))

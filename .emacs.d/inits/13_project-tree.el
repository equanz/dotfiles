(use-package all-the-icons)
(use-package treemacs
  :init
  (setq treemacs-width 35)
  (setq treemacs--width-is-locked nil)
  (setq treemacs-width-is-initially-locked nil)
  ;; disable line numbers
  (add-hook 'treemacs-mode-hook #'(lambda () (display-line-numbers-mode -1)))
  :config
  (treemacs-resize-icons 15)
  (treemacs-follow-mode -1)
  :bind (("C-c o" . treemacs-select-window)
         :map treemacs-mode-map
         ("C-c c" . treemacs-select-directory)
         ("<SPC>" . treemacs-TAB-action)))

(use-package projectile
  :bind (("C-c C-f" . projectile-find-file)
         ("C-c C-d" . projectile-find-dir)))
(use-package treemacs-projectile)

(use-package all-the-icons)
(use-package treemacs
  :commands (treemacs-select-window)
  :init
  (setq treemacs-width 35)
  (setq treemacs--width-is-locked nil)
  (setq treemacs-width-is-initially-locked nil)
  ;; disable line numbers
  (add-hook 'treemacs-mode-hook #'(lambda () (display-line-numbers-mode -1)))
  :config
  (treemacs-resize-icons 15)
  :bind (("C-c o" . treemacs-select-window)
         :map treemacs-mode-map
         ("C-c c" . treemacs-select-directory)
         ("<SPC>" . treemacs-TAB-action)))

(use-package projectile
  :bind (("C-c C-f" . projectile-find-file)
         ("C-c C-d" . projectile-find-dir)))
(use-package treemacs-projectile
  :commands (projectile-project-root projectile-find-file projectile-find-dir helm-do-ag-projectile))

;; (require 'all-the-icons)

;; (require 'neotree)

;; ;; keymap
;; (bind-key "<f8>" 'neotree-toggle)
;; (bind-key* "C-c o" 'neotree-show)
;; (bind-key "C-u" 'neotree-select-up-and-unfold-node neotree-mode-map)  ;; unfold parent directory
;; (bind-key "C-c C-o" 'neotree-open-command neotree-mode-map) ;; shell open

;; ;; option
;; (setq neo-show-hidden-files t)
;; (setq neo-theme (if (display-graphic-p) 'icons 'arrow))

;; (neotree-show)

;; ;; util functions
;; (defun neotree-select-up-and-unfold-node ()
;;   "select-up node and unfold"
;;   (interactive)
;;   (neotree-select-up-node)
;;   (neotree-quick-look)
;; )

;; (defun neotree-open-command ()
;;   "shell open command"
;;   (interactive)
;;   (shell-command "open ./")
;; )

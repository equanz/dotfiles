(use-package helm-ag
  :init
  (setq helm-ag-base-command "rg --no-heading --hidden --glob=!.git/")
  (setq helm-ag-success-exit-status '(0 2))
  :bind (("C-c C-g" . helm-do-ag-projectile)))

(defun helm-do-ag-projectile (&optional query)
  "search on projectile root"
  (interactive)
  (unless (projectile-project-root)
    (error "Could not find the projectile root."))
  (helm-do-ag (projectile-project-root) nil query))

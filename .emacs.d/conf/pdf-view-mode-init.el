(if (eq system-type 'darwin)
  (pdf-tools-install)
  (add-to-list 'auto-mode-alist '("\\.pdf\\'" . pdf-view-mode)) ;; major modeの変更

  (setq doc-view-resolition 300))


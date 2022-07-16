(use-package undo-tree
  :init
  (global-undo-tree-mode t)
  (setq undo-tree-auto-save-history nil)
  :bind (("C-S-Z" . undo-tree-redo))
)

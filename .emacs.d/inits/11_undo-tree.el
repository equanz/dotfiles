;; undo-treeの設定
(require 'undo-tree)
(global-undo-tree-mode t)
(setq undo-tree-auto-save-history nil)
(bind-key "C-S-Z" 'undo-tree-redo)
;; ここまで

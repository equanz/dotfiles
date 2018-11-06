;; undo-treeの設定
(require 'undo-tree)
(global-undo-tree-mode t)
(bind-key "C-S-Z" 'undo-tree-redo)
;; ここまで

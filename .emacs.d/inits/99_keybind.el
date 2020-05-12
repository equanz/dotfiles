(require 'expand-region)

(bind-key* "C-h" 'backward-delete-char-untabify) ;; BackSpace
(bind-key "C-z" 'undo)        ;; Undo
;(bind-key "C-j" 'newline) ;; newline

(bind-key "M-," 'xref-find-references)
(bind-key "M-/" 'xref-pop-marker-stack)
(bind-key "M-?" 'dabbrev-expand)


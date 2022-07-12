(require 'expand-region)

(bind-key* "C-h" 'backward-delete-char-untabify) ;; BackSpace
(bind-key "C-z" 'undo)        ;; Undo
(bind-key* "C-y" (lambda () (interactive) (yank) (call-interactively 'indent-region))) ;; yank and indent

(bind-key* "<C-wheel-up>" 'ignore)
(bind-key* "<C-wheel-down>" 'ignore)

(bind-key "M-," 'xref-find-references)
(bind-key "M-/" 'xref-pop-marker-stack)
(bind-key "M-?" 'dabbrev-expand)

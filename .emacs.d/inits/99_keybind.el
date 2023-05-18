(bind-key* "C-h" 'backward-delete-char-untabify) ;; BackSpace
(bind-key "C-z" 'undo) ;; Undo
(bind-key "C-S-y" #'(lambda () (interactive) (yank) (call-interactively 'indent-region))) ;; yank and indent
(bind-key "C-x C-c" #'(lambda () (interactive) (if (y-or-n-p (format "Kill Emacs?")) (save-buffers-kill-emacs) (message "Aborted."))))

(bind-key* "<C-wheel-up>" 'ignore)
(bind-key* "<C-wheel-down>" 'ignore)

(bind-key "s-q" nil)
(bind-key "s-w" nil)

;; expand current window to specific direction
;; can't shrink current window directly
(bind-key "C-S-n" #'(lambda () (interactive) (adjust-window-trailing-edge (selected-window) 1)))
(bind-key "C-S-p" #'(lambda () (interactive) (let ((w (window-in-direction 'above (selected-window)))) (when w (adjust-window-trailing-edge w -1)))))
(bind-key "C-S-f" #'(lambda () (interactive) (adjust-window-trailing-edge (selected-window) 1 t)))
(bind-key "C-S-b" #'(lambda () (interactive) (let ((w (window-in-direction 'left (selected-window)))) (when w (adjust-window-trailing-edge w -1 t)))))

(bind-key "M-," 'xref-find-references)
(bind-key "M-/" 'xref-pop-marker-stack)
(bind-key "M-?" 'dabbrev-expand)

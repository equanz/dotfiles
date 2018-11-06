(require 'term+)
(require 'term+mux)

;; delete from C-d
(bind-key "C-d" 'term-send-backspace)
;; launch term+mux-new from C-c t
(bind-key "C-c t" 'term+mux-new)


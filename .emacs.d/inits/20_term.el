(require 'term+)
(require 'term+mux)

;; keybind
(bind-key "C-h" 'term-send-backspace)
(bind-key "C-c t" 'term+mux-new)

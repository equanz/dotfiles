(require 'company)
(add-hook 'after-init-hook 'global-company-mode)

(setq company-selection-wrap-around t) ; go to next of eol, then go to bol

;; keybinds
(bind-key "M-n" 'nil company-active-map)
(bind-key "M-p" 'nil company-active-map)
(bind-key "C-n" 'company-select-next company-active-map)
(bind-key "C-p" 'company-select-previous company-active-map)


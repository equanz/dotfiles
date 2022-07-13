;; use aspell
(setq-default ispell-program-name "aspell")

;; skip Japanese
(eval-after-load "ispell"
 '(add-to-list 'ispell-skip-region-alist '("[^\000-\377]+")))

;; apply ispell to yatex-mode
(add-hook 'yatex-mode-hook' flyspell-mode)

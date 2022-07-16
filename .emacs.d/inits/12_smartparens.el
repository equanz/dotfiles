(use-package smartparens
  :config
  (sp-pair "<" nil :actions :rem) ;; ignore autocomplete('<', '>')
  (sp-pair "「" "」") ;; pairing ('「', '」')
  ;; ignore autoremove pair
  (ad-disable-advice 'delete-backward-char 'before 'sp-delete-pair-advice)
  (ad-activate 'delete-backward-char)

  (smartparens-global-mode t))

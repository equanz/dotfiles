(use-package visual-regexp-steroids
  :init
  (use-package pcre2el)
  (setq vr/engine 'pcre2el)
  (use-package visual-regexp
    :bind (("C-M-%" . vr/query-replace)
           ("C-M-s" . vr/isearch-forward)
           ("C-M-r" . vr/isearch-backward))))

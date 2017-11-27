(require 'yatex)

;; *.texの場合にyatex-modeを起動
(add-to-list 'auto-mode-alist '("\\.tex\\'" . yatex-mode))
(autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)
;; ここまで

;; YaTeXの括弧補完を切る
;(setq YaTeX-modify-mode 'nil)
;(setq YaTeX-close-paren-always 'never)
;; ここまで

;; YaTeX のコマンド定義
;; TeXShopの使用
(setq tex-command "platex")
(setq dviprint-command-format "dvipdfmx %s")

(setq dvi2-command "open -a Skim")
(defvar YaTeX-dvi2-command-ext-alist
  '(("xdvi" . ".dvi")
      ("ghostview\\|gv" . ".ps")
      ("acroread\\|pdf\\|Preview\\|open" . ".pdf")))

;; set intelligent-newline keymap (M-j)
(bind-key "M-j" 'YaTeX-intelligent-newline YaTeX-mode-map)

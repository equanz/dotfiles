;; powerlineの設定
(require 'powerline)

;; return eol type as string
(defun get-buffer-file-eol-type ()
  (case (coding-system-eol-type buffer-file-coding-system)
    (0 "LF")
    (1 "CRLF")
    (2 "CR")
    (otherwise "??")))

;; return coding type as string
(defun get-buffer-coding-type-without-eol-type ()
  (labels
      ((remove-os-info (string)
                       (replace-regexp-in-string "-\\(dos\\|unix\\|mac\\)$" "" string)))
    (lexical-let
        ((string
          (replace-regexp-in-string "-with-signature" "(bom)"
                                    (remove-os-info  (symbol-name buffer-file-coding-system)))))
      (if (string-match-p "(bom)" string)
          (downcase string)
        (upcase string)))))

;; show eol type and coding type
(defpowerline powerline-coding-type
   (concat (get-buffer-coding-type-without-eol-type) "[" (get-buffer-file-eol-type) "]"))

;; setup powerline theme based on powerline-center-theme
(defun powerline-my-theme ()
  "Setup a mode-line with major and minor modes centered."
  (interactive)
  (setq-default mode-line-format
    '("%e"
      (:eval
       (let* ((active (powerline-selected-window-active))
                          (mode-line-buffer-id (if active 'mode-line-buffer-id 'mode-line-buffer-id-inactive))
        (mode-line (if active 'mode-line 'mode-line-inactive))
                          (face0 (if active 'powerline-active0 'powerline-inactive0))
        (face1 (if active 'powerline-active1 'powerline-inactive1))
        (face2 (if active 'powerline-active2 'powerline-inactive2))
        (separator-left (intern (format "powerline-%s-%s"
                (powerline-current-separator)
                (car powerline-default-separator-dir))))
        (separator-right (intern (format "powerline-%s-%s"
                 (powerline-current-separator)
                 (cdr powerline-default-separator-dir))))
        (lhs (list (powerline-coding-type nil 'l)
             (powerline-raw "%*" face0 'l)
             (powerline-buffer-size face0 'l)
             (powerline-buffer-id `(mode-line-buffer-id ,face0) 'l)
             (powerline-raw " ")
             (funcall separator-left face0 face1)
             (powerline-narrow face1 'l)
             (powerline-vc face1)))
        (rhs (list (powerline-raw global-mode-string face1 'r)
             (powerline-raw "%4l" face1 'r)
             (powerline-raw ":" face1)
             (powerline-raw "%3c" face1 'r)
             (funcall separator-right face1 face0)
             (powerline-raw " ")
             (powerline-raw "%6p" face0 'r)
             (powerline-hud face2 face1)
             (powerline-fill face0 0)))
        (center (list (powerline-raw " " face1)
          (funcall separator-left face1 face2)
          (when (and (boundp 'erc-track-minor-mode) erc-track-minor-mode)
            (powerline-raw erc-modified-channels-object face2 'l))
          (powerline-major-mode face2 'l)
          (powerline-process face2)
          (powerline-raw " :" face2)
          (powerline-minor-modes face2 'l)
          (powerline-raw " " face2)
          (funcall separator-right face2 face1))))
         (concat (powerline-render lhs)
           (powerline-fill-center face1 (/ (powerline-width center) 2.0))
           (powerline-render center)
           (powerline-fill face1 (powerline-width rhs))
(powerline-render rhs)))))))

;; setup face
(powerline-my-theme)
(setq powerline-default-separator "wave")

(setq ns-use-srgb-colorspace nil)
;; ここまで


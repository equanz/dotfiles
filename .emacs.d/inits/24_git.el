(use-package git-gutter
  :init
  (setq git-gutter:update-hooks '(after-save-hook after-revert-hook))
  (global-git-gutter-mode t)
  :bind (:map git-gutter-mode-on-hook
         ("C-c C-p" . git-gutter-toggle-hunk-in-posframe)))

(defun git-gutter-toggle-hunk-in-posframe ()
  (interactive)
  (lexical-let ((my-buffer-name "*git-gutter-hunk-posframe*"))
    ;; TODO: Use posframe-hide instead of posframe--kill-buffer.
    ;; TODO: Hide the frame when some operation (e.g. moving cursor, switching buffer) occurred.
    (if (get-buffer my-buffer-name)
        (posframe--kill-buffer my-buffer-name)
      (with-current-buffer (get-buffer-create my-buffer-name)
        (diff-mode))
      (posframe-show my-buffer-name
                     :string (git-gutter-hunk-content (git-gutter:search-here-diffinfo git-gutter:diffinfos))
                     :position (point-at-bol)
                     :border-color "#585858"
                     :border-width 1
                     :max-height 10
                     ))))

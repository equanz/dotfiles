(require 'eclim)
(setq eclimd-autostart t)

(defun my-java-mode-hook ()
    (eclim-mode t))

(add-hook 'java-mode-hook 'my-java-mode-hook)

;; path variables
(custom-set-variables
  '(eclim-eclipse-dirs '("/Applications/Eclipse_Java.app"))
  '(eclim-executable "/Applications/Eclipse_Java.app/Contents/Eclipse/plugins/org.eclim_2.8.0/bin/eclim")
  '(eclimd-default-workspace "~/eclipse-workspace"))

;; Displaying compilation error messages in the echo area
(setq help-at-pt-display-when-idle t)
(setq help-at-pt-timer-delay 0.1)
(help-at-pt-set-timer)

;; company setup
(require 'company-emacs-eclim)
(company-emacs-eclim-setup)


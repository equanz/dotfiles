(use-package image-mode
  :ensure nil
  :hook
  (image-mode . (lambda ()
                  (face-remap-set-base 'default '(:background "white"))
                  (face-remap-set-base 'hl-line '(:background "white"))))
  :bind (:map image-mode-map
              ("<wheel-up>" . image-previous-line)
              ("<wheel-down>" . image-next-line)
              ("<wheel-right>" . image-forward-hscroll)
              ("<wheel-left>" . image-backward-hscroll)))

;;; keybindings.el --- rr/handpicking Layer key-bindings File
;;
;; Copyright (c) 2016 Michelle Baert
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3


;; ------------------------------------------------------------------------
;; Setting keys
;; see also: http://tiny-tools.sourceforge.net/emacs-keys.html
;; see (describe-key) (read-event) (kbd)
;; ------------------------------------------------------------------------
;; Moving around in reference buffer
(global-set-key [C-S-down] 'rr/handpicking-nextline)
(global-set-key [C-S-up]   'rr/handpicking-prevline)
(global-set-key [M-S-up]   'rr/handpicking-lookup)

;; Fix keymap conflicts with org-mode
;(org-defkey org-mode-map [(control shift up)] 'org-shiftcontrolup)
;(org-defkey org-mode-map [(control shift down)]  'org-shiftcontroldown)
(add-hook 'org-mode-hook
          (lambda ()
            (org-defkey org-mode-map [(control shift up)] nil)
            (org-defkey org-mode-map [(control shift down)]  nil)
            ))

;; Copy or move current line from the reference buffer
(global-set-key (kbd "C-@")    'rr/handpicking-copy)
(global-set-key (kbd "C-M-'")  'rr/handpicking-move)

;; If you use french layout keyboard, you might prefer these settings:
;;(global-set-key [C-µ]       'rr/handpicking-copy) ; C-S-*
;;(global-set-key [67111093]  'rr/handpicking-copy) ; C-S-*
;;(global-set-key [C-M-*]     'rr/handpicking-move)     ; C-M-*
;;(global-set-key [201326634] 'rr/handpicking-move)     ; C-M-*

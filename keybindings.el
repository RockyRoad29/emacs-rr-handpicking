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
(global-set-key [C-S-down] 'rr/move-other-window-nextline)
(global-set-key [C-S-up]   'rr/move-other-window-prevline)
(global-set-key [M-S-up]   'rr/lookup-other-window)
;; (global-set-key [M-s-up] 'rr/lookup-other-window)

;(org-defkey org-mode-map [(control shift up)] 'org-shiftcontrolup)
;(org-defkey org-mode-map [(control shift down)]  'org-shiftcontroldown)
(add-hook 'org-mode-hook
          (lambda ()
            (org-defkey org-mode-map [(control shift up)] nil)
            (org-defkey org-mode-map [(control shift down)]  nil)
))

(global-set-key (kbd "C-@")    'rr/copy-from-other-window-nextline)
(global-set-key (kbd "C-M-'")  'rr/pick-line-from-other-window)

;; If you use french layout keyboard, you might prefer these settings:
;;(global-set-key [C-µ]       'copy-from-other-window-nextline) ; C-S-*
;;(global-set-key [67111093]  'copy-from-other-window-nextline) ; C-S-*
;;(global-set-key [C-M-*]     'pick-line-from-other-window)     ; C-M-*
;;(global-set-key [201326634] 'pick-line-from-other-window)     ; C-M-*

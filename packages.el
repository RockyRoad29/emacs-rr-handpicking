;;; packages.el --- rr/chatting-windows layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author:  <mich@dennet>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `rr/chatting-windows-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `rr/chatting-windows/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `rr/chatting-windows/pre-init-PACKAGE' and/or
;;   `rr/chatting-windows/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:
(defconst rr-chatting-windows-packages
  '(
    (chatting-windows :location local)
    )
  )

(defun rr-chatting-windows/init-chatting-windows ()
    (use-package chatting-windows)
  )

;;; packages.el ends here

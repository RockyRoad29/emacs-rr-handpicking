;;; handpicking.el --- Some tools for working with a reference buffer
;;                     associated with current buffer.

;; Copyright (C) 2018  Michelle Baert

;; Author: Michelle Baert <m dot baert at free dot fr>
;; Keywords:

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary: Complete rewrite of "rr/chatting-windows"

;;

;;; Code:


;; ------------------------------------------------------------------------
;; setup
;; ------------------------------------------------------------------------
;; Make variables automatically buffer-local
(make-variable-buffer-local 'rr/handpicking-source-buffer)
(make-variable-buffer-local 'rr/handpicking-source-window)
;; the only way to change them is #'setq-default
;; (setq-default rr/handpicking-source-buffer nil)


(defun rr/handpicking-set-source-buffer (src)
  "Defines or redefines the source buffer to use for
handpicking to current buffer.

This is a convenience interactive function setting the
buffer-local variable 'rr/handpicking-source-buffer
"
  ;; (interactive "b")
  (interactive
   (list (ido-read-buffer "Switch to buffer: ")))
  (setq rr/handpicking-source-buffer (get-buffer src))
  )


(defun rr/handpicking-activate-source ()
  "Retrieves the current value of the
buffer-local variable 'rr/handpicking-source-buffer,
checks if it is valid and activates corresponding window.
Otherwise, emit a suitable error message for the user.

If buffer is not currently  visible, bring it up in
another window with 'pop-to-buffer .

You'll probably want to save initial active window
to be able to later come back and keep working in your
current (destination) buffer.

Returns:
   - the activated window on success,
   - nil on failure.
"
  (let (
        (src rr/handpicking-source-buffer)
        destw
        )
    (if (and src (bufferp src))
          (setq rr/handpicking-source-window   ; display-buffer returns the window
                (pop-to-buffer
                 src
                 '(display-buffer-reuse-window . ((inhibit-same-window . t)))
                 ))
      ;; else: inform user and return nil
      (message "No source buffer defined for %s, call (rr/handpicking-set-source-buffer) to set it."
               (current-buffer))
      nil
      ))
  )
;; ------------------------------------------------------------------------
;; Moving around
;; ------------------------------------------------------------------------
(defun rr/handpicking-nextline ()
  "Advances the point to next line in the next window."
  (interactive)
  (let (
        (dstw (selected-window))
        (srcw (rr/handpicking-activate-source))
        )
    (when srcw
      (forward-line 1)
      (select-window dstw)
      ))
  )
(defun rr/handpicking-prevline ()
  "Moves the point to previous line in the next window."
  (interactive)
  (let (
        (dstw (selected-window))
        (srcw (rr/handpicking-activate-source))
        )
      (when srcw
        (forward-line -1)
        (select-window dstw)
        ))
  )

;; ------------------------------------------------------------------------
;; Copy sequentially
;; ------------------------------------------------------------------------
(defun rr/handpicking-copy ()
  "Copies current line from source buffer to current point.
Advances the point to next line in source buffer."
  (interactive)
  (let (
        (dstw (selected-window))
        (srcw (rr/handpicking-activate-source))
        line
        )
    (when srcw
      ;; Copy text from source
      (beginning-of-line)
      (setq line (thing-at-point 'line))
      (forward-line)

      ;; Paste copied text in destination
      (select-window dstw)
      (beginning-of-line)
      (insert line)
      )
  ))

(defun rr/handpicking-move (&optional count)
  "Moves current line from source-buffer to current point.
With argument 'count', moves that many lines at once."
  (interactive)
  (if (null count) (setq count 1))
  (let (
        (dstw (selected-window))
        (srcw (rr/handpicking-activate-source))
        line
        )
    (when srcw
      ;; Cut text from source
      (beginning-of-line)
      (kill-line count)                   ; whole line, since count is supplied

    ;; Paste copied text in destination
      (select-window dstw)
      (beginning-of-line)
      (yank)
      ))
  )
;; ------------------------------------------------------------------------
;; Lookup patterns
;; ------------------------------------------------------------------------
(defun rr/handpicking-lookup (fwd)
  "Locates in previous window the pattern currently highlighted
in current window, or the word at point.
With argument, search from current position."
  (interactive "P")                     ; optional prefix argument (C-u)
  (let (
        (pattern                        ; what we are looking for
         (if mark-active
             (buffer-substring (region-beginning) (region-end))
           (current-word)
           ))
        pt                              ; save point in other window
        fnd                             ; found pattern position
        (dstw (selected-window))
        (srcw (rr/handpicking-activate-source))
        )
      ;;    (message "looking for pattern '%s'" pattern)
    (when srcw
      ;; error handling: Regain control when an error is signaled.
      (condition-case err
          (progn
            (setq pt (point))
            (cond
             ((integerp fwd) (goto-char fwd)) ; search from specified position
             (fwd (goto-char (point-min)))    ; search from the beginning
             )
            (if (setq fnd (word-search-forward pattern nil 1))
                (message "'%s' found line %d" pattern (line-number-at-pos))
              (progn (message "'%s' not found" pattern )
                     (goto-char pt)             ; restore previous point
                     ))
            )
        (error
         (message (error-message-string err))
         ))
      (select-window dstw)
      ))
)

(provide 'rr/handpicking)
;;; handpicking.el ends here

;;; chatting-windows.el --- Some macros for working simultaneously in two or more windows.

;; Copyright (C) 2008  Michelle Baert

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

;;; Commentary:

;;

;;; Code:


;; ------------------------------------------------------------------------
;; Moving around
;; ------------------------------------------------------------------------
(defun rr/handpicking-nextline ()
  "Advances the point to next line in the next window."
  (interactive)
  (let (destw)
    (setq destw (selected-window))
    (setq otherw (next-window))
    (select-window (next-window))
    (forward-line)
    (select-window destw)
    )
  )
(defun rr/handpicking-prevline ()
  "Moves the point to previous line in the next window."
  (interactive)
  (let (destw)
    (setq destw (selected-window))
    (setq otherw (next-window))
    (select-window (next-window))
    (forward-line -1)
    (select-window destw)
    )
  )

;; ------------------------------------------------------------------------
;; Copy sequentially
;; ------------------------------------------------------------------------
(defun rr/handpicking-copy ()
  "Copies current line from next window to current point.
Advances the point to next line in othe window."
  (interactive)
  (let (
	(line "")
	(destw)
	(otherw)
	)
    (setq destw (selected-window))
    (setq otherw (next-window))
    (message "coping next line from %s to %s" otherw destw)
    (select-window otherw)
    (beginning-of-line); (setq start (point))
    (setq line (thing-at-point 'line))
;    (message line)
    (forward-line); (setq end (point))
    ;(setq line (buffer-substring start end))

    (select-window destw)
    (insert line)
    )
  )

(defun rr/handpicking-move (&optional count)
  "Moves current line from next window to current point.
With argument 'count', moves that many lines."
  (interactive)
  (if (null count) (setq count 1))
  (let (
	(destw)
	(otherw)
	)
    (setq destw (selected-window))
    (setq otherw (next-window))
    (message "moving next line from %s to %s" otherw destw)
    (save-excursion
      (select-window otherw)
      (beginning-of-line); (setq start (point))
      (kill-line count)                   ; whole line, since count is supplied
      (select-window destw)
      )
    (yank)
    )
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
        )
;    (message "looking for pattern '%s'" pattern)
    (select-window (previous-window))
    ;; error handling
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
    (select-window (next-window))       ; restore window
    ))


(provide 'chatting-windows)
;;; chatting-windows.el ends here

;;; enhanced_tetris.el --- enhandce Tetris for Emacs

;; Author: Felix Völker(LinFelix)
;; Version: 0.0
;; Created: 2017-03-17
;; Keywords: games

;; This file is puplished under the GPL v3

;;; Commentary:

;;; Code:

(require 'tetris)

;; customization variables ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defgroup enhanced-tetris nil
  "normal Tetris is too normal now, Ananass"
  :prefix "ananass-tetris-"
  :group 'games)

(defcustom enhanced-tetris-show-ghost t
  "Non-nil meaans the ghost is shown."
  :group 'enhandced-tetris
  :type 'boolean)

(defcustom enhanced-tetris-show-trajectory t
  "Non-nil means the trajectory is shown."
  :group 'enhanced-tetris
  :type 'boolean)

(defcustom enhanced-tetris-show-past-trajectory t
  "Non-nil means the pest trajectory is shown."
  :group 'enhanced-tetris
  :type 'boolean)

(defcustom enhanced-tetris-use-ai t
  "Non-nil means an ai will play the game for you."
  :group 'enhanced-tetris
  :type 'boolean)

(defcustom enhanced-tetrris-mode-hook nil
  "Hook run upon starting enhanced Tetris."
  :group 'enhanced-tetris
  :type 'hook)

(defcustom enhanced-tetris-tty-colors ["grey"]
  "Vector of color of the ghost."
  :group 'enhanced-tetris
  :type '(vector (color :tag "Shape 8")))

(defcustom enhanced-tetris-x-colors [0.2 0.2 0.2]
  "Vector of RGB color of the ghost."
  :group 'enhanced-tetris
  :type '(vector (vector :tag "Shape 8" number number number)))

(defcustom enhanced-tetris-buffer-name "*enhanced-tetris*"
  "Name used for enhancend-tetris buffer."
  :group 'enhanced-tetris
  :type 'string)

;; variables ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar enhanced-tetris-ghost-pos-y 0)
(defvar enhanced-tetris-ghost-prev-pos-x 0)
(defvar not-first-time nil)

(make-variable-buffer-local 'enhanced-tetris-ghost-pos-y)
(make-variable-buffer-local 'enhanced-tetris-ghost-prev-pos-x)
(make-variable-buffer-local 'not-first-time)

;; game functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun enhanced-tetris-test-ghost-shape ()
  "Check if the ghost shape hit something."
  (let ((ghost-hit nil))
    (dotimes (i 4)
      (unless ghost-hit
	(setq ghost-hit
	      (let* ((c (tetris-get-shape-cell i))
		     (xx (+ tetris-pos-x
			    (aref c 0)))
		     (yy (+ enhanced-tetris-ghost-pos-y
			    (aref c 1))))
		(or (>= xx tetris-width)
		    (>= yy tetris-height)
		    (/= (gamegrid-get-cell
			 (+ xx tetris-top-left-x)
			 (+ yy tetris-top-left-y))
			tetris-blank))))))
    ghost-hit))

(defun enhanced-tetris-erase-ghost ()
  "Erase the previous ghost."
  (dotimes (i 4)
    (let ((c (tetris-get-shape-cell i)))
      (gamegrid-set-cell (+ tetris-top-left-x
			    enhanced-tetris-ghost-prev-pos-x
			    (aref c 0))
			 (+ tetris-top-left-y
			    enhanced-tetris-ghost-pos-y
			    (aref c 1))
			 tetris-blank))))

(defun enhanced-tetris-draw-ghost ()
  "Draws ghost."
  (let ((ghost-hit nil))
    (while (not ghost-hit)
      (setq enhanced-tetris-ghost-pos-y (1+ enhanced-tetris-ghost-pos-y))
      (setq ghost-hit (enhanced-tetris-test-ghost-shape)))
    (setq enhanced-tetris-ghost-pos-y (1- enhanced-tetris-ghost-pos-y))
    (dotimes (i 4)
      (let ((c (tetris-get-shape-cell i)))
	(gamegrid-set-cell (+ tetris-top-left-x
			      tetris-pos-x
			      (aref c 0))
			   (+ tetris-top-left-y
			      enhanced-tetris-ghost-pos-y
			      (aref c 1))
			   tetris-border)))))

(defun tetris-draw-shape ()
  "Overrides the tetris-draw-shape function."
  (dotimes (i 4)
    (let ((c (tetris-get-shape-cell i)))
      (gamegrid-set-cell (+ tetris-top-left-x
			    tetris-pos-x
			    (aref c 0))
			 (+ tetris-top-left-y
			    tetris-pos-y
			    (aref c 1))
			 tetris-shape)))
  (when not-first-time
    (enhanced-tetris-erase-ghost))
  (setq enhanced-tetris-ghost-pos-y (+ 3 tetris-pos-y))
  (setq enhanced-tetris-ghost-prev-pos-x tetris-pos-x)
  (enhanced-tetris-draw-ghost)
  (setq not-first-time t))

;;;###autoload
(defun enhanced-tetris ()
  "Play an enhanced game of Tetris."

  (interactive)
  (select-window (or (get-buffer-window enhanced-tetris-buffer-name)
		     (selected-window)))
  (switch-to-buffer enhanced-tetris-buffer-name)
  (gamegrid-kill-timer)
  (tetris-mode)
  (tetris-start-game))


(provide 'enhanced_tetris)

;;; enhanced_tetris.el ends here

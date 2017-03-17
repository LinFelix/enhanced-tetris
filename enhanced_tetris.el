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

(defcustom enhanced-tetris-buffer-name "*enhanced-tetris*"
  "Name used for enhancend-tetris buffer."
  :group 'enhanced-tetris
  :type 'string)

;; variables ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; game functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



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

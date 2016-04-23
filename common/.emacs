;set up repos
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
						 ("marmalade" . "https://marmalade-repo.org/packages/")
						 ("melpa" . "http://melpa.org/packages/")))
(package-initialize)

(defun install-my-packages ()
  (interactive)
  (when (not package-archive-contents)
    (package-refresh-contents))
  (dolist (p '(auto-complete
			   flycheck
               pyflakes))
    (when (not (package-installed-p p))
      (package-install p))))

(show-paren-mode t)
(fset 'yes-or-no-p 'y-or-n-p)
(setq vc-follow-symlinks 1)
(setq require-final-newline t)

(setq custom-safe-themes t)
(setq-default highlight-tabs t)
(setq tab-width 2)
(global-auto-revert-mode t)
(setq fill-column 80)

(setq auto-save-default nil)
(setq make-backup-files nil)
(setq backup-inhibited t)
(setq mouse-yank-at-point t)

(setq inhibit-startup-screen 1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode)
(xterm-mouse-mode)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(setq-default c-basic-offset 4 c-default-style "linux")
(setq compile-command "g++ -std=c++11 -Wall ")
(setq compilation-ask-about-save nil)
(add-hook 'c++-mode-hook 'auto-complete-mode)

(add-hook 'python-mode-hook 'auto-complete-mode)
(add-hook 'python-mode-hook 'flycheck-mode)

(add-hook 'ruby-mode-hook 'flycheck-mode)
(setq ruby-indent-level 4)

(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching 1)

(require 'auto-complete)
(require 'auto-complete-clang)
(global-auto-complete-mode)

;; (require 'company)
;; (require 'company-clang)

(setq grep-command "grep -nHR -e ")

(defun lame-ctrlp ()
  """Super lame emulation of the excellent ctrlp vim plugin."""
  (interactive)
  (find-dired default-directory
              (concat "-iname \"*" (read-from-minibuffer "search pattern: ") "*\"")))

;key bindings
(global-set-key (kbd "<RET>") 'newline-and-indent)
(global-set-key (kbd "C-b") 'ido-switch-buffer)
(global-set-key (kbd "C-o") 'other-window)
(global-set-key (kbd "<f5>") 'compile)

(load-theme 'sanityinc-tomorrow-night)
(if (display-graphic-p)
    (progn
      (set-frame-font "DejaVu Sans Mono-10.5" nil t)
      ))

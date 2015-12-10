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
  (dolist (p '(flycheck
               pyflakes
               color-theme-sanityinc-tomorrow))
    (when (not (package-installed-p p))
      (package-install p))))

(show-paren-mode t)
(fset 'yes-or-no-p 'y-or-n-p)
(setq vc-follow-symlinks 1)
(setq require-final-newline t)

(setq custom-safe-themes t)
(setq-default highlight-tabs t)
(setq-default indent-tabs-mode nil)
(setq tab-always-indent `complete)
(global-auto-revert-mode t)
(setq fill-column 80)

(setq auto-save-default nil)
(setq make-backup-files nil)
(setq backup-inhibited t)
(xterm-mouse-mode 1)
(setq mouse-yank-at-point t)

(setq inhibit-startup-screen 1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode)

(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'python-mode-hook 'flycheck-mode)
;; (add-hook 'python-mode-hook 'jedi:setup)
(setq ruby-indent-level 4)

(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching 1)

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
(global-set-key (kbd "C-x k") 'kill-this-buffer)
(global-set-key (kbd "C-p") 'lame-ctrlp)

(load-theme 'sanityinc-tomorrow-night)
(if (display-graphic-p)
    (progn
      (set-frame-font "Dejavu Sans Mono-10.5" nil t)))

;set up repos
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
						 ("marmalade" . "https://marmalade-repo.org/packages/")
						 ("melpa" . "http://melpa.org/packages/")))
(package-initialize)
(setq my-packages '(auto-complete
                    flycheck
                    pyflakes
                    find-file-at-point
                    better-defaults
                    ample-theme
                    color-theme-sanityinc-tomorrow
                    smex
                    evil
                    ivy))

(defun install-my-packages ()
  (interactive)
  (when (not package-archive-contents)
    (package-refresh-contents))
  (dolist (p my-packages)
    (when (not (package-installed-p p))
      (package-install p))))

(fset 'yes-or-no-p 'y-or-n-p)
(setq vc-follow-symlinks 1)

(setq custom-safe-themes t)
(setq-default highlight-tabs t)
(setq tab-width 2)
(global-auto-revert-mode t)

(setq inhibit-startup-screen 1)
(column-number-mode)
(xterm-mouse-mode)
(setq visible-bell nil)

;; (add-hook 'before-save-hook 'delete-trailing-whitespace)

(setq-default c-basic-offset 4 c-default-style "linux")

(add-hook 'python-mode-hook 'flycheck-mode)
(add-hook 'ruby-mode-hook 'flycheck-mode)
(setq ruby-indent-level 4)

(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching 1)

(require 'company)
(global-company-mode)

;; (require 'auto-complete)
;; (global-auto-complete-mode)

;; (require 'evil)
;; (evil-mode 1)

(require 'ivy)
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq ivy-count-format "(%d/%d) ")

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

;key bindings
(global-set-key (kbd "C-b") 'ido-switch-buffer)
(global-set-key (kbd "<f5>") 'recompile)
(global-set-key (kbd "M-o") 'other-window)

(setq compilation-environment '("LIBRARY_PATH=/usr/lib/x86_64-linux-gnu"
                                "LD_LIBRARY_PATH=/usr/local/include"))
(setq compile-command "make -j4 ")
(setq compilation-ask-about-save nil)
(setq compilation-scroll-output t)
(setq split-width-threshold 200)
(setq split-height-threshold 200)

(add-hook 'focus-out-hook (lambda()
                            (save-some-buffers t)))
(delete-selection-mode t)

(load-theme 'sanityinc-tomorrow-night)
(if (display-graphic-p)
    (progn
      (set-frame-font "DejaVu Sans Mono-10.5" nil t)
      ))

;set up repos
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
						 ("melpa" . "http://melpa.org/packages/")))
(package-initialize)
(setq my-packages '(flycheck
                    pyflakes
                    find-file-at-point
                    better-defaults
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
(global-auto-revert-mode t)
(desktop-save-mode 1)
(savehist-mode 1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode)
(xterm-mouse-mode)

(add-hook 'focus-out-hook (lambda()
                            (save-some-buffers t)))
(delete-selection-mode t)

(load-theme 'wombat)
(if (display-graphic-p)
    (progn
      (set-frame-font "DejaVu Sans Mono-10.5" nil t)
      ))

(setq-default c-basic-offset 4 c-default-style "linux")
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(c-set-offset 'innamespace 0)

(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'python-mode-hook 'flycheck-mode)

;; (require 'ido)
;; (ido-mode t)
;; (setq ido-enable-flex-matching 1)

;; (require 'evil)
;; (evil-mode 1)

;; (require 'ivy)
;; (ivy-mode 1)
;; (setq ivy-use-virtual-buffers t)
;; (setq ivy-count-format "(%d/%d) ")

;; (require 'web-mode)
;; (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

;key bindings
(global-set-key (kbd "C-b") 'ido-switch-buffer)
(global-set-key (kbd "<f5>") 'recompile)
(global-set-key (kbd "M-<left>") 'pop-global-mark)

(setq compilation-environment '("LIBRARY_PATH=/usr/lib/x86_64-linux-gnu"
                                "LD_LIBRARY_PATH=/usr/local/include"))
(setq compile-command "make -j4 ")
;; (setq compile-command "make -j4 price_server_tests && sudo ./run helmsman tt.price_server.test.test_price_client_advanced_fix")
(setq	custom-safe-themes t
			default highlight-tabs t
			inhibit-startup-screen 1
			ruby-indent-level 4)
			tab-always-indent 'complete
			tab-width 2
			vc-follow-symlinks 1
			visible-bell nil
      compilation-ask-about-save nil
      compilation-scroll-output t
      compilation-window-height 10
      split-height-threshold 200
      split-width-threshold 300)

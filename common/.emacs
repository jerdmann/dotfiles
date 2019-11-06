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

(setq	custom-safe-themes t
	inhibit-startup-screen 1
	ruby-indent-level 4
	tab-always-indent 'complete
	tab-width 2
	vc-follow-symlinks 1
	visible-bell nil
	compilation-ask-about-save nil
	compilation-scroll-output t
	compilation-window-height 10
	split-height-threshold 200
	split-width-threshold 300)

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
(setq scroll-step 1
      scroll-conservatively 10000
      auto-window-vscroll nil)

(column-number-mode)
(xterm-mouse-mode)

(add-hook 'focus-out-hook (lambda()
                            (save-some-buffers t)))
(delete-selection-mode t)

(load-theme 'gruvbox-dark-medium)
(global-hl-line-mode)
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

;(require 'evil)
;(evil-mode 1)
;(evil-add-hjkl-bindings occur-mode-map 'emacs
    ;(kbd "/")       'evil-search-forward
    ;(kbd "n")       'evil-search-next
    ;(kbd "N")       'evil-search-previous
    ;(kbd "0")       'evil-digit-argument-or-evil-beginning-of-line
    ;(kbd "^")       'evil-first-non-blank
    ;(kbd "$")       'evil-end-of-line
    ;(kbd "C-d")     'evil-scroll-down
    ;(kbd "C-u")     'evil-scroll-up
    ;(kbd "C-w C-w") 'other-window)

 ;; (general-define-key
 ;;  :states '(normal visual insert emacs)
 ;;  :prefix "SPC"
 ;;  :non-normal-prefix "C-SPC"

 ;;  "x" '(:ignore t :which-key "text")

 ;;  "b" '(:ignore t :which-key "buffers/bookmarks")
 ;;  "bb" 'buffers-list
 ;;  "bk" 'kill-buffer  ; change buffer, chose using ivy

 ;;  "f" '(:ignore t :which-key "files")
 ;;  "fo" 'ff-find-other-file

 ;;  "p" '(:ignore t :which-key "project")
 ;;  "pf" '(counsel-git :which-key "find file in git dir")        ; find file in git project

 ;;  "g" '(:ignore t :which-key "git")
 ;;  "gs" 'magit-status
 ;;  "gb" 'magit-blame
 ;;  "gl" 'magit-log-head
 ;;  "gL" 'magit-log

 ;;  "c" 'compile

 ;;  "w" '(:ignore t :which-key "window")
 ;;  "wo" 'ace-window
 ;;  "wm" 'my/toggle-maximize-buffer
 ;;  "wc" 'delete-window
 ;;  "wd" 'delete-window
 ;;  "ws" 'evil-window-split
 ;;  "wv" 'evil-window-vsplit
 ;;  "wk" 'evil-window-up
 ;;  "wj" 'evil-window-down
 ;;  "wh" 'evil-window-left
 ;;  "wl" 'evil-window-right

 ;;  "'" 'my/compilation-popup
 ;;  )

;; (require 'ivy)
;; (ivy-mode 1)
;; (setq ivy-use-virtual-buffers t)
;; (setq ivy-count-format "(%d/%d) ")

;; (require 'web-mode)
;; (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

;key bindings
(global-set-key (kbd "C-b") 'ido-switch-buffer)
;; (global-set-key (kbd "<f5>") 'recompile)
;; (global-set-key (kbd "M-<left>") 'pop-global-mark)

(setq compilation-environment '("LIBRARY_PATH=/usr/lib/x86_64-linux-gnu"
                                "LD_LIBRARY_PATH=/usr/local/include"))

;; (setq compile-command "~/build.sh ")

;; (setq compile-command "make -j4 price_server_tests && sudo ./run helmsman tt.price_server.test.test_price_client_advanced_fix")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (gruvbox-theme use-package zenburn-theme magit lua-mode ivy hc-zenburn-theme go-mode fzf flycheck evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

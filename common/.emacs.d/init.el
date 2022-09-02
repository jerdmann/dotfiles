;set up repos
(require 'package)
;; tells emacs not to load any packages before starting up
(setq package-enable-at-startup nil
      package-user-dir "~/.emacs.d/elpa/")
(setq package-archives '(("melpa"     . "http://melpa.org/packages/")
                         ("gnu"      . "http://elpa.gnu.org/packages/")
                         ))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

(use-package better-defaults :ensure t)

(setq	custom-safe-themes t
	inhibit-startup-screen 1
	ruby-indent-level 4
	tab-always-indent 'complete
	vc-follow-symlinks 1
	visible-bell nil
	compilation-ask-about-save nil
        compilation-scroll-output 'first-error
        compilation-auto-jump-to-first-error t
        compilation-skip-threshold 2
        compile-command "vmk "
        grep-save-buffers 1
        )

(global-hl-line-mode)
(if (display-graphic-p)
    (progn
      (set-frame-font "DejaVu Sans Mono-11" nil t)
      ))

;; underscores are word characters please
(add-hook 'after-change-major-mode-hook
          (lambda ()
            (modify-syntax-entry ?_ "w")))

(setq-default c-basic-offset 4 c-default-style "linux")
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.inl\\'" . c++-mode))
(c-set-offset 'innamespace 0)

(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'python-mode-hook 'flycheck-mode)

(use-package gruvbox-theme :ensure t
  :config
  (load-theme 'gruvbox 1))

(use-package evil :ensure t
  :config
  (evil-mode)
  :bind
    (:map evil-normal-state-map
          ("]c" . next-error)
          ("[c" . previous-error)
          ))

(use-package evil-commentary
    :ensure t
    :bind (:map evil-normal-state-map
                ("gc" . evil-commentary)))

(defun je/grep ()
  (interactive)
  (grep (concat "grep --color -Hnr " (read-string "pattern: ")))
  )
(defun je/grep-thing-at-point ()
  (interactive)
  (grep (concat "grep --color -Hnr " (ivy-thing-at-point)))
  )
(defun je/eval-init-and-swap ()
  (interactive)
  (eval-buffer "init.el")
  (switch-to-buffer 'nil)
  )

(use-package undo-tree :ensure t
  :config
   (global-undo-tree-mode))

(use-package evil-leader
  :ensure t
  :config
  (evil-leader/set-leader "<SPC>")
  (evil-leader/set-key
    "b" 'ivy-switch-buffer
    "g" 'je/grep
    "k" 'je/grep-thing-at-point
    "m" 'recompile
    "p" 'counsel-fzf
    "e b" 'eval-buffer
    "e i" 'je/eval-init-and-swap
    ;; "/" 'helm-find-files
    ;; "L" 'counsel-git-log
    ;; "V" 'ivy-pop-view
    ;; "b" 'helm-buffers-list
    ;; "g" 'counsel-git
    ;; "j" 'counsel-git-grep
    ;; "m" 'counsel-linux-app
    ;; "v" 'ivy-push-view
  )
  (evil-mode t)

  :config
  (global-evil-leader-mode)
  (evil-set-undo-system 'undo-tree)
  )

(use-package rust-mode :ensure t)

(use-package counsel :ensure t
  :config
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  (setq counsel-projectile-grep-initial-input (ivy-thing-at-point))
  )
(use-package swiper :ensure t)

(require 'mwheel)
(mouse-wheel-mode)
(xterm-mouse-mode)

(setq comint-prompt-read-only t)

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

;key bindings
(global-set-key (kbd "C-p") 'helm-find-files)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-s") 'swiper-isearch)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "C-c ]") 'next-error)
(global-set-key (kbd "C-c [") 'previous-error)
;; (global-set-key (kbd "M-y") 'counsel-yank-pop)
;; (global-set-key (kbd "<f1> f") 'counsel-describe-function)
;; (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
;; (global-set-key (kbd "<f1> l") 'counsel-find-library)
;; (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
;; (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
;; (global-set-key (kbd "<f2> j") 'counsel-set-variable)
;; (global-set-key (kbd "C-x b") 'ivy-switch-buffer)
;; (global-set-key (kbd "C-c v") 'ivy-push-view)
;; (global-set-key (kbd "C-c V") 'ivy-pop-view)
;; Ivy-based interface to shell and system tools
;; (global-set-key (kbd "C-c c") 'counsel-compile)
;; (global-set-key (kbd "C-c g") 'counsel-git)
;; (global-set-key (kbd "C-c j") 'counsel-git-grep)
;; (global-set-key (kbd "C-c L") 'counsel-git-log)
;; (global-set-key (kbd "C-c k") 'counsel-rg)
;; (global-set-key (kbd "C-c m") 'counsel-linux-app)
;; (global-set-key (kbd "C-c n") 'counsel-fzf)
;; (global-set-key (kbd "] q") 'compilation-next-error)
;; (global-set-key (kbd "[ q") 'compilation-previous-error)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (evil flycheck-rust rust-mode use-package gruvbox-theme flycheck evil-surround evil-leader evil-commentary evil-collection better-defaults))))

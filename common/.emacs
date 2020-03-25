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
	compilation-scroll-output t
	compilation-window-height 10
	split-height-threshold 200
	split-width-threshold 300)

(global-hl-line-mode)
(if (display-graphic-p)
    (progn
      (set-frame-font "DejaVu Sans Mono-11" nil t)
      ))

(setq-default c-basic-offset 4 c-default-style "linux")
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(c-set-offset 'innamespace 0)

(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'python-mode-hook 'flycheck-mode)

(use-package gruvbox-theme :ensure t)

(use-package evil :ensure t
  :config
  (evil-mode))

(use-package evil-collection
    :after evil
    :ensure t
    :config
    (evil-collection-init))

(use-package evil-commentary
    :ensure t
    :bind (:map evil-normal-state-map
                ("gc" . evil-commentary)))
(use-package evil-goggles
    :ensure t
    :config
    (evil-goggles-use-diff-faces)
    (evil-goggles-mode))

(use-package evil-surround
  :ensure t
  :commands
  (evil-surround-edit
   evil-Surround-edit
   evil-surround-region
   evil-Surround-region)
  :init
  (evil-define-key 'operator global-map "s" 'evil-surround-edit)
  (evil-define-key 'operator global-map "S" 'evil-Surround-edit)
  (evil-define-key 'visual global-map "S" 'evil-surround-region)
  (evil-define-key 'visual global-map "gS" 'evil-Surround-region))

(use-package evil-leader :ensure t
  :init
  (setq evil-want-keybinding nil)
  (global-evil-leader-mode))

(use-package rust-mode :ensure t)


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

;; (setq compile-command "~/build.sh ")

;; (setq compile-command "make -j4 price_server_tests && sudo ./run helmsman tt.price_server.test.test_price_client_advanced_fix")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (evil flycheck-rust rust-mode use-package gruvbox-theme flycheck evil-surround evil-leader evil-goggles evil-commentary evil-collection better-defaults))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(evil-goggles-change-face ((t (:inherit diff-removed))))
 '(evil-goggles-delete-face ((t (:inherit diff-removed))))
 '(evil-goggles-paste-face ((t (:inherit diff-added))))
 '(evil-goggles-undo-redo-add-face ((t (:inherit diff-added))))
 '(evil-goggles-undo-redo-change-face ((t (:inherit diff-changed))))
 '(evil-goggles-undo-redo-remove-face ((t (:inherit diff-removed))))
 '(evil-goggles-yank-face ((t (:inherit diff-changed)))))

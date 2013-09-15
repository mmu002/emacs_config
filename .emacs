;; .emacs - gnu emacs configuration file
;; last clean-up: 2013-08-03

;;;;;;;;;; emacs standard configuration stuff ;;;;;;;;;;
;; setup load path, primarily for external scripts
(setq load-path (append '("C:/_tools/emacs-24.3/load_path"
                          "C:/_tools/emacs-24.3/load_path/git-emacs"
                          "C:/_tools/emacs-24.3/load_path/color-theme"
                          "~/.emacs.d/")
                        load-path))

;; custom global variables
(custom-set-variables
 '(case-fold-search nil)
 '(column-number-mode t)
 '(display-time-mode t)
 '(inhibit-startup-screen t)
 '(menu-bar-mode nil)
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(text-mode-hook (quote (text-mode-hook-identify)))
 '(tool-bar-mode nil))

(setq backup-inhibited t ) ; disable backup
(setq auto-save-default nil) ; disable auto save

;; custom global face settings
(custom-set-faces
 '(default ((t (:inherit nil
                :stipple nil
                :background "SystemWindow"
                :foreground "SystemWindowText"
                :inverse-video nil
                :box nil
                :strike-through nil
                :overline nil
                :underline nil
                :slant normal
                :weight normal
                :height 98
                :width normal
                :foundry "outline"
                :family "Lucida Console")))))

;; use spaces instead of tabs
(setq-default indent-tabs-mode nil)



;;;;;;;;;; shortcut remapping & hooks ;;;;;;;;;;
;; set the proper shortcuts
(define-key global-map [(f11)] 'th-color-theme-prev)
(define-key global-map [(f12)] 'th-color-theme-next)

;; alternative to M-x
(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)

;; alternative to C-w
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)

;; don't use the backspace key
(global-set-key "\C-w" 'backward-kill-word)

;; use the power of regular expressions
(global-set-key "\M-s" 'isearch-forward-regexp)
(global-set-key "\M-r" 'isearch-backward-regexp)

;; shortcuts for easily en-/disabling case-sensitive search & more
(add-hook 'isearch-mode-hook
          (function
           (lambda ()
             (define-key isearch-mode-map "\C-h" 'isearch-mode-help)
             (define-key isearch-mode-map "\C-t" 'isearch-toggle-regexp)
             (define-key isearch-mode-map "\C-c" 'isearch-toggle-case-fold)
             (define-key isearch-mode-map "\C-j" 'isearch-edit-string))))

;; query each replacement
(defalias 'qrr 'query-replace-regexp)

;; use ibuffer as default buffer switcher
(defalias 'list-buffers 'ibuffer)



;;;;;;;;;; external modules import & configuration ;;;;;;;;;;
;; load, initialize and set color theme
(require 'color-theme)
(color-theme-initialize)
(color-theme-calm-forest)

;; auto-complete
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)

;; make org-mode work with files ending in .org
(require 'org)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(setq org-insert-mode-line-in-empty-file t)

;; easy buffer switching using CTRL-TAB
(require 'ebs)
(ebs-initialize)
(global-set-key [(control tab)] 'ebs-switch-buffer)

;; enable git support
(require 'git-emacs)



;;;;;;;;;; in-configuration procedure implementations ;;;;;;;;;;
;; color theme selector
(defvar th-current-color-theme-index 0 "Holds the index of the currently activated color theme.")

;; set the actual color theme
(defun th-color-theme-set (index)
  (setq index
        (cond
         ((< index 0)
          (- (length color-themes) 1))
         ((>= index (length color-themes))
          0)
         (t index)))
  (message "Setting color-theme(%d): %s" index
           (car (nth index color-themes)))
  (setq th-current-color-theme-index index)
  (funcall (car (nth index color-themes))))

;; set next color theme
(defun th-color-theme-next ()
  (interactive)
  (th-color-theme-set (+ th-current-color-theme-index 1)))

;; set previous color theme
(defun th-color-theme-prev ()
  (interactive)
  (th-color-theme-set (- th-current-color-theme-index 1)))

;; Set transparency of emacs
(defun transparency (value)
  "Sets the transparency of the frame window. 0=transparent/100=opaque"
  (interactive "nTransparency Value 0 - 100 opaque: ")
  (set-frame-parameter (selected-frame) 'alpha value))



;;;;;;;;;; old snippets, configurations & magic stuff ;;;;;;;;;;
;;
;; rhtml mode
;; (require 'rhtml-mode)
;; (setq auto-mode-alist (cons '("\\.erb$" . rhtml-mode) auto-mode-alist))

;; spell check support
;; (setq-default ispell-program-name"C:/Aspell/bin/aspell.exe") ; set aspell as default checker
;; (setq text-mode-hook '(lambda() (flyspell-mode t))) ; enable flyspell-mode

;; make emacs transparent by default
;; (set-frame-parameter (selected-frame) 'alpha '(95 84))
;; (add-to-list 'default-frame-alist '(alpha 95 84))

;; standard time stamp
;; (defun insert-timestamp ()
;;   "Insert today's date into buffer"
;;   (interactive)
;;   (insert (format-time-string "%d.%m.%Y @ %H:%M" (current-time)))
;;   )

;; windows cycling
;; (defun windmove-up-cycle()
;;   (interactive)
;;   (condition-case nil (windmove-up)
;;     (error (condition-case nil (windmove-down)
;;          (error (condition-case nil (windmove-right) (error (condition-case nil (windmove-left) (error (windmove-up))))))))))

;; (defun windmove-down-cycle()
;;   (interactive)
;;   (condition-case nil (windmove-down)
;;     (error (condition-case nil (windmove-up)
;;          (error (condition-case nil (windmove-left) (error (condition-case nil (windmove-right) (error (windmove-down))))))))))

;; (defun windmove-right-cycle()
;;   (interactive)
;;   (condition-case nil (windmove-right)
;;     (error (condition-case nil (windmove-left)
;;          (error (condition-case nil (windmove-up) (error (condition-case nil (windmove-down) (error (windmove-right))))))))))

;; (defun windmove-left-cycle()
;;   (interactive)
;;   (condition-case nil (windmove-left)
;;     (error (condition-case nil (windmove-right)
;;          (error (condition-case nil (windmove-down) (error (condition-case nil (windmove-up) (error (windmove-left))))))))))

;; set the proper shortcuts
;; (global-set-key (kbd "C-x <up>") 'windmove-up-cycle)
;; (global-set-key (kbd "C-x <down>") 'windmove-down-cycle)
;; (global-set-key (kbd "C-x <right>") 'windmove-right-cycle)
;; (global-set-key (kbd "C-x <left>") 'windmove-left-cycle)

;; activate minimap
;; (require 'minimap)

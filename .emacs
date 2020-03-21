;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

;; Require Emacs' package functionality

;;; Code:
(require 'package)
(package-initialize)

;; add the Melpa repository to the list of package sources
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)

;;---------------------------------------------------
;; Customizations of editor
;;--------------------------------------------------

(setq-default fill-column 120);; make columns wider
(global-linum-mode 0)
(global-visual-line-mode 1); Proper line wrapping
(global-hl-line-mode 1); Highlight current row
(set-fringe-mode '(0 . 0)); Disable fringe because I use visual-line-mode
(setq inhibit-splash-screen t); Disable splash screen
(setq visible-bell t); Flashes on error
(when (fboundp 'menu-bar-mode) (menu-bar-mode 0))
(when (fboundp 'tool-bar-mode) (tool-bar-mode 0))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode 0))
(setq ring-bell-function 'ignore);; disable sounds
(setq inhibit-startup-message t)

;; Shift + arrows to move between windows
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;; Modify window sizes
(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<down>") 'shrink-window)
(global-set-key (kbd "S-C-<up>") 'enlarge-window)
(global-set-key "\M-/" 'hippie-expand)

;; default org notes file
;;(setq org-default-notes-file (concat org-directory "~/Documents/org/notes.org"))

;;----------------------------------------------------
;; Add use-package
;; https://github.com/jwiegley/use-package
;;----------------------------------------------------
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))

;;----------------------------------------------------
;; bind-key
;;----------------------------------------------------
(use-package bind-key
  :ensure t)

;;----------------------------------------------------
;; Add diminish
;;----------------------------------------------------
(use-package diminish
  :ensure t)

;;----------------------------------------------------
;; restart emacs
;;----------------------------------------------------
(use-package restart-emacs
  :ensure t
  )

;;---------------------------------------------------
;; Smartparens
;; https://github.com/Fuco1/smartparens
;;---------------------------------------------------
(use-package smartparens
  :ensure t
  :hook ((TeX-mode matlab-mode matlab-shell-mode python-mode emacs-lisp-mode) . smartparens-mode)
  )

;;----------------------------------------------------
;; Aggressive indent mode
;; https://github.com/Malabarba/aggressive-indent-mode
;;----------------------------------------------------
(use-package aggressive-indent
  :ensure t
  :config
  (global-aggressive-indent-mode 1)
  (add-to-list 'aggressive-indent-excluded-modes 'html-mode))

;;----------------------------------------------------
;; dimmer
;;----------------------------------------------------
(use-package dimmer
  :ensure t
  :config
  (dimmer-mode)
  )

;;----------------------------------------------------
;; dired
;;----------------------------------------------------
(use-package dired
  :hook (dired-mode . dired-hide-details-mode)
  )

;;----------------------------------------------------
;; Add dired-subtree to make dired nicer
;; https://github.com/Fuco1/dired-hacks/blob/master/dired-subtree.el
;;----------------------------------------------------
(use-package dired-subtree
  :ensure t
  :after dired
  :config
  (bind-key "<tab>" #'dired-subtree-toggle dired-mode-map)
  (bind-key "<backtab>" #'dired-subtree-cycle dired-mode-map))

;;----------------------------------------------------
;; themes
;;----------------------------------------------------
(use-package spacemacs-common
  :ensure spacemacs-theme
  :config (load-theme 'spacemacs-dark t))

;;----------------------------------------------------
;; pdf-tools
;;----------------------------------------------------
(use-package pdf-tools
  :ensure t
  :config
  (pdf-tools-install) ;; start server
  )

;;----------------------------------------------------
;; synosaurus
;;----------------------------------------------------
(use-package synosaurus
  :ensure t
  :init
  (setq synosaurus-choose-method "ido")
  :hook (TeX-mode . synosaurus-mode)
  )

;;---------------------------------------------------
;; Counsel
;; Brings in Ivy, Swiper and Counsel
;; https://oremacs.com/swiper/
;; https://writequit.org/denver-emacs/presentations/2017-04-11-ivy.htmbl
;;---------------------------------------------------
(use-package counsel
  :ensure t
  :diminish
  ivy-mode
  counsel-mode
  :config
  (ivy-mode 1)
  (counsel-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  :bind
  ("C-s" . swiper)
  )

;;----------------------------------------------------
;; Add Projectile project interaction library
;; https://docs.projectile.mx/en/latest/
;;----------------------------------------------------
(use-package projectile
  :ensure t
  :pin melpa-stable
  :config
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
  (projectile-mode +1)
  (counsel-projectile-mode +1)
  )

(use-package org-projectile
  :bind (("C-c n p" . org-projectile-capture-for-current-project)
         ("C-c c" . org-capture))
  :config
  (progn
    (setq org-projectile-projects-file
          "~/Documents/org/projects.org")
    (setq org-agenda-files (append org-agenda-files (org-projectile-todo-files)))
    (push (org-projectile-project-todo-entry) org-capture-templates))
  :ensure t)

;;----------------------------------------------------
;; Yasnippet
;;----------------------------------------------------
(use-package yasnippet                  ; Snippets
  :ensure t
  :config
  (setq
   yas-verbosity 1                      ; No need to be so verbose
   yas-wrap-around-region t)

  (with-eval-after-load 'yasnippet
    (setq yas-snippet-dirs '(yasnippet-snippets-dir)))

  (yas-reload-all)
  :hook ((python-mode matlab-mode TeX-mode) . yas-minor-mode)
  )

(use-package yasnippet-snippets         ; Collection of snippets
  :ensure t)

;;---------------------------------------------------
;; Treemacs
;;---------------------------------------------------
(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode t)
    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple))))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-projectile
  :after treemacs projectile
  :ensure t)

(use-package treemacs-icons-dired
  :after treemacs dired
  :ensure t
  :config (treemacs-icons-dired-mode))

(use-package treemacs-magit
  :after treemacs magit
  :ensure t)

;;----------------------------------------------------
;; Matlab mode
;;----------------------------------------------------
(use-package matlab-mode
  :ensure t
  :mode ("\\.m$" . matlab-mode)
  :init
  (setq matlab-shell-command-switches (quote ("-nodesktop -nosplash")))
  (setq matlab-mode-install-path "/usr/local/MATLAB/R2018b/toolbox")
  (setq matlab-shell-history-file "~/.matlab/R2018b/history.m")
  (setq matlab-shell-input-ring-size 2000)
  )

;;----------------------------------------------------
;; Python (elpy)
;; https://elpy.readthedocs.io
;;----------------------------------------------------
(use-package elpy
  :ensure t
  :defer t
  :init
  (advice-add 'python-mode :before 'elpy-enable)
  (setq elpy-rpc-virtualenv-path 'current)
  (setq elpy-get-info-from-shell t)
  ;;(setq elpy-rpc-python-command "python3")
  )

;;----------------------------------------------------
;; Sphinxdoc
;; https://github.com/naiquevin/sphinx-doc.el/
;;----------------------------------------------------
(use-package sphinx-doc
  :ensure t
  :hook (python-mode . sphinx-doc-mode)
  )
;;---------------------------------------------------
;; AUCTeX - needs fixing
;;---------------------------------------------------
(add-hook 'TeX-mode-hook 'flyspell-mode); Enable Flyspell mode for TeX modes such as AUCTeX. Highlights all misspelled words.
(add-hook 'emacs-lisp-mode-hook 'flyspell-prog-mode); Enable Flyspell program mode for emacs lisp mode, which highlights all misspelled words in comments and strings.
(setq ispell-dictionary "english"); Default dictionary. To change do M-x ispell-change-dictionary RET.
(add-hook 'TeX-mode-hook
          (lambda () (TeX-fold-mode 1))); Automatically activate TeX-fold-mode.
(setq LaTeX-babel-hyphen nil); Disable language-specific hyphen insertion.

(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)

;; " expands into csquotes macros (for this to work babel must be loaded after csquotes).
(setq LaTeX-csquotes-close-quote "}"
      LaTeX-csquotes-open-quote "\\enquote{")


(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
      TeX-source-correlate-start-server t
      )
;; revert pdf-view after compilation
(add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)

;; synctex
(setq LaTeX-command "latex --synctex=1") ;; optional: enable synctex

;; LaTeX-math-mode http://www.gnu.org/s/auctex/manual/auctex/Mathematics.html
(add-hook 'TeX-mode-hook 'LaTeX-math-mode)

;;; RefTeX
;; Turn on RefTeX for AUCTeX http://www.gnu.org/s/auctex/manual/reftex/reftex_5.html
(add-hook 'TeX-mode-hook 'turn-on-reftex)

(eval-after-load 'reftex-vars; Is this construct really needed?
  '(progn
     (setq reftex-cite-prompt-optional-args t); Prompt for empty optional arguments in cite macros.
     ;; Make RefTeX interact with AUCTeX, http://www.gnu.org/s/auctex/manual/reftex/AUCTeX_002dRefTeX-Interface.html
     (setq reftex-plug-into-AUCTeX t)
     ;; So that RefTeX also recognizes \addbibresource. Note that you
     ;; can't use $HOME in path for \addbibresource but that "~"
     ;; works.
     (setq reftex-bibliography-commands '("bibliography" "nobibliography" "addbibresource"))
					;     (setq reftex-default-bibliography '("UNCOMMENT LINE AND INSERT PATH TO YOUR BIBLIOGRAPHY HERE")); So that RefTeX in Org-mode knows bibliography
     (setcdr (assoc 'caption reftex-default-context-regexps) "\\\\\\(rot\\|sub\\)?caption\\*?[[{]"); Recognize \subcaptions, e.g. reftex-citation
     (setq reftex-cite-format; Get ReTeX with biblatex, see https://tex.stackexchange.com/questions/31966/setting-up-reftex-with-biblatex-citation-commands/31992#31992
           '((?t . "\\textcite[]{%l}")
             (?a . "\\autocite[]{%l}")
             (?c . "\\cite[]{%l}")
             (?s . "\\smartcite[]{%l}")
             (?f . "\\footcite[]{%l}")
             (?n . "\\nocite{%l}")
             (?b . "\\blockcquote[]{%l}{}")))))

;;----------------------------------------------------
;; Company completion engine 
;; https://company-mode.github.io/
;;----------------------------------------------------
;; company-auctex
(use-package company-auctex
  :ensure t
  :config
  (company-auctex-init))

;;Handle Company + Yasnippet
(defun check-expansion ()
  (save-excursion
    (if (looking-at "\\_>") t
      (backward-char 1)
      (if (looking-at "\\.") t
	(backward-char 1)
	(if (looking-at "->") t nil)))))

(defun do-yas-expand ()
  (let ((yas/fallback-behavior 'return-nil))
    (yas/expand)))

(defun tab-indent-or-complete ()
  (interactive)
  (if (minibufferp)
      ;;(minibuffer-complete)
      (unless (minibuffer-complete)
	(dabbrev-expand nil))
    (if (or (not yas/minor-mode)
	    (null (do-yas-expand)))
	(if (check-expansion)
	    (company-complete-common)
	  (indent-for-tab-command)))))

;; Company
(use-package company
  :ensure t
  :diminish company-mode
  :init
  (add-hook 'after-init-hook 'global-company-mode)
  (add-hook 'python-mode-hook
	    '(lambda ()
	       (set (make-local-variable 'company-backends)
		    '(elpy-company-backend company-files company-dabbrev-code) )))
  (add-hook 'matlab-mode-hook
	    '(lambda ()
	       (set (make-local-variable 'company-backends)
		    '(company-matlab-shell company-files company-dabbrev-code))))
  (add-hook 'matlab-shell-mode-hook
	    '(lambda ()
	       (set (make-local-variable 'company-backends)
		    '(company-matlab-shell company-files company-dabbrev-code))))
  (setq company-idle-delay 0)
  :bind ("TAB" . tab-indent-or-complete)
  )

;;----------------------------------------------------
;; Magit for git manager
;; https://magit.vc/
;;----------------------------------------------------
(use-package magit
  :ensure t
  :init
  (setq magit-refresh-status-buffer nil)
  (setq magit-completing-read-function 'ivy-completing-read)
  )

;;----------------------------------------------------
;; Add flycheck syntax checking
;; https://www.flycheck.org/en/latest
;;----------------------------------------------------

(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode) 
  )

;; ;; Add sublimity for aesthetics
;; ;; https://github.com/zk-phi/sublimity

;; eshell
(setq eshell-buffer-maximum-lines 10000) ;; max buffer size
(add-hook 'eshell-output-filter-functions #'eshell-truncate-buffer)

(provide '.emacs)
;;; .emacs ends here
(put 'erase-buffer 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files nil)
 '(package-selected-packages
   (quote
    (company-jedi elpy treemacs-magit treemacs-icons-dired treemacs-projectile treemacs zenburn-theme vimish-fold use-package synosaurus sublimity spacemacs-theme smex smartparens project-explorer pdf-tools origami org-projectile org-plus-contrib org-bullets magit ivy-todo ivy-hydra iedit flycheck-irony exec-path-from-shell doom-themes dired-subtree dimmer diminish counsel-projectile company-math company-irony company-auctex alect-themes aggressive-indent))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

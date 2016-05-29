(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

(require 'evil)
(evil-mode 1)

;; general
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

(tool-bar-mode -1)
(setq scroll-step            1
      scroll-conservatively  10000)

; http://stackoverflow.com/questions/15180175/how-to-disable-underscore-subscripting-in-emacs-tex-input-method
(register-input-method
 "TeX, no (sub|super)scripts" "UTF-8" 'quail-use-package
 "\\" "The TeX input method but without _ for subscript and ^ for superscript."
 "~/dotfiles/emacs.d/latin-ltx_subsuperscript.el.gz")

(setq default-input-method "TeX, no (sub|super)scripts")
(add-to-list 'default-frame-alist '(font . "DejaVu Sans Mono-12"))

; Ctrl-c/v for copy/paste in Emacs mode
(cua-mode t)
    (setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
    (transient-mark-mode 1)               ;; No region when it is not highlighted
    (setq cua-keep-region-after-copy t)

;; Coq
(require 'proof-site "~/.emacs.d/lisp/PG/generic/proof-site")

(add-hook 'coq-mode-hook #'company-coq-mode)
(add-hook 'proof-ready-for-assistant-hook (lambda () (show-paren-mode -1)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-coq-live-on-the-edge t)
 '(coq-one-command-per-line nil)
 '(proof-electric-terminator-enable t)
 '(proof-next-command-insert-space t)
 '(safe-local-variable-values
   (quote
    ((coq-prog-args "-emacs-U" "-I" "/home/ondra/prog/coq/cpdt")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

; http://endlessparentheses.com/proof-general-configuration-for-the-coq-software-foundations-tutorial.html
(setq proof-splash-seen t)
(setq proof-script-fly-past-comments t)

(with-eval-after-load 'coq
  (define-key coq-mode-map "\M-n"
    #'proof-assert-next-command-interactive)
)

; Activating the default input method
; http://emacs.stackexchange.com/questions/418/setting-and-activating-the-default-input-method
(defvar use-default-input-method t)
(make-variable-buffer-local 'use-default-input-method)
(defun activate-default-input-method ()
  (interactive)
  (if use-default-input-method
    (activate-input-method default-input-method)
    (inactivate-input-method)
    )
  )
(add-hook 'after-change-major-mode-hook 'activate-default-input-method)
(add-hook 'minibuffer-setup-hook 'activate-default-input-method)
(defun inactivate-default-input-method ()
  (setq use-default-input-method nil))
(add-hook 'c-mode-hook 'inactivate-default-input-method)


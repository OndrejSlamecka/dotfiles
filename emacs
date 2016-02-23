(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

;; general
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

(tool-bar-mode -1)
(setq scroll-step            1
      scroll-conservatively  10000)

(setq default-input-method "TeX")
(add-to-list 'default-frame-alist '(font . "DejaVu Sans Mono-12"))

;; duplicating a line -- http://stackoverflow.com/a/88828/2043510
(defun duplicate-line()
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (next-line 1)
  (yank)
)

; unfortunately PG has its own C-c C-d
(global-set-key (kbd "C-c C-d") 'duplicate-line)

;; Coq
(require 'proof-site "~/.emacs.d/lisp/PG/generic/proof-site")

(add-hook 'coq-mode-hook #'company-coq-mode)
(add-hook 'proof-ready-for-assistant-hook (lambda () (show-paren-mode -1)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
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

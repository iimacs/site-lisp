;;; init.el --- Spacemacs Initialization File
;;
;; Copyright (c) 2012-2018 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; Without this comment emacs25 adds (package-initialize) here
;; (package-initialize)

;; Avoid garbage collection during startup.
;; see `SPC h . dotspacemacs-gc-cons' for more info
(setq debug-on-signal t)
(defconst emacs-start-time (current-time))
;;(make-directory (expand-file-name user-emacs-directory) t)
(setq dot-emacs-cachedir (expand-file-name (concat user-emacs-directory ".cache")))
(unless (file-directory-p dot-emacs-cachedir)
  (make-directory dot-emacs-cachedir)
  )
(setq gc-cons-threshold 402653184 gc-cons-percentage 0.6)
(defvar spacemacs-start-directory
  (concat (file-name-directory load-file-name) "spacemacs/"))
(load (concat spacemacs-start-directory
              "core/core-versions.el")
      nil (not init-file-debug))
(defun add-to-load-path (dir) (add-to-list 'load-path dir))

(defun add-to-load-path-if-exists (dir)
  "If DIR exists in the file system, add it to `load-path'."
  (when (file-exists-p dir)
    (add-to-load-path dir)))

;; paths
(defvar spacemacs-start-directory
  user-emacs-directory
  "Spacemacs start directory.")
(defconst spacemacs-core-directory
  (expand-file-name (concat spacemacs-start-directory "core/"))
  "Spacemacs core directory.")
(defconst spacemacs-private-directory
  (expand-file-name (concat spacemacs-start-directory "private/"))
  "Spacemacs private directory.")
(defconst spacemacs-info-directory
  (expand-file-name (concat spacemacs-core-directory "info/"))
  "Spacemacs info files directory")
(defconst spacemacs-release-notes-directory
  (expand-file-name (concat spacemacs-info-directory "release-notes/"))
  "Spacemacs release notes directory")
(defconst spacemacs-banner-directory
  (expand-file-name (concat spacemacs-core-directory "banners/"))
  "Spacemacs banners directory.")
(defconst spacemacs-banner-official-png
  (expand-file-name (concat spacemacs-banner-directory "img/spacemacs.png"))
  "Spacemacs official banner image.")
(defconst spacemacs-badge-official-png
  (expand-file-name (concat spacemacs-banner-directory
                            "img/spacemacs-badge.png"))
  "Spacemacs official badge image.")
(defconst spacemacs-purple-heart-png
  (expand-file-name (concat spacemacs-banner-directory "img/heart.png"))
  "Purple heart emoji.")
(defconst spacemacs-cache-directory
  (expand-file-name (concat user-emacs-directory ".cache/"))
  "Spacemacs storage area for persistent files")
(defconst spacemacs-auto-save-directory
  (expand-file-name (concat spacemacs-cache-directory "auto-save/"))
  "Spacemacs auto-save directory")
(defconst spacemacs-docs-directory
  (expand-file-name (concat spacemacs-start-directory "doc/"))
  "Spacemacs documentation directory.")
(defconst spacemacs-news-directory
  (expand-file-name (concat spacemacs-start-directory "news/"))
  "Spacemacs News directory.")
(defconst spacemacs-assets-directory
  (expand-file-name (concat spacemacs-start-directory "assets/"))
  "Spacemacs assets directory.")
(defconst spacemacs-test-directory
  (expand-file-name (concat spacemacs-start-directory "tests/"))
  "Spacemacs tests directory.")

(defconst user-home-directory
  (expand-file-name "~/")
  "User home directory (~/).")
(defconst pcache-directory
  (concat spacemacs-cache-directory "pcache/"))
(unless (file-exists-p spacemacs-cache-directory)
    (make-directory spacemacs-cache-directory))

;; load paths
(mapc 'add-to-load-path
      `(
        ,spacemacs-core-directory
        ,(concat spacemacs-core-directory "libs/")
        ,(concat spacemacs-core-directory "libs/spacemacs-theme/")
        ;; ,(concat spacemacs-core-directory "aprilfool/")
        ))

;; themes
(add-to-list 'custom-theme-load-path (concat spacemacs-core-directory
                                             "libs/spacemacs-theme/"))

(load (concat spacemacs-core-directory "core-dumper.el")
      nil (not init-file-debug))

(if (not (version<= spacemacs-emacs-min-version emacs-version))
    (error (concat "Your version of Emacs (%s) is too old. "
                   "Spacemacs requires Emacs version %s or above.")
           emacs-version spacemacs-emacs-min-version)
  ;; Disable file-name-handlers for a speed boost during init
  (let ((file-name-handler-alist nil))
    (require 'core-spacemacs)

    ;; spacemacs/maybe-install-dotfile #no args
    (defun iimacs/install-spacemacs-dotfile ()
      "Install the dotfile if it does not exist."
      (unless (file-exists-p dotspacemacs-filepath)
        (spacemacs-buffer/set-mode-line "Installing sans wizard" t)
        (when (dotspacemacs/install nil)
          (configuration-layer/load))))
    (add-function :override (symbol-function 'dotspacemacs/maybe-install-dotfile)
                  #'iimacs/install-spacemacs-dotfile)
    (spacemacs|unless-dumping
      (when (boundp 'load-path-backup)
        (setq load-path load-path-backup)))
    ;;(configuration-layer/load-file
    ;; configuration-layer-lock-file)
    ;;(configuration-layer/load-lock-file)
    ;; .lock
    (setq elpa-mirror-dir (concat (file-name-directory load-file-name) "elpa-mirror/"))
    (setq configuration-layer-stable-elpa-name "spacelpa")
    (setq configuration-layer-stable-elpa-version "0.300")
    (setq configuration-layer-elpa-subdirectory "develop")
    ;; git clone https://github.com/ii/elpa-mirror /usr/local/share/emacs/site-lisp/elpa-mirror
    (setq configuration-layer-elpa-archives
          `(("melpa" . ,(concat (file-name-directory load-file-name) "elpa-mirror/melpa/"))
            ("org" . ,(concat  (file-name-directory load-file-name) "elpa-mirror/org/"))
            ("gnu" . ,(concat  (file-name-directory load-file-name) "elpa-mirror/gnu/"))))

    ;; (setq configuration-layer-elpa-archives
    ;;       '(("melpa" . "/usr/local/elpa-mirror/melpa")
    ;;         ("org"   . "/usr/local/elpa-mirror/org/")
    ;;         ("gnu"   . "/usr/local/elpa-mirror/gnu/")))

    ;;(setq configuration-layer-elpa-archives
    ;;  `(("melpa"    . "melpa.org/packages/")
    ;;   ("org"      . "orgmode.org/elpa/")
    ;;    ("gnu"      . "elpa.gnu.org/packages/")
    ;;    ("spacelpa" . ,(concat configuration-layer-stable-elpa-directory
    ;;                           "spacelpa-"
    ;;                           configuration-layer-stable-elpa-version))))

    (setq package-archive-priorities
          '(
                                        ;("spacelpa" . 8)
            ("melpa"    . 4)
            ("org"      . 2)
            ("gnu"      . 1)))
    (spacemacs/init)
    (configuration-layer/stable-elpa-download-tarball)
    (configuration-layer/load)
    (spacemacs/load-yasnippet)
    (let*
        (
         (site-lisp (file-name-directory load-file-name))
         (elpa-path (concat site-lisp "elpa/" (symbol-value 'emacs-version) "/develop/"))
         )
      ;; these are packages we install via spacemacs
      ;; unsure why the paths are not already added
      ;; (add-to-list 'load-path (concat elpa-path "async-20190503.656"))
      ;; (add-to-list 'load-path (concat elpa-path "dash-20190424.1804"))
      ;; (add-to-list 'load-path (concat elpa-path "togetherly-20170426.616"))
      ;;;;(load (concat elpa-path "async-20190503.656/async.el"))
      ;;;;(load (concat elpa-path "dash-20190424.1804/dash.el"))
      ;;;;(load (concat elpa-path "togetherly-20170426.616/togetherly.el"))
      ;; (require 'togetherly)
      ;; These are shipped as part of ii-site-local and are only one file
      ;; I moved these into our modification of the org layer
      (load (concat site-lisp "ob-tmate/ob-tmate.el"))
      (load (concat site-lisp "ob-async/ob-async.el"))
      (load (concat site-lisp "osc52e/osc52e.el"))
      ;; (add-to-list 'yas-snippet-dirs (concat site-lisp "snippets"))
      )
    (yas--load-snippet-dirs)
    (spacemacs-buffer/display-startup-note)
    (spacemacs/setup-startup-hook)
    (spacemacs|unless-dumping
      (global-font-lock-mode)
      (global-undo-tree-mode t)
      (winner-mode t))
    (setq org-confirm-babel-evaluate nil)
    (setq dotspacemacs-enable-server t)
    ;; https://stackoverflow.com/questions/19806176/in-emacs-how-do-i-make-a-local-variable-safe-to-be-set-in-a-file-for-all-possibl
    (put 'org-babel-tmate-default-window-name 'safe-local-variable #'stringp)
    (put 'org-confirm-babel-evaluate 'safe-local-variable #'booleanp)
    ;; (put 'org-confirm-babel-evaluate 'safe-local-variable (lambda (_) t))
    (put 'org-use-property-inheritance 'safe-local-variable (lambda (_) t))
    (put 'org-file-dir 'safe-local-variable (lambda (_) t))
    (put 'eval 'safe-local-variable (lambda (_) t))
    (when (and dotspacemacs-enable-server (not (spacemacs-is-dumping-p)))
      (require 'server)
      (when dotspacemacs-server-socket-dir
        (setq server-socket-dir dotspacemacs-server-socket-dir))
      (unless (server-running-p)
        (message "Starting a server...")
        (server-start)))
    (spacemacs|when-dumping-strict
      (setq load-path-backup load-path)
      ;; disable undo-tree to prevent from segfaulting when loading the dump
      (global-undo-tree-mode -1)
      (setq spacemacs-dump-mode 'dumped)
      (garbage-collect))))

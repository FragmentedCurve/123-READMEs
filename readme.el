;;; Copyright (c) 2025 Paco Pascal <me@pacopascal.com>
;;;
;;; Permission to use, copy, modify, and distribute this software for any
;;; purpose with or without fee is hereby granted, provided that the above
;;; copyright notice and this permission notice appear in all copies.
;;;
;;; THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
;;; WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
;;; MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
;;; ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
;;; WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
;;; ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
;;; OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

;;;
;;; 123-READMEs
;;;
;;; Maintain a single README.org file and use this script to generate
;;; a plain text (README) and a markdown (README.md) version. The
;;; generated markdown is github friendly.
;;;
;;; To use this elisp script, add the following target to your
;;; Makefile,
;;;
;;;     README README.md: README.org
;;;         emacs -Q --batch --script readme.el
;;;

(with-temp-buffer
  ;; Initialize org mode
  (org-mode)
  (add-to-list 'org-export-backends 'md)

  ;; Export plain text README.
  (insert-file-contents "README.org")
  (org-export-to-file 'ascii "README")

  ;; Export a markdown README.
  ;;
  ;; This README.md uses a custom backend that uses
  ;; #+TITLE as a level 1 header. All other headers
  ;; are level 2 or greater.
  (org-export-to-file (org-export-create-backend
                       :parent 'md
                       :transcoders `((headline . ,(lambda (obj content info)
                                                     (format "%s %s\n\n%s"
                                                             (make-string
                                                              (+ 1 (org-export-get-relative-level obj info))
                                                              (string-to-char "#"))
                                                             (org-export-data (org-element-property :title obj) info)
                                                             (if content content ""))))
                                      (template . ,(lambda (content info)
                                                     (let ((title (plist-get info :title)))
                                                       (if title
                                                           (format "# %s\n\n%s" (car title) content)
                                                         content))))))
      "README.md"))

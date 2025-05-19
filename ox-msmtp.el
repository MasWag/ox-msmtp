;;; ox-msmtp.el --- MSMTP Config Backend for Org Export Engine -*- lexical-binding: t; -*-

;; Copyright (C) 2025 Masaki Waga
;;
;; Author: Masaki Waga
;; Version: 1.0
;; Package-Requires: ((emacs "24.4"))
;; Keywords: outlines, org, msmtp
;; Homepage: https://github.com/MasWag/ox-msmtp
;;
;; This file is not part of GNU Emacs.
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; msmtp configuration export for org-mode.
;; This package is largely inspired by ox-ssh.

;;; Code:

(require 'ox)

(defgroup org-export-msmtp nil
  "Options for exporting Org mode files to msmtp config."
  :group 'org-export)

(defcustom org-msmtp-header ""
  "Optional text to be inserted at the top of msmtp config."
  :type 'text
  :group 'org-export-msmtp)

(defcustom org-msmtp-export-suffix ".msmtprc"
  "Suffix added to exported file."
  :type 'text
  :group 'org-export-msmtp)

(defun org-msmtp--user-config ()
  "Return the location of the user's msmtp config."
  (expand-file-name ".msmtprc"
                    (getenv "HOME")))

(org-export-define-backend 'msmtp
  '((headline . org-msmtp-headline)
    (template . org-msmtp-template))
  :menu-entry
  `(?M "Export to msmtp config"
       ((?m "To file" org-msmtp-export-to-config)
        (?M "To temporary buffer" org-msmtp-export-as-config)
        (?x ,(format "To %s" (org-msmtp--user-config))
            org-msmtp-export-overwrite-user-config))))

(defun org-msmtp-headline (headline contents _info)
  "Transform HEADLINE and CONTENTS into an msmtp config entry."
  (let* ((account (org-element-property :raw-value headline)))
    (if account
        (let ((msmtp-host (org-element-property :MSMTP_HOST headline))
              (msmtp-port (org-element-property :MSMTP_PORT headline))
              (msmtp-source-ip (org-element-property :MSMTP_SOURCE_IP headline))
              (msmtp-proxy-host (org-element-property :MSMTP_PROXY_HOST headline))
              (msmtp-proxy-port (org-element-property :MSMTP_PROXY_PORT headline))
              (msmtp-socket (org-element-property :MSMTP_SOCKET headline))
              (msmtp-timeout (org-element-property :MSMTP_TIMEOUT headline))
              (msmtp-protocol (org-element-property :MSMTP_PROTOCOL headline))
              (msmtp-domain (org-element-property :MSMTP_DOMAIN headline))
              (msmtp-auth (org-element-property :MSMTP_AUTH headline))
              (msmtp-user (org-element-property :MSMTP_USER headline))
              (msmtp-password (org-element-property :MSMTP_PASSWORD headline))
              (msmtp-passwordeval (org-element-property :MSMTP_PASSWORDEVAL headline))
              (msmtp-ntlmdomain (org-element-property :MSMTP_NTLM_DOMAIN headline))
              (msmtp-tls (org-element-property :MSMTP_TLS headline))
              (msmtp-tls-starttls (org-element-property :MSMTP_TLS_STARTTLS headline))
              (msmtp-tls-trust-file (org-element-property :MSMTP_TLS_TRUST_FILE headline))
              (msmtp-tls-crl-file (org-element-property :MSMTP_TLS_CRL_FILE headline))
              (msmtp-tls-fingerprint (org-element-property :MSMTP_TLS_FINGERPRINT headline))
              (msmtp-tls-key-file (org-element-property :MSMTP_TLS_KEY_FILE headline))
              (msmtp-tls-cert-file (org-element-property :MSMTP_TLS_CERT_FILE headline))
              (msmtp-tls-certcheck (org-element-property :MSMTP_TLS_CERTCHECK headline))
              (msmtp-tls-priorities (org-element-property :MSMTP_TLS_PRIORITIES headline))
              (msmtp-tls-host-override
               (org-element-property :MSMTP_TLS_HOST_OVERRIDE headline))
              (msmtp-tls-min-dh-prime-bits
               (org-element-property :MSMTP_TLS_MIN_DH_PRIME_BITS headline))
              (msmtp-from (org-element-property :MSMTP_FROM headline))
              (msmtp-from-full-name (org-element-property :MSMTP_FROM_FULL_NAME headline))
              (msmtp-dns-notify (org-element-property :MSMTP_DNS_NOTIFY headline))
              (msmtp-dns-return (org-element-property :MSMTP_DNS_RETURN headline))
              (msmtp-set-from-header (org-element-property :MSMTP_SET_FROM_HEADER headline))
              (msmtp-set-date-header (org-element-property :MSMTP_SET_DATE_HEADER headline))
              (msmtp-set-msgid-header (org-element-property :MSMTP_SET_MSGID_HEADER headline))
              (msmtp-remove-bcc-headers (org-element-property :MSMTP_REMOVE_BCC_HEADERS headline))
              (msmtp-undisclosed-recipients
               (org-element-property :MSMTP_UNDISCLOSED_RECIPIENTS headline))
              (msmtp-logfile (org-element-property :MSMTP_LOGFILE headline))
              (msmtp-logfile-time-format (org-element-property :MSMTP_LOGFILE_TIME_FORMAT headline))
              (msmtp-syslog (org-element-property :MSMTP_SYSLOG headline))
              (msmtp-aliases (org-element-property :MSMTP_ALIASES headline))
              (msmtp-auto-from (org-element-property :MSMTP_AUTO_FROM headline))
              (msmtp-maildomain (org-element-property :MSMTP_MAILDOMAIN headline)))

          ;; If the account name starts with "defaults", we consider it as the default configuration
          (concat (if (string-match "^defaults" account)
                      "\ndefaults"
                    (concat "\naccount " account)) "\n"
                    (when msmtp-host
                      (concat "  host " msmtp-host "\n"))
                    (when msmtp-port
                      (concat "  port " msmtp-port "\n"))
                    (when msmtp-source-ip
                      (concat "  source_ip " msmtp-source-ip "\n"))
                    (when msmtp-proxy-host
                      (concat "  proxy_host " msmtp-proxy-host "\n"))
                    (when msmtp-proxy-port
                      (concat "  proxy_port " msmtp-proxy-port "\n"))
                    (when msmtp-socket
                      (concat "  socket " msmtp-socket "\n"))
                    (when msmtp-timeout
                      (concat "  timeout " msmtp-timeout "\n"))
                    (when msmtp-protocol
                      (concat "  protocol " msmtp-protocol "\n"))
                    (when msmtp-domain
                      (concat "  domain " msmtp-domain "\n"))
                    (when msmtp-auth
                      (concat "  auth " msmtp-auth "\n"))
                    (when msmtp-user
                      (concat "  user " msmtp-user "\n"))
                    (when msmtp-password
                      (concat "  password " msmtp-password "\n"))
                    (when msmtp-passwordeval
                      (concat "  passwordeval " msmtp-passwordeval "\n"))
                    (when msmtp-ntlmdomain
                      (concat "  ntlmdomain " msmtp-ntlmdomain "\n"))
                    (when msmtp-tls
                      (concat "  tls " msmtp-tls "\n"))
                    (when msmtp-tls-starttls
                      (concat "  starttls " msmtp-tls-starttls "\n"))
                    (when msmtp-tls-trust-file
                      (concat "  tls_trust_file " msmtp-tls-trust-file "\n"))
                    (when msmtp-tls-crl-file
                      (concat "  tls_crl_file " msmtp-tls-crl-file "\n"))
                    (when msmtp-tls-fingerprint
                      (concat "  tls_fingerprint " msmtp-tls-fingerprint "\n"))
                    (when msmtp-tls-key-file
                      (concat "  tls_key_file " msmtp-tls-key-file "\n"))
                    (when msmtp-tls-cert-file
                      (concat "  tls_cert_file " msmtp-tls-cert-file "\n"))
                    (when msmtp-tls-certcheck
                      (concat "  tls_certcheck " msmtp-tls-certcheck "\n"))
                    (when msmtp-tls-priorities
                      (concat "  tls_priorities " msmtp-tls-priorities "\n"))
                    (when msmtp-tls-host-override
                      (concat "  tls_host_override " msmtp-tls-host-override "\n"))
                    (when msmtp-tls-min-dh-prime-bits
                      (concat "  tls_min_dh_prime_bits " msmtp-tls-min-dh-prime-bits "\n"))
                    (when msmtp-from
                      (concat "  from " msmtp-from "\n"))
                    (when msmtp-from-full-name
                      (concat "  from_full_name " msmtp-from-full-name "\n"))
                    (when msmtp-dns-notify
                      (concat "  dns_notify " msmtp-dns-notify "\n"))
                    (when msmtp-dns-return
                      (concat "  dns_return " msmtp-dns-return "\n"))
                    (when msmtp-set-from-header
                      (concat "  set_from_header " msmtp-set-from-header "\n"))
                    (when msmtp-set-date-header
                      (concat "  set_date_header " msmtp-set-date-header "\n"))
                    (when msmtp-set-msgid-header
                      (concat "  set_msgid_header " msmtp-set-msgid-header "\n"))
                    (when msmtp-remove-bcc-headers
                      (concat "  remove_bcc_headers " msmtp-remove-bcc-headers "\n"))
                    (when msmtp-undisclosed-recipients
                      (concat "  undisclosed_recipients " msmtp-undisclosed-recipients "\n"))
                    (when msmtp-logfile
                      (concat "  logfile " msmtp-logfile "\n"))
                    (when msmtp-logfile-time-format
                      (concat "  logfile_time_format " msmtp-logfile-time-format "\n"))
                    (when msmtp-syslog
                      (concat "  syslog " msmtp-syslog "\n"))
                    (when msmtp-aliases
                      (concat "  aliases " msmtp-aliases "\n"))
                    (when msmtp-auto-from
                      (concat "  auto_from " msmtp-auto-from "\n"))
                    (when msmtp-maildomain
                      (concat "  maildomain " msmtp-maildomain "\n"))
                    contents))
      "")))

(defun org-msmtp-template (contents _info)
  "Transform CONTENTS into MSMTP config with header."
  (string-trim-left (concat org-msmtp-header "\n"
                            (replace-regexp-in-string "\n\n\n+" "\n\n" contents))))

;;;###autoload
(defun org-msmtp-export-as-config (&optional ASYNC SUBTREEP VISIBLE-ONLY BODY-ONLY EXT-PLIST)
  "Export current buffer to an msmtp config buffer.

If narrowing is active in the current buffer, only transcode its
narrowed part.

If a region is active, transcode that region.

A non-nil optional argument ASYNC means the process should happen
asynchronously.  The resulting buffer should be accessible
through the `org-export-stack' interface.

When optional argument SUBTREEP is non-nil, transcode the
sub-tree at point, extracting information from the headline
properties first.

When optional argument VISIBLE-ONLY is non-nil, don't export
contents of hidden elements.

When optional argument BODY-ONLY is non-nil, only return body
code, without surrounding template.

Optional argument EXT-PLIST, when provided, is a property list
with external parameters overriding Org default settings, but
still inferior to file-local settings."
  (interactive)
  (org-export-to-buffer 'msmtp "*Org msmtp Export*"
    ASYNC SUBTREEP VISIBLE-ONLY BODY-ONLY EXT-PLIST
    (lambda () (conf-mode))))

;;;###autoload
(defun org-msmtp-export-to-config (&optional async subtreep visible-only body-only ext-plist)
  "Export current buffer to an MSMTP config file.

If narrowing is active in the current buffer, only transcode its
narrowed part.

If a region is active, transcode that region.

A non-nil optional argument ASYNC means the process should happen
asynchronously.  The resulting buffer should be accessible
through the `org-export-stack' interface.

When optional argument SUBTREEP is non-nil, transcode the
sub-tree at point, extracting information from the headline
properties first.

When optional argument VISIBLE-ONLY is non-nil, don't export
contents of hidden elements.

When optional argument BODY-ONLY is non-nil, only return body
code, without surrounding template.

Optional argument EXT-PLIST, when provided, is a property list
with external parameters overriding Org default settings, but
still inferior to file-local settings.

Return output file's name."
  (interactive)
  (let ((outfile (org-export-output-file-name org-msmtp-export-suffix subtreep)))
    (org-export-to-file 'msmtp outfile async subtreep visible-only body-only ext-plist)))

;;;###autoload
(defun org-msmtp-export-overwrite-user-config
    (&optional async subtreep visible-only body-only ext-plist)
  "Export current buffer as an MSMTP config file, overwriting $HOME/.msmtprc.

If narrowing is active in the current buffer, only transcode its
narrowed part.

If a region is active, transcode that region.

A non-nil optional argument ASYNC means the process should happen
asynchronously.  The resulting buffer should be accessible
through the `org-export-stack' interface.

When optional argument SUBTREEP is non-nil, transcode the
sub-tree at point, extracting information from the headline
properties first.

When optional argument VISIBLE-ONLY is non-nil, don't export
contents of hidden elements.

When optional argument BODY-ONLY is non-nil, only return body
code, without surrounding template.

Optional argument EXT-PLIST, when provided, is a property list
with external parameters overriding Org default settings, but
still inferior to file-local settings.

Return output file's name."
  (interactive)
  (let ((outfile (org-msmtp--user-config)))
    (when (yes-or-no-p (format "Overwrite %s? " outfile))
      (org-export-to-file 'msmtp outfile async subtreep visible-only body-only ext-plist
                          (lambda (file) (set-file-modes file #o600))))))

(provide 'ox-msmtp)
;;; ox-msmtp.el ends here

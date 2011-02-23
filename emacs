;; -*- Emacs-Lisp -*-

;; Time-stamp: <2011-02-18 23:03:35 Friday by root>

(defconst my-emacs-path "/home/max/Study/emacs.dea/dea-1.3/" "我的emacs相关配置文件的路径")
(defconst my-emacs-my-lisps-path  (concat my-emacs-path "my-lisps/") "我自己写的emacs lisp包的路径")
(defconst my-emacs-lisps-path     (concat my-emacs-path "lisps/") "我下载的emacs lisp包的路径")
(defconst my-emacs-templates-path (concat my-emacs-path "templates/") "Path for templates")

;; 把`my-emacs-lisps-path'的所有子目录都加到`load-path'里面
(load (concat my-emacs-my-lisps-path "my-subdirs"))
(my-add-subdirs-to-load-path my-emacs-lisps-path)
(my-add-subdirs-to-load-path my-emacs-my-lisps-path)

(defvar mswin (equal window-system 'w32) "Non-nil means windows system.")
(defvar use-cua nil "Use CUA mode or not.")

(defvar last-region-beg     nil "Beginning of last region.")
(defvar last-region-end     nil "End of last region.")
(defvar last-region-is-rect nil "Last region is rectangle or not.")
(defvar last-region-use-cua nil "Last region use CUA mode or not.")

(defconst system-head-file-dir (list "/usr/include" "/usr/local/include" "/usr/include/sys") "系统头文件目录")
(defconst user-head-file-dir   (list "." "../hdr" "../include") "用户头文件目录")

;; 个人信息
(setq user-mail-address "max.feng.bao@gmail.com")
(setq user-full-name    "max_feng")

(defconst is-before-emacs-21 (>= 21 emacs-major-version) "是否是emacs 21或以前的版本")
(defconst is-after-emacs-23  (<= 23 emacs-major-version) "是否是emacs 23或以后的版本")

(require 'util)

;; 尽快显示按键序列
(setq echo-keystrokes 0.1)

(setq system-time-locale "C")

;; mule-gbk
(unless is-after-emacs-23
  (load "my-mule-gbk")
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (set-language-environment   'utf-8))

(load "cua-settings")

(load "mark-settings")

;; 滚动条放到右边来
(if mswin
    ;; TODO: windows下如果没有滚动栏的话describe系列命令
    ;; 运行的时候有点问题
    (customize-set-variable 'scroll-bar-mode 'right)
  (customize-set-variable 'scroll-bar-mode nil))

;; `mode-line'显示格式
(load "mode-line-settings")

;; 矩形区域操作
(load "rect-mark-settings")

;; 语法高亮
(global-font-lock-mode t)

(load "compile-settings")

;; 显示匹配的括号
(show-paren-mode t)

;; Emacs找不到合适的模式时，缺省使用text-mode
(setq default-major-mode 'text-mode)

;; 显示列号
(setq column-number-mode t)

(define-key global-map (kbd "<escape> SPC") 'just-one-space)

;; ffap,打开当前point的文件
(require 'ffap)
(ffap-bindings)
(setq ffap-c-path (append ffap-c-path system-head-file-dir user-head-file-dir))
(global-set-key (kbd "C-x f") 'ffap)

;; 饥饿的删除键
(add-hook 'c-mode-common-hook
          (lambda ()
            (c-toggle-hungry-state)))
(add-to-list 'auto-mode-alist '("\\.h$" . c++-mode))

;; 用来显示当前光标在哪个函数
(require 'which-func)
(which-func-mode 1)
(setq which-func-unknown "unknown")

;; 打开压缩文件时自动解压缩
;; 必须放在session前面
(require 'jka-compr)
(auto-compression-mode 1)

;; 支持emacs和外部程序的粘贴
(setq x-select-enable-clipboard t)

;; 去掉fringe
(when window-system
  (fringe-mode 0))

;; ibuffer
(if is-before-emacs-21 (load "ibuffer-for-21"))
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; cedet
(load "cedet-settings")

;; ecb
(require 'ecb-autoloads)
(defun ecb ()
  "启动ecb"
  (interactive)
  (ecb-activate)
  (ecb-layout-switch "left9"))

;; 当你在shell、telnet、w3m等模式下时，必然碰到过要输入密码的情况,此时加密显出你的密码
(add-hook 'comint-output-filter-functions 'comint-watch-for-password-prompt)

;; doxygen
(require 'doxymacs)
(add-hook 'c-mode-common-hook 'doxymacs-mode)
(defun my-doxymacs-font-lock-hook ()
  (if (or (eq major-mode 'c-mode) (eq major-mode 'c++-mode))
      (doxymacs-font-lock)))
(add-hook 'font-lock-mode-hook 'my-doxymacs-font-lock-hook)

(load "autoconf-mode-settings")

;; base64
(require 'base64)

;; all,可以象occur一样把东西查出来，并且直接在上面修改，
;; 会把原来的文件中的东西也修改掉
(autoload 'all "all" nil t)

;; frame-cmds.el必须放在multi-term前面,否则ediff退出时会出现错误
;; 而icicles soft-requires frame-cmds.el, 所以icicles也必须放在multi-term前面
;; emacs22下也必须放在kde-emacs前面, 否则会说shell-command是void-function
(load "icicles-settings")
(load "doremi-settings")
(load "palette-settings")
(load "info+-settings")

;; kde-emacs
(require 'kde-emacs)
(setq magic-keys-mode nil)
(setq kde-tab-behavior 'indent)
(define-key c++-mode-map (kbd "C-c C-b") 'agulbra-make-member)

;; edit-settings中对M-w重新定义,但是kde-emacs中也对其定义了
;; 所以必须要放在kde-emacs后面
(load "edit-settings")

;; sourcepair,可以在cpp与h文件之间切换
(require 'sourcepair)
(define-key c-mode-map (kbd "C-c s") 'sourcepair-load)
(define-key c++-mode-map (kbd "C-c s") 'sourcepair-load)
(setq sourcepair-source-path '( "." "../src"))
(setq sourcepair-header-path user-head-file-dir)
(setq sourcepair-recurse-ignore '("CVS" "bin" "lib" "Obj" "Debug" "Release" ".svn"))

;; c-include,找出cpp中所有include的头文件
(require 'c-includes)
(setq c-includes-binding t)
(setq c-includes-path ffap-c-path)

;; emacs lock
(autoload 'toggle-emacs-lock "emacs-lock" "Emacs lock" t)

;; `gdb'
(load "gud-settings")

;; subversion
(load "svn-settings")

(load "vc-settings")

;; 在状态栏显示日期时间
(setq display-time-day-and-date t)
(display-time)

;; 用M-x执行某个命令的时候，在输入的同时给出可选的命令名提示
(icomplete-mode 1)
(define-key minibuffer-local-completion-map (kbd "SPC") 'minibuffer-complete-word)
;; minibuffer中输入部分命令就可以使用补全
(unless is-after-emacs-23
  (partial-completion-mode 1))

;; hippie expand
(load "hippie-expand-settings")

(require 'sh-script)

;; 增加自定义关键字
(dolist (mode '(c-mode c++-mode java-mode lisp-mode emacs-lisp-mode lisp-interaction-mode sh-mode
                       sgml-mode))
  (font-lock-add-keywords mode
                          '(("\\<\\(FIXME\\|TODO\\|Todo\\|HACK\\):" 1 font-lock-warning-face prepend)
                            ("\\<\\(and\\|or\\|not\\)\\>" . font-lock-keyword-face)
                            ("(\\|)" . beautiful-blue-face)
                            ("\\[\\|]" . yellow-face)
                            ("<\\|>" . cyan-face)
                            ("{\\|}" . green-face))))
(font-lock-add-keywords 'ruby-mode '(("\\<require\\>" . font-lock-keyword-face)))

;; xcscope
;; (require 'xcscope)
;; 设置初始目录
;; (cscope-set-initial-directory "~/work")
;; 告诉emacs别自动更新cscope.out
;; (setq cscope-do-not-update-database t)

;; hide region
(require 'hide-region)
(setq hide-region-before-string "[======================该区域已")
(setq hide-region-after-string "被折叠======================]\n")
(global-set-key (kbd "C-x M-r") 'hide-region-hide)
(global-set-key (kbd "C-x M-R") 'hide-region-unhide)

;; hide lines
(require 'hide-lines)

;; 自动打开图片
;;(load "image-mode-settings")

;; 启用以下功能
(put 'narrow-to-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)

;; 方便的在kill-ring里寻找需要的东西
(load "browse-kill-ring-settings")

;; 非常方便的切换buffer和打开文件
(load "ido-settings")

;; 不显示Emacs的开始画面
(setq inhibit-startup-message t)
(setq initial-scratch-message "")

;; 显示行号
(load "displn-mode-settings")

;; 设置etags文件
(setq tags-file-name "~/work/TAGS")

(defun generate-tag-table ()
  "Generate tag tables under current directory(Linux)."
  (interactive)
  (let ((exp "") (dir ""))
    (setq dir (read-from-minibuffer "generate tags in: " default-directory)
          exp (read-from-minibuffer "suffix: "))
    (with-temp-buffer
      (shell-command
       (concat "find " dir " -name \"" exp "\" | xargs etags ")
       (buffer-name)))))

;; 不要总是没完没了的问yes or no, 为什么不能用y/n
(fset 'yes-or-no-p 'y-or-n-p)

(require 'ahei-face)
(require 'color-theme-ahei)
(require 'face-settings)

;; 高亮当前行
(load "hl-line-settings")

(when (and window-system is-after-emacs-23)
  (load "my-fontset-win")
  (if mswin
      (huangq-fontset-courier 14)
    ;; (huangq-fontset-dejavu 17)))
    (huangq-fontset-fixedsys 17)))

;; 高亮显示C/C++中的可能的错误(CWarn mode)
(global-cwarn-mode 1)

;; 实现程序变量得自动对齐
(require 'align)
(global-set-key "\C-x\C-j" 'align)

;; 不要menu-bar和tool-bar
;; (unless window-system
;;   (menu-bar-mode -1))
(menu-bar-mode -1)
;; GUI下显示toolbar的话select-buffer会出问题
(if (fboundp 'tool-bar-mode)
    (tool-bar-mode -1))

;; 不要闪烁光标, 烦不烦啊
(blink-cursor-mode -1)

;; diff
(load "diff-settings")

;; ediff
(load "ediff-settings")

;; 最近打开的文件
(load "recentf-settings")

;; Xrefactory
(load "xref-settings")

;; color-moccur
(load "moccur-settings")

(load "isearch-settings")

;; 非常酷的一个扩展。可以“所见即所得”的编辑一个文本模式的表格
(if is-before-emacs-21 (load "table-for-21"))
(autoload 'table-insert "table" "WYGIWYS table editor")

;; 把文件或buffer彩色输出成html
;;(require 'htmlize)

;; time-stamp
(add-hook 'write-file-hooks 'time-stamp)
(setq time-stamp-format "%04y-%02m-%02d %02H:%02M:%02S %:a by %u")

;; hs-minor-mode,折叠代码
(load "hs-minor-mode-settings")

;; 输入左大花扩号自动补齐右大花括号
(dolist (map (list c-mode-base-map awk-mode-map))
  (define-kbd map "{" 'skeleton-c-mode-left-brace))
(defun skeleton-c-mode-left-brace (arg)
  (interactive "P")
  (if  (c-in-literal (c-most-enclosing-brace (c-parse-state)))
      (self-insert-command 1)
    ;; auto insert complex things.
    (let* ((current-line (delete-and-extract-region (line-beginning-position) (line-end-position)))
           (lines (and arg (mark t) (delete-and-extract-region (mark t) (point))))
           (after-point (make-marker)))
       ;;; delete extra blank begin and after the LINES
      (setq lines (and lines
                       (with-temp-buffer
                         (insert lines)
                         (beginning-of-buffer)
                         (delete-blank-lines)
                         (delete-blank-lines)
                         (end-of-buffer)
                         (delete-blank-lines)
                         (delete-blank-lines)
                         (buffer-string))))
      (save-excursion
        (let* ((old-point (point)))
          (insert (if current-line current-line "")  "{\n")
          (and lines (insert lines))
          (move-marker after-point (point))
          (insert "\n}")
          (indent-region old-point (point) nil)))
      (goto-char after-point)
      (c-indent-line))))

(if is-before-emacs-21
    (progn
      ;; gnuserv
      (require 'gnuserv-compat)
      (gnuserv-start)
      ;; 在当前frame打开
      (setq gnuserv-frame (selected-frame))
      ;; 打开后让emacs跳到前面来
      (setenv "GNUSERV_SHOW_EMACS" "1"))
  (if is-after-emacs-23
      (server-force-delete))
  (server-start))

;; snavigator
(require 'sn)

;; 用一个很大的kill ring. 这样防止我不小心删掉重要的东西
(setq kill-ring-max 200)

;; 把fill-column设为80. 这样的文字更好读
(setq default-fill-column 80)

;; ebrowse
(require 'ebrowse)
(add-to-list 'auto-mode-alist '("BROWSE\\.*" . ebrowse-tree-mode))

;; 在行首C-k时，同时删除该行
(setq-default kill-whole-line t)

;; 定义只读buffer中的编辑命令
(load  "edit-rdonly")

;; 为各种只读mode加入vi的按键
(require 'man)
(require 'apropos)
(require 'log-view)
(require 'diff-mode)
(let ((list (list view-mode-map Man-mode-map apropos-mode-map completion-list-mode-map
                  log-view-mode-map compilation-mode-map diff-mode-map)))
  (unless is-before-emacs-21
    (require 'grep)
    (setq list (append list (list grep-mode-map))))
  (dolist (map list)
    (define-key map "h" 'backward-char)
    (define-key map "l" 'forward-char)
    (define-key map "j" 'next-line)
    (define-key map "k" 'previous-line)
    (define-key map "J" 'roll-down)
    (define-key map "K" 'roll-up)
    (define-key map "b" 'backward-word-remember)
    (define-key map "w" 'forward-word-or-to-word-remember)
    (define-key map "y" 'copy-region-as-kill-nomark)
    (define-key map "c" 'copy-region-as-kill-nomark)
    (define-key map "o" 'other-window)
    (define-key map "G" 'end-of-buffer)
    (if is-before-emacs-21
        (progn
          (define-key map "a" 'beginning-of-line)
          (define-key map "e" 'end-of-line))
      (define-key map "a" 'move-beginning-of-line)
      (define-key map "e" 'move-end-of-line))))

(load "view-mode-settings")

(load "apropos-settings")

(load "completion-list-mode-settings")

;; 显示ascii表
(require 'ascii)

;; 模拟鼠标滚轮
;; TODO: 怎样把他们绑定到C-m和C-i
(global-set-key "\M-g" 'roll-down)
(defun roll-down (&optional n)
  "simulate roll down"
  (interactive "P")
  (if (null n) (setq n 7))
  (next-line n))
(global-set-key "\M-o" 'roll-up)
(defun roll-up (&optional n)
  "simulate roll up"
  (interactive "P")
  (if (null n) (setq n 7))
  (previous-line n))

;; 重新定义`help-command',因为C-h已经绑定为删除前面的字符
(global-set-key (kbd "C-x /") 'help-command)

;; 定义一些emacs 21没有的函数
(if is-before-emacs-21 (load "for-emacs-21"))

;; 简写模式
(setq-default abbrev-mode t)
(setq save-abbrevs nil)

;; 超强的abbrev
(load "msf-abbrev-settings")

;; snippet
(add-hook 'c++-mode-hook
          (lambda ()
            (setq snippet-field-default-beg-char ?\()
            (setq snippet-field-default-end-char ?\))
            (setq snippet-exit-identifier "$;")))

;; 按下C-x k立即关闭掉当前的buffer
(global-set-key (kbd "C-x k") 'kill-this-buffer)

;; 可以为重名的buffer在前面加上其父目录的名字来让buffer的名字区分开来，而不是单纯的加一个没有太多意义的序号
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; 以目录形式显示文档
(load "linkd-settings")

;; 非常方便的查看emacs帮助的插件
(require 'describe-symbol)
(require 'find-symbol)

(load "describe-find-symbol-settings")

(load "man-settings")

;; `debugger-mode'按键设置
(define-key debugger-mode-map "o" 'other-window)

;; 快速include一个系统/用户头文件
(mapc
 (lambda (mode)
   (define-abbrev-table mode '(("incy" "" skeleton-include 1)))
   (define-abbrev-table mode '(("incz" "" skeleton-include-user 1))))
 '(c-mode-abbrev-table c++-mode-abbrev-table))

;; 输入incy,可以自动提示输入文件名称,可以自动补全.
(define-skeleton skeleton-include
  "产生#include<>" "" > "#include <"
  (completing-read "包含系统头文件: "
                   (mapcar #'(lambda (f) (list f ))
                           (apply 'append (mapcar #'(lambda (dir) (directory-files dir))
                                                  system-head-file-dir)))) ">\n")
(define-skeleton skeleton-include-user
  "产生#include\"\"" "" > "#include \""
  (completing-read "包含用户头文件: "
                   (mapcar #'(lambda (f) (list f ))
                           (apply 'append (mapcar #'(lambda (dir) (directory-files dir))
                                                  user-head-file-dir)))) "\"\n")

(defvar c/c++-hightligh-included-files-key-map nil)
(unless c/c++-hightligh-included-files-key-map
  (setq c/c++-hightligh-included-files-key-map (make-sparse-keymap))
  (apply-define-key
   c/c++-hightligh-included-files-key-map
   `(("<RET>"    find-file-at-point)
     ("<return>" find-file-at-point))))

(defun c/c++-hightligh-included-files ()
  (interactive)
  (when (or (eq major-mode 'c-mode)
            (eq major-mode 'c++-mode))
    (save-excursion
      (goto-char (point-min))
      ;; remove all overlay first
      (mapc (lambda (ov) (if (overlay-get ov 'c/c++-hightligh-included-files)
                             (delete-overlay ov)))
            (overlays-in (point-min) (point-max)))
      (while (re-search-forward "^[ \t]*#include[ \t]+[\"<]\\(.*\\)[\">]" nil t nil)
        (let* ((begin  (match-beginning 1))
               (end (match-end 1))
               (ov (make-overlay begin end)))
          (overlay-put ov 'c/c++-hightligh-included-files t)
          (overlay-put ov 'keymap c/c++-hightligh-included-files-key-map)
          (overlay-put ov 'face 'underline))))))
;; 这不是一个好办法，也可以把它加载到c-mode-hook or c++-mode-hook中
(setq c/c++-hightligh-included-files-timer (run-with-idle-timer 0.5 t 'c/c++-hightligh-included-files))

;; 缩进设置
(require 'cl)
;; 不用TAB字符来indent
(setq-default indent-tabs-mode nil)
(setq default-tab-width 4)
(setq tab-stop-list nil)
(loop for x downfrom 40 to 1 do
      (setq tab-stop-list (cons (* x tab-width) tab-stop-list)))

;; 自动的在文件末增加一新行
(setq require-final-newline t)

;; 防止页面滚动时跳动,scroll-margin 3可以在靠近屏幕边沿3行时就开始滚动,可以很好的看到上下文
(setq scroll-margin 3
      scroll-conservatively 10000)

(load "dired-settings")

(defun ywb-indent-accoding-to-paren ()
  "按块([]{}())来格式化代码"
  (interactive)
  (let ((prev-char (char-to-string (preceding-char)))
        (next-char (char-to-string (following-char)))
        (pos (point)))
    (save-excursion
      (cond ((string-match "[[{(<]" next-char)
             (indent-region pos (progn (forward-sexp 1) (point)) nil))
            ((string-match "[\]})>]" prev-char)
             (indent-region (progn (backward-sexp 1) (point)) pos nil))))))
(global-set-key (kbd "C-M-]") 'ywb-indent-accoding-to-paren)

;; 方便的切换major mode
(defvar switch-major-mode-last-mode nil)

(defun major-mode-heuristic (symbol)
  (and (fboundp symbol)
       (string-match ".*-mode$" (symbol-name symbol))))

(defun switch-major-mode (mode)
  "切换major mode"
  (interactive
   (let ((fn switch-major-mode-last-mode) val)
     (setq val
           (completing-read
            (if fn (format "切换major-mode为(缺省为%s): " fn) "切换major mode为: ")
            obarray 'major-mode-heuristic t nil nil (symbol-name fn)))
     (list (intern val))))
  (let ((last-mode major-mode))
    (funcall mode)
    (setq switch-major-mode-last-mode last-mode)))
(global-set-key (kbd "C-x q") 'switch-major-mode)

(defun get-mode-name ()
  "显示`major-mode'及`mode-name'"
  (interactive)
  (message "major-mode为%s, mode-name为%s" major-mode mode-name))
(global-set-key (kbd "C-x m") 'get-mode-name)

(autoload 'list-processes+ "list-processes+" "增强的`list-processes'命令" t)

;; 没有提示音,也不闪屏
;;(setq ring-bell-function 'ignore)

;; 默认目录
(setq default-directory "~/")

(defun revert-buffer-no-confirm ()
  "执行`revert-buffer'时不需要确认"
   (interactive)
   (let ((is-view (if view-mode 1 -1)))
   (when (buffer-file-name)
     (revert-buffer buffer-file-name t)
     (view-mode is-view))))
(global-set-key "\C-xu" 'revert-buffer-no-confirm)

(defun count-brf-lines (&optional is-fun)
  "显示当前buffer或region或函数的行数和字符数"
  (interactive "P")
  (let (min max)
    (if is-fun
        (save-excursion
          (beginning-of-defun) (setq min (point))
          (end-of-defun) (setq max (point))
          (message "当前函数%s内共有%d行, %d个字符" (which-function) (count-lines min max) (- max min)))
      (if mark-active
          (progn
            (setq min (min (point) (mark)))
            (setq max (max (point) (mark))))
        (setq min (point-min))
        (setq max (point-max)))
      (if (or (= 1 (point-min)) mark-active)
          (if mark-active
              (message "当前region内共有%d行, %d个字符" (count-lines min max) (- max min))
            (message "当前buffer内共有%d行, %d个字符" (count-lines min max) (- max min)))
        (let ((nmin min) (nmax max))
          (save-excursion
            (save-restriction
              (widen)
              (setq min (point-min))
              (setq max (point-max))))
          (message "narrow下buffer内共有%d行, %d个字符, 非narrow下buffer内共有%d行, %d个字符"
                   (count-lines nmin nmax) (- nmax nmin) (count-lines min max) (- max min)))))))
(global-set-key (kbd "C-x l") 'count-brf-lines)
(global-set-key (kbd "C-x L") '(lambda () (interactive) (count-brf-lines t)))

;; 可以递归的使用minibuffer
(setq enable-recursive-minibuffers t)

(defun goto-paren ()
  "跳到匹配的括号"
  (interactive)
  (cond
   ((looking-at "[ \t]*[[\"({]") (forward-sexp) (backward-char))
    ((or (looking-at "[]\")}]") (looking-back "[]\")}][ \t]*")) (if (< (point) (point-max)) (forward-char)) (backward-sexp))
   (t (message "找不到匹配的括号"))))
(global-set-key "\C-]" 'goto-paren)

(defun switch-to-other-buffer ()
  "切换到最近访问的buffer"
  (interactive)
  (switch-to-buffer (other-buffer)))
(global-set-key "\e'" 'switch-to-other-buffer)

;; `sh-mode'
(load "sh-mode-settings")

;; 增加更丰富的高亮
(require 'generic-x)

(defun switch-to-scratch ()
  "切换到*scratch*"
  (interactive)
  (let ((buffer (get-buffer-create "*scratch*")))
    (switch-to-buffer buffer)
    (unless (equal major-mode 'lisp-interaction-mode)
      (lisp-interaction-mode))))
(global-set-key (kbd "C-x s") 'switch-to-scratch)

(load "info-settings")

(global-set-key (kbd "C-x M-e") 'toggle-debug-on-error)
(global-set-key (kbd "C-x Q") 'toggle-debug-on-quit)

(defun visit-.emacs ()
  "访问.emacs文件"
  (interactive)
  (find-file (concat my-emacs-path ".emacs")))
(global-set-key (kbd "C-x E") 'visit-.emacs)

(require 'find-func)

(define-key lisp-interaction-mode-map (kbd "C-j") 'goto-line)
(define-key lisp-interaction-mode-map (kbd "M-j") 'eval-print-last-sexp)

(load "grep-settings")

;; 可以显示空白,tab
(require 'blank-mode)

;; `hide-ifdef-mode'
(load "hide-ifdef-settings")

;; 自动插入一些文件模板,用template
(load "template-settings")

(defvar global-map-key-pairs
  `(("M-r"     query-replace-sb)
    ("ESC M-%" query-replace-regexp-sb)
    ("ESC M-r" query-replace-regexp-sb)
    ("C-x M-r" query-replace-regexp-sb)
    ("M-z"     zap-to-char-sb)
    ("C-x C-s" save-buffer-sb))
  "*Key pairs for `global-map'.")
(apply-map-define-keys 'global-map)

(load "recent-jump-settings")

(require 'mic-paren)
(paren-activate)
(setq paren-message-show-linenumber 'absolute)

;; 使终端支持鼠标
(define-key global-map (kbd "C-x T") 'xterm-mouse-mode)

(load "help-mode-settings")

;; 为不同层次的ifdef着色
(require 'ifdef)
(define-key c-mode-base-map (kbd "C-c I") 'mark-ifdef)

;; 统计命令使用频率
(require 'command-frequence)

(require 'post-command-hook)

(dolist (hook (list 'java-mode-hook))
  (add-hook hook
            '(lambda ()
               (c-set-style "kde-c++"))))

(load "sgml-mode-settings")

;; ruby
(load "ruby-settings")

;; rails
(load "rails-settings")

;; (load "company-settings")

(require 'php-mode)

;; w3m
;;(load "w3m-settings")

(require 'sql)
(define-key sql-interactive-mode-map (kbd "M-m") 'comint-previous-matching-input)
(define-key sql-interactive-mode-map (kbd "M-M") 'comint-next-matching-input)

;; 以另一用户编辑文件, 或者编辑远程主机文件
(require 'tramp)
(setq tramp-default-method "sudo")

;; erc
(require 'erc-nicklist)

;; spell check
(setq-default ispell-program-name "aspell")

(define-key global-map (kbd "C-q") 'quoted-insert-sb)

(define-key global-map (kbd "C-x a") 'align)
(define-key global-map (kbd "C-x M-a") 'align-regexp)

(when
    (load (expand-file-name (concat my-emacs-lisps-path "package.el")))
  (package-initialize))

(require 'auto-install)
(setq auto-install-directory (concat my-emacs-lisps-path "auto-install"))

(load "auto-complete-settings")


(dolist (map (list conf-javaprop-mode-map html-mode-map))
  (define-key map (kbd "C-c C-c") 'comment))

(if is-after-emacs-23
  (require 'doc-view)
  (setq doc-view-conversion-refresh-interval 3))

;; 像linux系统下alt-tab那样选择buffer, 但是更直观, 更方便
(require 'select-buffer)

(load "multi-term-settings")

(load "anything-settings")

(require 'ioccur)

;; 查询天气预报
;;(load "weather-settings")

;; 可以把光标由方块变成一个小长条
(require 'bar-cursor)

(define-key global-map (kbd "C-x M-n") 'next-buffer)
(define-key global-map (kbd "C-x M-p") 'previous-buffer)

(defun goto-my-emacs-lisps-dir ()
  "Goto `my-emacs-lisps-path'."
  (interactive)
  (dired my-emacs-lisps-path))
(defun goto-my-emacs-my-lisps-dir ()
  "Goto `my-emacs-my-lisps-path'."
  (interactive)
  (dired my-emacs-my-lisps-path))
(defun goto-my-emacs-dir ()
  "Goto `my-emacs-path'."
  (interactive)
  (dired my-emacs-path))
(define-key global-map (kbd "C-x G l") 'goto-my-emacs-lisps-dir)
(define-key global-map (kbd "C-x G m") 'goto-my-emacs-my-lisps-dir)
(define-key global-map (kbd "C-x G e") 'goto-my-emacs-dir)

(defun svn-status-my-emacs-dir ()
  "Run `svn-status' in `my-emacs-path'."
  (interactive)
  (svn-status my-emacs-path))
(define-key global-map (kbd "C-x M-v") 'svn-status-my-emacs-dir)

(load "highlight-parentheses-settings")

(define-key global-map (kbd "C-x M-c") 'describe-char)

(load "maxframe-settings")

(setq my-shebang-patterns
      (list "^#!/usr/.*/perl\\(\\( \\)\\|\\( .+ \\)\\)-w *.*"
            "^#!/usr/.*/sh"
            "^#!/usr/.*/bash"
            "^#!/bin/sh"
            "^#!/.*/perl"
            "^#!/.*/awk"
            "^#!/.*/sed"
            "^#!/bin/bash"))
(add-hook
 'after-save-hook
 (lambda ()
   (if (not (= (shell-command (concat "test -x " (buffer-file-name))) 0))
       (progn
         ;; This puts message in *Message* twice, but minibuffer
         ;; output looks better.
         (message (concat "Wrote " (buffer-file-name)))
         (save-excursion
           (goto-char (point-min))
           ;; Always checks every pattern even after
           ;; match.  Inefficient but easy.
           (dolist (my-shebang-pat my-shebang-patterns)
             (if (looking-at my-shebang-pat)
                 (if (= (shell-command
                         (concat "chmod u+x " (buffer-file-name)))
                        0)
                     (message (concat
                               "Wrote and made executable "
                               (buffer-file-name))))))))
     ;; This puts message in *Message* twice, but minibuffer output
     ;; looks better.
     (message (concat "Wrote " (buffer-file-name))))))

(load "auto-insert-settings")

(load "eldoc-settings")

(load "yasnippet-settings")

(apply-args-list-to-fun
 `def-execute-command-on-current-file-command
  `("dos2unix" "unix2dos"))
(define-key global-map (kbd "C-x M-D") 'dos2unix-current-file)

(load "autopair-settings")

(define-key minibuffer-local-completion-map (kbd "C-k") 'kill-line)

(define-key global-map (kbd "C-x M-k") 'Info-goto-emacs-key-command-node)

(defalias 'cpp-mode 'c++-mode)

;; color theme
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)))

(require 'cursor-change)
(cursor-change-mode 1)

(load "html-mode-settings")

;; 回车后indent
(dolist (map (list lisp-mode-map emacs-lisp-mode-map lisp-interaction-mode-map sh-mode-map
                   (if (not is-before-emacs-21) awk-mode-map) java-mode-map
                   ruby-mode-map shell-mode-map c-mode-base-map))
  (define-key map (kbd "RET") 'newline-and-indent)
  (define-key map (kbd "<return>") 'newline-and-indent))

(define-key text-mode-map (kbd "M-s") 'view)

;; session,可以保存很多东西，例如输入历史(像搜索、打开文件等的输入)、
;; register的内容、buffer的local variables以及kill-ring和最近修改的文件列表等。非常有用。
(require 'my-session)
(add-hook 'after-init-hook 'session-initialize)

(load "desktop-settings")

(sb-update)

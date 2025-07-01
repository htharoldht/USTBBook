% USTBBook.cls - Class file for USTBBook document class
%
% This file defines the USTBBook document class, which is used for
% creating books in the USTB (University of Science and Technology
% Beijing) format.
%
% Author: 黄腾
% Date: 2025-07-01

\NeedsTeXFormat{LaTeX2e}[2017/04/01]
\RequirePackage{expl3}
\ProvidesExplPackage {USTBBook} {2025/07/01} {v0.1.0}{LaTeX Book template for USTB}

% 检查 LaTeX2e kernel 版本
\msg_new:nnn { USTBBook } { latex-too-old }
{ TeX~ Live~ 2020~ or~ later~ version~ is~ required~ to~ compile~ this~ document. }
\@ifl@t@r \fmtversion { 2020/02/02 }
{ }
{ \msg_fatal:nn { USTBBook } { latex-too-old } }

% 检查编译引擎，要求使用 XeLaTeX。
\msg_new:nnn { USTBBook } { incompatible-engine }
{ XeLaTeX~ is~ required~ to~ compile~ this~ document. }

\sys_if_engine_xetex:F
{ \msg_fatal:nn { USTBBook } { incompatible-engine } }

% 使用 l3keys 定义 \examsetup 配置命令
\NewDocumentCommand \ustbsetup { m }
{ \keys_set:nn { USTBBook } {#1} }

% 加载文档类和宏包

% 处理文档类选项
\PassOptionsToClass { UTF8 , scheme = chinese, openright } { ctexbook }
\DeclareOption* { \PassOptionsToClass { \CurrentOption } { ctexbook } }
\ProcessOptions*

\RequirePackage { filehook }
\AtEndOfPackageFile* { fontspec }
{ \msg_redirect_name:nnn { fontspec } { no-script } { none } }
\AtEndOfPackageFile* { xeCJK }
{
  \msg_redirect_name:nnn { xeCJK } { CJKfamily-redef } { none }
  \defaultCJKfontfeatures
  {
    Script  = CJK,
  }
}

% 载入 \cls{ctexbook} 文档类。
\LoadClass { ctexbook }

% 要求 ctex v2.4.9 2017-04-01 或更高的版本。
\msg_new:nnn { USTBBook } { require-package-version }
{ The~ package~ "#1"~ is~ required. }

\@ifclasslater { ctexbook } { 2017/04/01 }
{ }
{
  \msg_fatal:nnn { USTBBook } { require-package-version }
  { ctex~ v2.4.9~ 2017-04-01 }
}

% 建议在模板开始处载入全部宏包，不要轻易改变加载顺序。
\RequirePackage { etoolbox }
\RequirePackage [
  a4paper,
  hmargin = { 20mm, 25mm },
  vmargin = { 25mm, 25mm },
  headheight = 15pt,
] { geometry }
\RequirePackage { fontspec }
\RequirePackage { xeCJK }
\RequirePackage { xeCJKfntef }
\RequirePackage { fancyhdr }
\RequirePackage { lastpage }
\RequirePackage { amsmath }
\RequirePackage [ shortlabels ] { enumitem }
\RequirePackage { titlesec }
\RequirePackage { varwidth }
\RequirePackage { ocgx2 }

\RequirePackage { exam-zh-question }
\RequirePackage { exam-zh-font }
\RequirePackage { exam-zh-choices }
\RequirePackage { exam-zh-symbols }
\RequirePackage { exam-zh-textfigure }
\RequirePackage { exam-zh-math }

% 页眉页脚设置
\pagestyle{fancy}
\renewcommand\headrulewidth{0pt}
\fancyhf{}
\fancyfoot[RO,LE]{\sffamily \zihao{5} {\thepage}}

\AtEndPreamble
{
  \RequirePackage { hyperref }
  \hypersetup
  {
    bookmarksnumbered = true,
    colorlinks        = true,
    linkcolor         = black,
    urlcolor          = black,
    citecolor         = black,
    filecolor         = black,
    psdextra          = true,
    unicode           = true
  }
}

% 生成函数变体
\cs_generate_variant:Nn \tl_map_inline:nn { xn }

% 标点处理
\tl_const:Nn \c__ustbbook_fwid_full_stop_tl { ^^^^ff0e }

\keys_define:nn { USTBBook }
{ style .meta:nn = { USTBBook / style } {#1} }
\keys_define:nn { USTBBook / style }
{
  fullwidth-stop .choice:,
  fullwidth-stop .value_required:n = true,
  fullwidth-stop / catcode .code:n =
    {
      \__ustbbook_set_fullwidth_stop_catcode:
    },
  fullwidth-stop / false .code:n = { }
}
\cs_new:Npn \__ustbbook_set_fullwidth_stop_catcode:
{
  \char_set_active_eq:NN ^^^^3002 \c__ustbbook_fwid_full_stop_tl
  \char_set_catcode_active:N ^^^^3002
}

\keys_set:nn { USTBBook / style }
{
  fullwidth-stop = false
}

% 字体

% 中文字体

% 在 ctex 的字体配置的基础上进行一些修改
% 将苹方和微软雅黑分别替换为华文黑体和中易黑体

\str_if_eq:onTF { \g__ctex_fontset_tl } { mac }
{
  % \setCJKmainfont{Source~Han~Serif~SC}
  %   [
  %     ItalicFont     = FZKai-Z03,
  %   ]
  \setCJKsansfont { Heiti~ SC~ Light } [ BoldFont = Heiti~ SC~ Medium ]
}
{
  \str_if_eq:onT { \g__ctex_fontset_tl } { windows }
  {
    % \setCJKmainfont{Source~Han~Serif~SC}
    %   [
    %     ItalicFont     = FZKai-Z03,
    %   ]
    \setCJKsansfont { SimHei }
  }
}

% 罗马数字使用中文字体
\xeCJKDeclareCharClass { CJK } { "2160 -> "217F }
% 带圈数字
\xeCJKDeclareCharClass { CJK } { "2460 -> "2473 }

% 如果有内容较高（如分式）使得行间距小于 0.5em，则将其增加至 0.5em。
\dim_set:Nn \lineskiplimit { .5em }
\skip_set:Nn \lineskip { .5em }

% 增加对 minipage 的处理
% https://tex.stackexchange.com/a/358080/246645
\dim_set:Nn \normallineskiplimit { .5em }
\skip_set:Nn \normallineskip { .5em }

% 兼容 siunitx v2.x 的一些命令
\AtEndOfPackageFile* { siunitx }
{
  \ProvideDocumentCommand \unit       { } { \si }
  \ProvideDocumentCommand \qty        { } { \SI }
  \ProvideDocumentCommand \qtyproduct { } { \SI }
}

% 脚注
% 摘自 fduthesis.cls

\cs_new_protected:Npn \__ustbbook_define_fn_style:nn #1#2
{ \tl_const:cn { c__ustbbook_fn_style_ #1 _tl } {#2} }
\cs_new:Npn \__ustbbook_symbol:n #1 { \tex_char:D #1 \scan_stop: }

\clist_map_inline:nn
{
  { plain           } { plain           },
  { libertinus      } { libertinus      },
  { libertinus_neg  } { libertinus*     },
  { libertinus_sans } { libertinus-sans },
  { pifont          } { pifont          },
  { pifont_neg      } { pifont*         },
  { pifont_sans     } { pifont-sans     },
  { pifont_sans_neg } { pifont-sans*    },
  { xits            } { xits            },
  { xits_sans       } { xits-sans       },
  { xits_sans_neg   } { xits-sans*      }
}
{ \__ustbbook_define_fn_style:nn #1 }
\tl_new:N \l__ustbbook_fn_style_tl
\keys_define:nn { USTBBook / style }
{
  footnote-style .choices:nn =
    {
      plain,
      libertinus, libertinus*, libertinus-sans,
      pifont,     pifont*,     pifont-sans,     pifont-sans*,
      xits,                    xits-sans,       xits-sans*
    }
    {
      \tl_gset_eq:NN \l__ustbbook_fn_style_tl \l_keys_choice_tl
      \int_compare:nT { 5 <= \l_keys_choice_int <= 8 }
      { \RequirePackage { pifont } }
    },
  footnote-style .value_required:n = true
}
\keys_set:nn { USTBBook / style }
{
  footnote-style = libertinus
}
\cs_new:Npn \__ustbbook_fn_symbol_libertinus:n #1
{
  \int_compare:nTF { #1 >= 21 }
  {
    \int_compare:nTF { #1 >= 47 }
    { \__ustbbook_symbol:n { \int_eval:n { "24B6 - 47 + #1 } } }
    { \__ustbbook_symbol:n { \int_eval:n { "24D0 - 21 + #1 } } }
  }
  { \__ustbbook_symbol:n { \int_eval:n { "2460 - 1 + #1 } } }
}
\cs_new:Npn \__ustbbook_fn_symbol_libertinus_neg:n #1
{
  \int_compare:nTF { #1 >= 11 }
  { \__ustbbook_symbol:n { \int_eval:n { "24EB - 11 + #1 } } }
  { \__ustbbook_symbol:n { \int_eval:n { "2776 -  1 + #1 } } }
}
\cs_new_eq:NN \__ustbbook_fn_symbol_libertinus_sans:n \__ustbbook_fn_symbol_libertinus:n
\cs_new:Npn \__ustbbook_fn_symbol_pifont:n #1
{ \ding { \int_eval:n { 171 + #1 } } }
\cs_new:Npn \__ustbbook_fn_symbol_pifont_neg:n #1
{ \ding { \int_eval:n { 181 + #1 } } }
\cs_new:Npn \__ustbbook_fn_symbol_pifont_sans:n #1
{ \ding { \int_eval:n { 191 + #1 } } }
\cs_new:Npn \__ustbbook_fn_symbol_pifont_sans_neg:n #1
{ \ding { \int_eval:n { 201 + #1 } } }
\cs_new:Npn \__ustbbook_fn_symbol_xits:n #1
{
  \int_compare:nTF { #1 >= 10 }
  {
    \int_compare:nTF { #1 >= 36 }
    { \__ustbbook_symbol:n { \int_eval:n { "24B6 - 36 + #1 } } }
    { \__ustbbook_symbol:n { \int_eval:n { "24D0 - 10 + #1 } } }
  }
  { \__ustbbook_symbol:n { \int_eval:n { "2460 - 1 + #1 } } }
}
\cs_new:Npn \__ustbbook_fn_symbol_xits_sans:n #1
{ \__ustbbook_symbol:n { \int_eval:n { "2780 - 1 + #1 } } }
\cs_new:Npn \__ustbbook_fn_symbol_xits_sans_neg:n #1
{ \__ustbbook_symbol:n { \int_eval:n { "278A - 1 + #1 } } }
\cs_set:Npn \thefootnote { \ustbbook_footnote_number:N \c@footnote }
\cs_new:Npn \ustbbook_footnote_number:N #1
{
  \tl_case:NnF \l__ustbbook_fn_style_tl
  {
    \c__ustbbook_fn_style_plain_tl
    { \int_use:N #1 }
    \c__ustbbook_fn_style_libertinus_tl
    {
      \fontspec { LibertinusSerif-Regular .otf }
      \__ustbbook_fn_symbol_libertinus:n {#1}
    }
    \c__ustbbook_fn_style_libertinus_neg_tl
    {
      \fontspec { LibertinusSerif-Regular .otf }
      \__ustbbook_fn_symbol_libertinus_neg:n {#1}
    }
    \c__ustbbook_fn_style_libertinus_sans_tl
    {
      \fontspec { LibertinusSans-Regular .otf }
      \__ustbbook_fn_symbol_libertinus_sans:n {#1}
    }
    \c__ustbbook_fn_style_pifont_tl
    { \__ustbbook_fn_symbol_pifont:n {#1} }
    \c__ustbbook_fn_style_pifont_neg_tl
    { \__ustbbook_fn_symbol_pifont_neg:n {#1} }
    \c__ustbbook_fn_style_pifont_sans_tl
    { \__ustbbook_fn_symbol_pifont_sans:n {#1} }
    \c__ustbbook_fn_style_pifont_sans_neg_tl
    { \__ustbbook_fn_symbol_pifont_sans_neg:n {#1} }
    \c__ustbbook_fn_style_xits_tl
    {
      \fontspec { XITS-Regular .otf }
      \__ustbbook_fn_symbol_xits:n {#1}
    }
    \c__ustbbook_fn_style_xits_sans_tl
    {
      \fontspec { XITS-Regular .otf }
      \__ustbbook_fn_symbol_xits_sans:n {#1}
    }
    \c__ustbbook_fn_style_xits_sans_neg_tl
    {
      \fontspec { XITS-Regular .otf }
      \__ustbbook_fn_symbol_xits_sans_neg:n {#1}
    }
  }
  { \int_use:N #1 }
}
\cs_set:Npn \@makefntext #1
{
  \mode_leave_vertical:
  \hbox_to_wd:nn { 1.5 em } { \@thefnmark \hfil }
  #1
}

% 关于图片 graphicx
% 如果图片没有指定后缀, 依次按下列顺序搜索
\DeclareGraphicsExtensions{.pdf,.eps,.jpg,.png}
% 设置图表搜索路径, 可以给图表文件夹取如下名字
\graphicspath{{figures/}{figure/}{pictures/}{picture/}{fig/}{figs/}{image/}{images/}}

\RequirePackage{xcolor}
\RequirePackage{tcolorbox}
\tcbuselibrary{skins,breakable}
\usetikzlibrary{patterns,shadows}

%%%%%%%%%%%%%%%%%%%%%%%%%%% 目录样式 %%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{titletoc}

\titlecontents{part}[0pt]{\addvspace{.4\baselineskip} \sffamily \zihao{-4}}
{\thecontentslabel\quad}{}
{\hspace{.5em}\titlerule*[5pt]{$\cdot$}\contentspage}

\titlecontents{chapter}[2.3em]{\addvspace{0.25\baselineskip} \sffamily \zihao{-4}}
{\thecontentslabel\quad}{}
{\hspace{.5em}\titlerule*[5pt]{$\cdot$}\contentspage}

\titlecontents{section}[4.6em]{\zihao{-4}}
{\thecontentslabel\quad}{}
{\hspace{.5em}\titlerule*[5pt]{$\cdot$}\contentspage}

\titlecontents{subsection}[6.9em]{\zihao{-4}}
{\thecontentslabel、}{}
{\hspace{.5em}\titlerule*[5pt]{$\cdot$}\contentspage}
%%%%%%%%%%%%%%%%%%%%%%%%%%% 目录样式 %%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%% 几个常用宏 %%%%%%%%%%%%%%%%%%%%%%%%%%%
% === \cleardoublepage ===
\cs_if_exist:NT \cleardoublepage {
  \cs_gset:Npn \cleardoublepage {
    \clearpage
    \pagestyle{empty}
    \int_if_odd:nF {\value{page}} {
      \hbox{}
      \newpage
    }
    \pagestyle{fancy}
  }
}

% === \frontmatter ===
\cs_if_exist:NT \frontmatter {
  \cs_gset:Npn \frontmatter {
    \cleardoublepage
    \pagestyle{plain}
    \pagenumbering{roman}
  }
}

% === \mainmatter ===
\cs_if_exist:NT \mainmatter {
  \cs_gset:Npn \mainmatter {
    \cleardoublepage
    \pagenumbering{arabic}
    \pagestyle{fancy}
  }
}

% === \backmatter ===
\cs_if_exist:NT \backmatter {
  \cs_gset:Npn \backmatter {
    \cleardoublepage
  }
}
%%%%%%%%%%%%%%%%%%%%%%%%%% 几个常用宏 %%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%% 章节样式 %%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\partnamebox}[1]{\parbox{\ccwd}{\linespread{1}\selectfont\centering #1}}
\newcommand{\parttitlebox}[1]{
  \begin{minipage}{\textwidth}
    {\centering\Huge #1}
    \startcontents[parts]
  \end{minipage}
}

\ctexset{
  secnumdepth = 3,
  tocdepth = 1,
  part = {
      fixskip = true,
      format = \Huge\sffamily,
      name = {第,篇},
      number = \chinese{part},
      nameformat = \rule{\linewidth}{1bp}\par\bigskip\hfill\sffamily\partnamebox,
      titleformat = \sffamily\parttitlebox,
      pagestyle = fancy,
      aftertitle = {
          \par\bigskip\nointerlineskip\rule{\linewidth}{2bp}
          \par\vspace*{\stretch{1}}%
          \printcontents[parts]{}{0}{\setcounter{tocdepth}{0}}
          \vspace*{\stretch{2}}
        },
      tocline = \CTEXifname{\protect\numberline{{\CTEXthepart}}}{}#2,
    },
  chapter = {
    name = {第,章},
    format = \centering\huge\sffamily,
    number = \chinese{chapter},
    pagestyle = fancy,
    tocline = \CTEXifname{\protect\numberline{\CTEXthechapter}}{}#2,
   },
  section = {
    name = {第,节},
    format = \centering\Large\sffamily,
    number = \chinese{section},
    tocline = \CTEXifname{\protect\numberline{\CTEXthesection}}{}#2,
   },
  subsection = {
      number = \chinese{subsection},
      aftername = {、},
      format = \large\sffamily,
      indent = 2\ccwd,
      tocline = \CTEXifname{\protect\numberline{\CTEXthesubsection}}{}#2,
    },
  subsubsection = {
      indent = 2.3\ccwd,
      number = \arabic{subsubsection},
      aftername = {.~},
      format = \normalsize\bfseries,
    }
}

% ========== 选修节接口 ========== %
%       会在标题前加上"*"
% 用法: \esection{选修内容标题}
\cs_new_protected:Npn \esection #1 {
  \refstepcounter{section}
  \addcontentsline{toc}{section}{*\hspace*{0em}第\chinese{section}节\quad #1}
  % 与 section 样式一致
  \section*{*\hspace*{0em}第\chinese{section}节\quad #1}
}
% =============================== %
%%%%%%%%%%%%%%%%%%%%%%%%%%% 章节样式 %%%%%%%%%%%%%%%%%%%%%%%%%%%

\endinput

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
\msg_new:nnn { ustb-book } { latex-too-old }
{ TeX~ Live~ 2020~ or~ later~ version~ is~ required~ to~ compile~ this~ document. }
\@ifl@t@r \fmtversion { 2020/02/02 }
{ }
{ \msg_fatal:nn { ustb-book } { latex-too-old } }

% 检查编译引擎，要求使用 XeLaTeX。
\msg_new:nnn { ustb-book } { incompatible-engine }
{ XeLaTeX~ is~ required~ to~ compile~ this~ document. }

\sys_if_engine_xetex:F
{ \msg_fatal:nn { ustb-book } { incompatible-engine } }

% 使用 l3keys 定义 \examsetup 配置命令
\NewDocumentCommand \ustbbooksetup { m }
{ \keys_set:nn { ustb-book } {#1} }

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
\msg_new:nnn { ustb-book } { require-package-version }
{ The~ package~ "#1"~ is~ required. }

\@ifclasslater { ctexbook } { 2017/04/01 }
{ }
{
  \msg_fatal:nnn { ustb-book } { require-package-version }
  { ctex~ v2.4.9~ 2017-04-01 }
}

% 避免 \sim 被 exam-zh-symbols 宏包覆盖
\AddToHook{package/exam-zh-symbols/before}{%
  \AtBeginDocument{\let\savedsim=\sim}
}
\AddToHook{package/exam-zh-symbols/after}{%
  \AtBeginDocument{\let\sim=\savedsim}
}

% 处理 Unicode 数学符号警告
\PassOptionsToPackage {
  warnings-off={mathtools-colon,mathtools-overbracket}
} { unicode-math }

% 建议在模板开始处载入全部宏包，不要轻易改变加载顺序。
\RequirePackage { etoolbox }
\RequirePackage [
  a4paper,
  hmargin = { 20mm, 25mm },
  vmargin = { 25mm, 25mm },
  headheight = 15pt,
] { geometry }
\RequirePackage { hyperref }
\RequirePackage { fontspec }
\RequirePackage { xeCJK }
\RequirePackage { xeCJKfntef }
\RequirePackage { fancyhdr }
\RequirePackage { lastpage }
\RequirePackage { amsmath, mathtools }
\RequirePackage [ shortlabels, inline ] { enumitem }
\RequirePackage { varwidth }
\RequirePackage { tabu, booktabs, tabularx }
\RequirePackage { fontawesome5 }

\RequirePackage { exam-zh-question }
\RequirePackage { exam-zh-font }
\RequirePackage { exam-zh-choices }
\RequirePackage { exam-zh-symbols }
\RequirePackage { exam-zh-textfigure }
\RequirePackage { exam-zh-math }

%%%%%%%%%%%%%%%%%%%%%%%%%%% 页眉页脚 %%%%%%%%%%%%%%%%%%%%%%%%%%%
\fancyhf{}
% \fancyfoot[RO, LE]{\sffamily \zihao{5} {\thepage}}
\fancyfoot[RO, LE]{\colorbox{gangtiehong}{\textcolor{white}{\sffamily \zihao{-5} \thepage}}}

\renewcommand\headrulewidth{0pt}

% 页眉页脚设置
\AtBeginDocument {
  \pagestyle{fancy}
}
%%%%%%%%%%%%%%%%%%%%%%%%%%% 页眉页脚 %%%%%%%%%%%%%%%%%%%%%%%%%%%

% 生成函数变体
\cs_generate_variant:Nn \tl_map_inline:nn { xn }

% 标点处理
\tl_const:Nn \c__ustbbook_fwid_full_stop_tl { ^^^^ff0e }

\keys_define:nn { ustb-book }
{ style .meta:nn = { ustb-book / style } {#1} }
\keys_define:nn { ustb-book / style }
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

\keys_set:nn { ustb-book / style }
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
\keys_define:nn { ustb-book / style }
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
\keys_set:nn { ustb-book / style }
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
% 让脚注符号与基线平齐
\cs_set:Npn \@makefntext #1
{
  \mode_leave_vertical:
  \hbox_to_wd:nn { 1.5 em } { \@thefnmark \hfil }
  #1
}
% 脚注编号每页清零
\AddToHook{ shipout / before }
{
  \global\c@footnote=0
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%% 图表 %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 关于图片 graphicx
% 如果图片没有指定后缀, 依次按下列顺序搜索
\DeclareGraphicsExtensions{.pdf,.eps,.jpg,.png}
% 设置图表搜索路径, 可以给图表文件夹取如下名字
% 默认图片路径
\graphicspath{
  {figures/}{figure/}
    {pictures/}{picture/}
    {image/}{images/}
    {fig/}{figs/}{../figs}{body/figs}
    {Fig/}{Figs}{../Figs}{body/Figs}
}

\RequirePackage { subcaption }
% 图表标题
\renewcommand \thefigure
{\ifnum \c@chapter>\z@ \thechapter-\fi \@arabic\c@figure}
\renewcommand \thetable
{\ifnum \c@chapter>\z@ \thechapter-\fi \@arabic\c@table}
% 公式编号
\numberwithin{equation}{section}
\renewcommand \theequation
{\arabic{section}-\arabic{equation}}

\DeclareCaptionFont{song}{\songti}
% \DeclareCaptionFont{minusfour}{small}
\captionsetup[figure]{
  format=hang,        % 标题从第二行开始都有缩进, 应该和 justification=raggedright 的效果一样.
  labelsep=space,     % 分隔符是一个空格
  font={song, small}, % 图的字体, 宋体小四
  position=bottom     % position=bottom, 不代表标题放在下面, 标题仍放在你放\caption的位置.
}
\captionsetup[table]{
  format=hang,        % 标题从第二行开始都有缩进, 应该和 justification=raggedright 的效果一样.
  labelsep=space,     % 分隔符是一个空格
  font={song, small}, % 表的字体, 宋体小四
  position=top        % position=top, 不代表标题放在上面, 标题仍放在你放\caption的位置.
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%% 图表 %%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{tcolorbox}
\tcbuselibrary{skins, breakable}
\usetikzlibrary{patterns, shadows, fit}

%%%%%%%%%%%%%%%%%%%%%%%%%%% 目录样式 %%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{titletoc}

% 设置目录标题格式
\renewcommand{\contentsname}{目\quad 录}

% \titlecontents{part}[0pt]{\addvspace{.4\baselineskip} \sffamily \zihao{-4}}
% {\thecontentslabel\quad}{}
% {\hspace{.5em}\titlerule*[5pt]{$\cdot$}\contentspage}

% \titlecontents{chapter}[2.3em]{\addvspace{0.25\baselineskip} \sffamily \zihao{-4}}
% {\thecontentslabel\quad}{}
% {\hspace{.5em}\titlerule*[5pt]{$\cdot$}\contentspage}

\titlecontents{section}[3.7em]{\zihao{-4}\ttfamily}
{\thecontentslabel\quad}{}
{\hspace{.5em}\titlerule*[5pt]{$\cdot$}\contentspage}

\titlecontents{subsection}[6.9em]{\zihao{-4}\ttfamily}
{\thecontentslabel}{}
{\hspace{.5em}\titlerule*[5pt]{$\cdot$}\contentspage}

% from https://ask.latexstudio.net/ask/question/8242.html
% 定义带样式的环境
\DeclareTColorBox{mtoc}{ O{} }{
  nobeforeafter,
  colframe=white, colupper=white,
  frame~hidden,% width = \textwidth,
  top=1pt,bottom=1pt,right=0mm,
  % before~skip~balanced=0em,after~skip~balanced=0em,
  arc=0pt,outer~arc=0pt,
  bicolor,sidebyside,boxrule=0pt,
  sidebyside~align=center,halign=center,halign~lower=left,
  % fuzzy~shadow = {0pt}{-2pt}{-0.5pt}{0.5pt}{gray},
  #1
}

\newlength{\Boxwidth}
\NewDocumentCommand \boxedd { O{ kejilan } m }
{
  \settowidth{\Boxwidth}{\thecontentslabel}
  \begin{mtoc}[
      colback=#1, colbacklower=#1!20,
      lefthand~width=\dimexpr\Boxwidth+.5em\relax,
    ]
    \thecontentslabel\tcblower #2 \hfill \thecontentspage
  \end{mtoc}
}

\titlecontents{part}[0mm]{\addvspace{0.4\baselineskip} \sffamily \zihao{-4}}
{\boxedd[gangtiehong]}{\boxedd[gangtiehong]}
{}

\titlecontents{chapter}[0mm]{\addvspace{0.25\baselineskip} \sffamily \zihao{-4}}
{\boxedd}{\boxedd}
{}

%%%%%%%%%%%%%%%%%%%%%%%%%%% 目录样式 %%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%% 章节样式 %%%%%%%%%%%%%%%%%%%%%%%%%%%

% from https://github.com/Azure1210/elegantbook-magic-revision/blob/145d733a14f966c35be1c3f44677c7871c4f5979/elegentbook-magic-revision/gorgeousnbook.cls#L612
% \RequirePackage[object=vectorian]{pgfornament}
\NewDocumentCommand{\parttitleformat}{ m }
{
  % 清除边栏内容
  \tl_gclear:N \__chapter_tl
  \tl_gclear:N \__section_tl
  \group_begin:
  % \par
  % 本页禁用
  % \noSideBarThisPage
  % \if@openright
  %   \afterpage{\noSideBarThisPage}
  % \fi
  % \pgfornament[scale=.3]{72}
  #1
  % \pgfornament[scale=.3]{73}
  % \par \vspace*{-5pt}
  % \pgfornament[scale=.5]{85}
  \begin{tcolorbox}[
      enhanced~jigsaw,
      breakable,
      before~skip=40pt,
      width=.95\textwidth,
      opacityframe=0.5,opacityback=0.25,opacitybacktitle=0.25,
      colback=kejilan!20,colframe=kejilan,colbacktitle=kejilan,
      boxrule=0pt,
      toprule=1.5pt,
      bottomrule=1.5pt,
      top=10pt,
      arc=0mm,
      overlay = {
          \node[rectangle, %opacity=.3,
            text=white, %drop~shadow={opacity=.3, shadow~xshift=0.1cm},
            rounded~corners=2pt,
            inner~sep=2mm,
            fill=kejilan,
            anchor=center,
            font=\sffamily\large,
          ] at ([yshift=.5mm]frame.north) {本篇目录};
        }
    ]
    \color{black}
    \normalsize
    \ttfamily
    \startcontents
    \printcontents{l}{0}[1]{}
    % 仅输出章
    % \printcontents{l}{0}[0]{}
  \end{tcolorbox}
  \group_end:
}

\NewDocumentCommand \chapternameformat{ m } { }

\NewDocumentCommand \chaptertitleformat{ m }
{
  % 清除右边栏内容
  \tl_gclear:N \__section_tl
  \begin{tcolorbox}[
      breakable,
      center, enhanced, width=.8\textwidth,
      left=6em,
      title~empty,
      boxrule=.5pt, boxsep=.5pt, %arc=2pt,
      colframe=kejilan,
      colback=transparent!0,
      fontupper=\sffamily\Large\bfseries,
      coltext=kejilan,
      halign=center, valign=center,
      overlay={
          \begin{tcbclipinterior}
            \CTEXthechapter{
              \node[
                fill=kejilan, rounded~corners,
                minimum~width=6em,
                minimum~height=\tcb@height,
                font=\sffamily\Large\bfseries,
                text=white,
                anchor=west,
                xshift=-2pt,
              ] at (interior.west) {
                {\CTEXifname{\CTEXthechapter}{}}
              };
            }{}
            \node[xshift=-1em, text=kejilan] at (interior.east) {\faStaylinked};
          \end{tcbclipinterior}
        }
    ]
    #1
  \end{tcolorbox}
  % \begin{tikzpicture}[baseline]
  %   \node[
  %     draw=kejilan,
  %     rounded~corners=4pt,
  %     font=\sffamily\Large,
  %     minimum~width=.8\textwidth,
  %     minimum~height=25pt,
  %     text=kejilan,
  %     anchor=center
  %   ] (chapter) at (0, 0) {\ziju{.2} #1};
  %   \node[
  %     xshift=-1em, text=kejilan, font=\normalsize
  %   ] at (chapter.east) { \faGg };
  %   \CTEXifname{}{
  %     \node[
  %       fill=kejilan, rounded~corners,
  %       minimum~width=6em, minimum~height=25pt,
  %       font=\sffamily\Large, text=white
  %     ] at (chapter.south~west) [anchor=south~west] {};
  %   }
  % \end{tikzpicture}
}

% 下划线
\NewDocumentCommand{\customunderline}{ O{-1pt} m m }
{
  \sbox0{#3}%
  \ooalign{%
    \copy0\cr
    \rule[\dimexpr#1-#2\relax]{\wd0}{#2}
  }
}

% name 样式
\NewDocumentCommand \sectionnameformat { m } {
  \begin{tikzpicture}[baseline]
    \node[
      fill=kejilan,
      rounded~corners=4pt,
      font=\sffamily\large\bfseries,
      minimum~width=4.5em,
      minimum~height=20pt,
      text=white,
      anchor=base~east
    ] { {\CTEXifname{\CTEXthesection}{}} };
  \end{tikzpicture}
}

% title 样式
\NewDocumentCommand \sectiontitleformat { m }
{
  \begin{tikzpicture}[baseline]
    % \node[
    %   fill=kejilan,
    %   rounded~corners=4pt,
    %   font=\sffamily\Large,
    %   minimum~width=6em,
    %   minimum~height=20pt,
    %   text=white,
    %   anchor=base~east
    % ] { {\CTEXifname{\CTEXthesection}{}} };
    \node[
      text=kejilan,
      font=\sffamily\large\bfseries,
      anchor=base~west,
    ] { \hspace*{-0.5em} \customunderline[-8pt]{1pt}{\hspace*{.5em} #1 \hspace*{.5em}} };
    % \draw [line~width=2pt, color=kejilan] (textnode.west) -- (textnode.east);
  \end{tikzpicture}
}

% part = {
%     fixskip = true,
%     format = \color{kejilan}\huge\sffamily,
%     name = {第,篇},
%     number = \chinese{part},
%     nameformat = \rule{\linewidth}{1bp}\par\bigskip\hfill\sffamily\partnamebox,
%     titleformat = \sffamily\parttitlebox,
%     pagestyle = fancy,
%     aftertitle = {
%         \par\bigskip\nointerlineskip\rule{\linewidth}{2bp}
%         \par\vspace*{\stretch{1}}
%         \printcontents[parts]{}{0}{\setcounter{tocdepth}{0}}
%         \vspace*{\stretch{2}}
%       },
%     tocline = \CTEXifname{\protect\numberline{{\CTEXthepart}}}{}##2,
%   },
% chapter = {
%   name = {第,章},
%   format = \color{kejilan}\centering\huge\sffamily,
%   number = \chinese{chapter},
%   pagestyle = chapterstyle,
%   tocline = \CTEXifname{\protect\numberline{\CTEXthechapter}}{}##2,
%  },
% section = {
%   name = {第,节},
%   format = \color{kejilan}\centering\Large\sffamily,
%   aftername = {\quad},
%   number = \chinese{section},
%   tocline = \CTEXifname{\protect\numberline{\CTEXthesection}}{}##2,
%  },

% 默认样式
\cs_new_protected:Npn \__my_section_style_a: {
  \ctexset {
    secnumdepth = 3,
    tocdepth = 1,
    part = {
        titleformat = \color{kejilan}\huge\sffamily\parttitleformat,
        nameformat  = \color{kejilan}\centering\huge\sffamily,
        pagestyle   = fancy,
        name = {第,篇},
        number = \chinese{part},
        beforeskip=20pt,
        tocline = \CTEXifname{\protect\numberline{{\CTEXthepart}}}{}##2,
      },
    chapter = {
      pagestyle   = fancy,
      titleformat = \chaptertitleformat,
      nameformat  = \chapternameformat,
      name = {第,章},
      format = \centering\color{kejilan}\sffamily,
      number = \chinese{chapter},
      tocline = \CTEXifname{\protect\numberline{\CTEXthechapter}}{}##2,
     },
    section = {
      format = \centering\large\sffamily\color{kejilan},
      number = \chinese{section},
      name   = {第,节},
      titleformat = \sectiontitleformat,
      nameformat  = \sectionnameformat,
      tocline = \CTEXifname{\protect\numberline{\CTEXthesection}}{}##2,
     },
    subsection = {
        number = \Alph{subsection},
        name = {(,)},
        aftername = {\quad},
        format = \centering\large\bfseries\color{kejilan},
      },
    appendix = {
        name = {附录},
        number = \Alph{chapter},
      },
  }
}

% 题型样式
\cs_new_protected:Npn \__my_section_style_b: {
  \ctexset {
    section = {
      format = \raggedright\large\sffamily\color{kejilan},
      number = \chinese{section},
      name = {题型,},
      titleformat = \sectiontitleformat,
      nameformat  = \sectionnameformat,
      tocline = \CTEXifname{\protect\numberline{\CTEXthesection}}{}##2,
     },
    subsection = {
        number = \chinese{subsection},
        aftername = {、},
        name = {},
        format = \large\sffamily\color{kejilan},
        % indent = 2\ccwd,
        tocline = \CTEXifname{\protect\numberline{\CTEXthesubsection}}{}##2,
      },
    subsubsection = {
        % indent = 2.3\ccwd,
        number = \arabic{subsubsection},
        aftername = {.~},
        format = \normalsize\bfseries,
      }
  }
}

% 定义布尔变量控制是否使用 题型模式
\bool_new:N \l__my_section_exercise_bool

% choices 接口绑定样式命令
\keys_define:nn { ustb-book / global } {
  section-style .choices:nn = { section, exercise } {
      \tl_if_eq:nnTF {#1} { section }
      {
        \__my_section_style_a:
        \bool_set_false:N \l__my_section_exercise_bool
      }
      {
        \__my_section_style_b:
        \bool_set_true:N \l__my_section_exercise_bool
      }
    },
  section-style .initial:n = section,
}

% ========== 选修节接口 ========== %
%       会在标题前加上"*"
% 用法: \esection{选修内容标题}
\NewDocumentCommand{\esection}{ m }
{
  \group_begin:
  \bool_if:NTF {\l__my_section_exercise_bool}
  { \ctexset{ section/name={{\texorpdfstring{\makebox[0pt][r]{${}^*$}}{*}题型},} } }
{ \ctexset{ section/name={{\texorpdfstring{\makebox[0pt][r]{${}^*$}}{*}第},节} } }
\section{#1}
\group_end:
\sectionmark*{#1}
}
% =============================== %

% 定义是否每部分重置章数的选项
\keys_define:nn { ustb-book / global } {
  reset-chapter .bool_set:N = \l_ustbbook_reset_chapter_bool,
  reset-chapter .initial:n  = false,
}

\keys_define:nn { ustb-book }
{ global .meta:nn = { ustb-book / global } {#1} }

% 使用低层接口模拟 @addtoreset
\cs_new_protected:Npn \addtocounterreset #1#2 {
  \cs_gset:cpn { cl@#1 } { #2 }
}

\AtEndPreamble {
  \bool_if:NT \l_ustbbook_reset_chapter_bool
  {
    % 如果设置了 reset-chapter，则每个 part 重置 chapter
    \@addtoreset{chapter}{part}
  }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%% 章节样式 %%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%% 列表样式 %%%%%%%%%%%%%%%%%%%%%%%%%%%
% 默认的 enumerate 环境
\setlist[enumerate]{(1), left=\parindent, itemsep=0pt, align=left, parsep=0pt, topsep=0pt}
\setlist[enumerate,2]{label=(\roman*), left=0em, labelsep=-0.5em, itemsep=0pt, parsep=0pt, topsep=0pt}
% 默认的 itemize 环境
\setlist[itemize]{left=\parindent, itemsep=0pt, parsep=0pt, topsep=0pt}
\setlist[itemize,2]{left=0em, labelsep=-0.5em, itemsep=0pt, parsep=0pt, topsep=0pt}

\newlist{inenum}{enumerate*}{2}
\setlist[inenum]{(1), itemjoin={\quad}}

% 行内列表
\RequirePackage { tasks }
\NewTasksEnvironment[
  label=(\arabic*),
  % item-indent=2em,
  label-width=2em,
  label-offset=0.3em,
  label-align=right,
  after-item-skip=\parsep,
  after-skip=\parsep,
  before-skip=\parsep,
  % resume=true   %% comment this for not to resume
]{tabenum}[\item](2)    %% (2) here makes all of them in 2 columns
%%%%%%%%%%%%%%%%%%%%%%%%%%% 列表样式 %%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%% 一些数学符号 %%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{extarrows}

\RequirePackage{fixdif}
\newdif{\dif}{\mathrm{d}}

\DeclareMathOperator{\re}{e}
\DeclareMathOperator{\ri}{i}
\DeclareMathOperator{\cov}{cov}
\DeclareMathOperator{\sgn}{sgn}
\DeclareMathOperator{\rot}{\mathbf{rot}}
\DeclareMathOperator{\grad}{\mathbf{grad}}
\DeclareMathOperator{\divd}{\mathbf{div}}
\DeclareMathOperator{\ch}{ch}
\DeclareMathOperator{\sh}{sh}
\DeclareMathOperator{\arccot}{arccot}

\NewDocumentCommand \abs { m }
{\left| #1 \right|}

% 大分式
\NewDocumentCommand \ddfrac { m m }
{
  \frac{\displaystyle #1}{\displaystyle #2}
}

\renewcommand{\Re}{\operatorname{Re}}
\renewcommand{\Im}{\operatorname{Im}}
\renewcommand{\le}{\leqslant}
\renewcommand{\leq}{\leqslant}
\renewcommand{\ge}{\geqslant}
\renewcommand{\geq}{\geqslant}

\everymath{\displaystyle}
\allowdisplaybreaks

\numberwithin{equation}{section}
\renewcommand\theequation{\arabic{section}-\arabic{equation}}
%%%%%%%%%%%%%%%%%%%%%%%%%% 一些数学符号 %%%%%%%%%%%%%%%%%%%%%%%%%%

\keys_set:nn { exam-zh } {
  choices/label = (\Alph*),
  symbols/change-frac-style = true,
  symbols/change-dfrac-style = true,
  solution/blank-type = manual,
  solution/show-solution = show-stay,
  solution/label-content = {\color{blue}{\sffamily 解}},
  solution/qedsymbol = {\color{blue}{$\square$}},
  solution/label-indentation = false,
  question/show-answer = true,
  problem/show-answer = true,
  paren/show-answer = true,
  fillin/show-answer = true,
  paren/text-color = blue,
  fillin/text-color = blue,
  solution/text-color = blue,
  textfigure/fig-pos = right,
}

% 解析环境
\NewDocumentEnvironment{analysis}{ O{} }
{
  \begin{solution}[label-content={\color{blue}{\sffamily 解析}},blank-type=none,#1]}{
  \end{solution}
}

% 尾注环境
\NewDocumentEnvironment{note}{ O{} }
{
  \begin{solution}[label-content=【尾注】,text-color=black,show-qed=false,parbreak=true,#1]
    \setlength{\parindent}{2em}}{
  \end{solution}
}

% 证明题环境
\RenewDocumentEnvironment{proof}{ O{} }
{
  \begin{solution}[label-content={\color{blue}{\sffamily 证明}},blank-type=manual,#1]}{
  \end{solution}
}

% 定义文本盒子
\DeclareTColorBox{pabox}{ O{ } m O{ blue } }
{
  colback=#3!5!white,
  colframe=#3!45!gray,
  colbacktitle=#3!5!white,
  coltitle=#3!45!gray,
  titlerule=0mm,
  toprule=0mm,
  bottomrule=0mm,
  rightrule=0mm,
  leftrule=.5mm,
  boxsep=0mm,
  breakable,
  % frame hidden,
  % interior hidden,
  % detach title,
  % sharpish corners,
  fonttitle=\bfseries,
  label=#2,
  % title={\faMortarBoard~ #2},
  #1
}

% 通用盒子
\DeclareTColorBox{knowledge}{ O{知识点睛} }{
  enhanced~jigsaw,
  breakable,
  before~skip=40pt,
  width=\textwidth,
  opacityframe=0.5,opacityback=0.25,opacitybacktitle=0.25,
  colback=gangtiehong!20,colframe=gangtiehong,colbacktitle=gangtiehong,
  boxrule=0pt,
  toprule=1.5pt,
  bottomrule=1.5pt,
  top=15pt,
  left=0pt,
  right=0pt,
  arc=0mm,
  parbox=true,                % ← 允许正常段落格式
  before~upper=\setlength{\parindent}{2em}, % ← 每段首行缩进 2em
  overlay = {
      \node[rectangle, %opacity=.3,
        text=white, %drop~shadow={opacity=.3, shadow~xshift=0.1cm},
        rounded~corners=2pt,
        inner~sep=2mm,
        fill=gangtiehong,
        anchor=center,
        font=\sffamily\large,
      ] at ([yshift=.5mm]frame.north) {~#1~};
    }
}

% 笔记环境
\NewDocumentEnvironment{ notes }{ O{ } o o +b }
{
  \bool_if:NTF \g__examzh_solution_show_bool
  {
    \begin{pabox}[]{\IfNoValueTF{#2}{#1}{#2}}[#3]
      \group_begin:
      {\color{blue!45!gray} \faGraduationCap \space {\bfseries #1}}
      \smallskip
      \par
      \group_end:
      \begingroup
      #4
      \endgroup
    \end{pabox}
  }
  {}
}
{}

% 引用命令
\NewDocumentCommand \myref { m o }
{ 详见 第 ~\pageref{#1}~ 页 \IfNoValueTF{#2}{#1}{#2} }

%%%%%%%%%%%%%%%%%%%%%%%%%%% 全局水印 %%%%%%%%%%%%%%%%%%%%%%%%%%%
\keys_define:nn { ustb-book / global }
{
  watermark .tl_set:N = \l__ustbbook_global_watermark,
}
\keys_set:nn { ustb-book / global }
{
  watermark = {},
}
\keys_define:nn { ustb-book }
{ global .meta:nn = { ustb-book / global } {#1} }

\AtEndPreamble
{
  \tl_if_empty:NF { \l__ustbbook_global_watermark }
  {
    \RequirePackage{background}
    \backgroundsetup{
      scale=1, % 调整大小
      angle=0, % 调整角度
      opacity=0.15, % 调整透明度
      pages=all, % 应用到所有页面
      position=current~page.center, % 确保在页面正中心
      contents={
          \includegraphics[width=0.6\paperwidth, keepaspectratio]{\l__ustbbook_global_watermark}
        }
    }
  }
}
%%%%%%%%%%%%%%%%%%%%%%%%%%% 全局水印 %%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%% 封面封底 %%%%%%%%%%%%%%%%%%%%%%%%%%%
% 封面配置
\keys_define:nn { ustb-book / cover }
{
  top      .tl_set:N = \l__ustbbook_cover_top,
  title    .tl_set:N = \l__ustbbook_cover_title,
  subtitle .tl_set:N = \l__ustbbook_cover_subtitle,
  author   .tl_set:N = \l__ustbbook_cover_author,
  date     .tl_set:N = \l__ustbbook_cover_date,
  bottom   .tl_set:N = \l__ustbbook_cover_bottom,
  bgimg    .tl_set:N = \l__ustbbook_cover_bgimg,
}
\keys_set:nn { ustb-book / cover }
{
  top      = 北京科技大学,
  title    = 高等数学AI,
  subtitle = 历年期中试卷合集,
  author   = 黄腾,
  date     = \today,
  bottom   = 假装有出版社,
  bgimg    = {},
}
\keys_define:nn { ustb-book }
{ cover .meta:nn = { ustb-book / cover } {#1} }

% 定义 makeCover 命令
\NewDocumentCommand \makeCover { }
{
  \newgeometry{hmargin=3.5cm, vmargin=2.5cm, headsep=0.5cm}
  \pagestyle{empty}
  \begin{titlepage}
    \setcounter{page}{0}
    \tl_if_empty:NF { \l__ustbbook_cover_bgimg }
    {
      \begin{tikzpicture}[remember~picture, overlay]
        \node[opacity=0.2,rotate=30] at ([shift={(-2.0cm, 0)}]current~page.center)
        {
          \includegraphics[width=23cm]{\l__ustbbook_cover_bgimg}
        };
      \end{tikzpicture}
    }

    \centering

    \makebox[0.5\textwidth][s]{\huge \bfseries \l__ustbbook_cover_top}
    \par\addvspace{2.5cm}

    \begin{tcolorbox}[
      width=0.8\textwidth, height=4cm,
      halign=center, valign=center,
      blanker,
      frame~hidden, boxsep=0pt,
      borderline~horizontal={2pt}{0pt}{black},
      hyphenationfix,
      ]
      \Huge \bfseries
      \makebox[0.6\textwidth][s]{\l__ustbbook_cover_title}
      \par
      \makebox[0.8\textwidth][s]{\l__ustbbook_cover_subtitle}
    \end{tcolorbox}
    \par\addvspace{1.5cm}

    \parbox{0.4\textwidth}{\Large \centering \l__ustbbook_cover_author}
    \par\addvspace{1cm}

    {\l__ustbbook_cover_date}
    \par\vfill

    \makebox[0.3\textwidth][s]{\large \l__ustbbook_cover_bottom}
  \end{titlepage}
  \restoregeometry
}

% 定义 makeBackCover 命令
\NewDocumentCommand \makeBackCover { }
{
  \clearpage
  \int_if_odd:nTF { \value{page} }
  {
    % 当前页是奇数页，插入一页空白页
    \group_begin:
    \pagestyle{empty}
    \null \newpage
    \group_end:
    \addtocounter{page}{-1}
  }
  {
    % 当前页是偶数页，插入两页空白页
    \group_begin:
    \pagestyle{empty}
    \null \newpage
    \null \newpage
    \group_end:
    \addtocounter{page}{-2}
  }
}

\RenewDocumentCommand \cleardoublepage { }
{
  \clearpage
  \int_if_odd:nF \c@page
  {
    \hbox:n {}
    \thispagestyle { empty }
    \cs_if_exist:NT \noSideBarThisPage
    { \noSideBarThisPage }
    \newpage
  }
}
%%%%%%%%%%%%%%%%%%%%%%%%%%% 封面封底 %%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%% PDF 信息 %%%%%%%%%%%%%%%%%%%%%%%%%%%
% PDF 配置
\keys_define:nn { ustb-book / pdf }
{
  title    .tl_set:N = \l__ustbbook_pdf_title,
  author   .tl_set:N = \l__ustbbook_pdf_author,
  subject  .tl_set:N = \l__ustbbook_pdf_subject,
  keywords .tl_set:N = \l__ustbbook_pdf_keywords,
}
\keys_set:nn { ustb-book / pdf }
{
  title    = {},
  subject  = {},
  author   = \@author,
  keywords = {},
}
\keys_define:nn { ustb-book }
{ pdf .meta:nn = { ustb-book / pdf } {#1} }

\hypersetup{
  bookmarksnumbered = true,
  bookmarksopen     = true,
  bookmarksdepth    = 3,
  colorlinks        = true,
  linkcolor         = black,
  urlcolor          = black,
  citecolor         = black,
  filecolor         = black,
  psdextra          = true,
  unicode           = true,
  pdfborder         = {0 0 0},
}

\AtBeginDocument
{
  \hypersetup {
    pdfinfo = {
        Title    = {\l__ustbbook_pdf_title},
        Author   = {\l__ustbbook_pdf_author},
        Subject  = {\l__ustbbook_pdf_subject},
        Keywords = {\l__ustbbook_pdf_keywords},
      },
  }
}
%%%%%%%%%%%%%%%%%%%%%%%%%%% PDF 信息 %%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%% 更新日志 %%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{changelog, translations}
\DeclareTranslation{English}{changelog-Added}{新增}
\DeclareTranslation{English}{changelog-Changed}{修改}
\DeclareTranslation{English}{changelog-Deprecated}{即将舍弃}
\DeclareTranslation{English}{changelog-Removed}{移除}
\DeclareTranslation{English}{changelog-Fixed}{纠错}
\DeclareTranslation{English}{changelog-Security}{安全}
\DeclareTranslation{English}{changelog-Miscellaneous}{其他}
\DeclareTranslation{English}{changelog-Unreleased}{即将发布}
\DeclareTranslation{English}{changelog-Yanked}{警醒}
%%%%%%%%%%%%%%%%%%%%%%%%%%% 更新日志 %%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%% 题目编号 %%%%%%%%%%%%%%%%%%%%%%%%%%%

% 通用 itemlabel 构造器
\cs_new:Npn \__itemlabel:n #1 {
  \tikz[baseline=(char.base)]{
    \node [
      shape = rectangle,
      fill = kejilan,
      rounded~corners = 2pt,
      inner~sep = 2pt,
      minimum~size = 12pt
    ] (char) {\color{white} #1 };
  }
}

% 定义 boxednumber 宏，接受编号作为参数
\NewDocumentCommand \boxednumber { m } {
  \__itemlabel:n {#1}
}

% enumitem 中使用样式的包装命令
\NewDocumentCommand \boxedlabel {} {
  \boxednumber{\arabic*}
}

% 清理
\cs_new_protected:Npn \__clear_question_hooks: {
  \RemoveFromHook{cmd/chapter/before} [reset-per-chapter]
  \RemoveFromHook{cmd/section/before} [reset-per-section]
}

% 默认题号样式
\cs_new_protected:Npn \__my_question_style_a: {
  \__clear_question_hooks:
  \keys_set:nn { exam-zh / question } {
    label = \arabic*.,
  }
  \AddToHook{cmd/section/before} [reset-per-section]
  {\int_gset:Nn \g__examzh_question_index_int {1}}
}

% 题号样式 B
\cs_new_protected:Npn \__my_question_style_b: {
  \__clear_question_hooks:
  \keys_set:nn { exam-zh / question } {
    % question/label=\protect\itemlabelf\arabic*},
    label = \boxednumber{\arabic*},
  }
  \AddToHook{cmd/chapter/before} [reset-per-chapter]
  {\int_gset:Nn \g__examzh_question_index_int {1}}
}

% 定义布尔变量控制是否使用 boxednumber
\bool_new:N \l__my_question_boxed_bool

% choices 接口绑定样式命令
\keys_define:nn { ustb-book / global } {
  question-style .choices:nn = { base, boxed } {
      \tl_if_eq:nnTF {#1} {base}
      {
        \__my_question_style_a:
        \bool_set_false:N \l__my_question_boxed_bool
      }
      {
        \__my_question_style_b:
        \bool_set_true:N \l__my_question_boxed_bool
      }
    },
  question-style .initial:n = base,
}

% 选修内容对应的题目
\NewDocumentEnvironment { question* } { O{} +b }
{
  \group_begin:
  \bool_if:NTF \l__my_question_boxed_bool
  {
    \__examzh_question_begin:nn {label={\boxednumber{*\arabic*}}, #1}{#2}
}
{
  \__examzh_question_begin:nn {label={*\arabic*.}, #1}{#2}
}
}
{
\__examzh_question_end:nn {#1}{#2}
\group_end:
}

%%%%%%%%%%%%%%%%%%%%%%%%%%% 题目编号 %%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%% 试题环境 %%%%%%%%%%%%%%%%%%%%%%%%%%%
% 定义题目元信息 meta
\NewDocumentCommand \meta { +m }
{
  \tl_if_blank:nF {#1}
  {
    \begingroup
    (\kaishu \tl_trim_spaces:n {#1}\ignorespacesafterend)
    \endgroup
  }
}
%%%%%%%%%%%%%%%%%%%%%%%%%%% 试题环境 %%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%% autoref 接口重定义 %%%%%%%%%%%%%%%%%%%%%%
\def\equationautorefname~#1\null{式(#1)\null~}
\def\footnoteautorefname{脚注}
\def\itemautorefname~#1\null{第#1项\null}
\def\figureautorefname~#1\null{图#1\null~}
\def\tableautorefname~#1\null{表#1\null~}
\def\partautorefname~#1\null{第#1部分\null}
\def\appendixautorefname{附录}
\def\chapterautorefname~#1\null{第#1章\null}
\def\sectionautorefname~#1\null{第#1节\null}
\def\subsectionautorefname~#1\null{第#1小节\null}
\def\subsubsectionautorefname~#1\null{第#1小小节\null}
\def\paragraphautorefname~#1\null{第#1段\null}
\def\subparagraphautorefname~#1\null{第#1小段\null}
\def\theoremautorefname{定理}
% \def\pageautorefname~#1\null{第~#1~页\null}
\def\HyRef@autopageref~#1{
\hyperref[{#1}]{第~\pageref*{#1}~页}
}
%%%%%%%%%%%%%%%%%%%%%% autoref 接口重定义 %%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%% 侧边栏 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage { afterpage, tikzpagenodes }

% 存储当前的 章/节 标题
\tl_new:N \__chapter_tl
\tl_new:N \__section_tl

% 特殊符号处理
% 定义函数，仅返回处理后的 token list
\cs_new:Npn \format_section_title:n #1
{
  % 设置并处理 l_tmpa_tl
  \tl_set:Nn \l_tmpa_tl {#1}

  \tl_replace_all:Nnn \l_tmpa_tl { \quad } { \\[1em] }
  \tl_replace_all:Nnn \l_tmpa_tl { —— } { \\[-.1em]\:\rotatebox{-90}{——}\\[.5em] }
  \tl_replace_all:Nnn \l_tmpa_tl { 、 } { \\[-.3em]\;、\\ }
  \tl_replace_all:Nnn \l_tmpa_tl { （ } { \\\rotatebox{-90}{（}\\ }
  \tl_replace_all:Nnn \l_tmpa_tl { ） } { \\[-.7em]\rotatebox{-90}{）}\\ }

  % 返回为 token list
  \l_tmpa_tl
}

% 定义新的接口 \chaptermark
\RenewDocumentCommand \chaptermark { s o m }
{
  \IfBooleanTF{#1}
  {
    % 星号调用: 前缀 *
    \markboth{*\hspace*{0em}\CTEXthechapter #3}{}
    \tl_set:NV \__chapter_tl {\;* \\[-.5em]\CTEXthechapter \\[1em] \format_section_title:n {#3}}
  }
  {
    \IfValueTF{#2}
    {
      % 手动调用: 只使用 #2
      \markboth{#2}{}
      \tl_set:NV \__chapter_tl {\format_section_title:n {#2}}
    }
    {
      % 普通调用: 编号 + 标题
      \markboth{\CTEXthechapter #3}{}
      \tl_set:NV \__chapter_tl {\CTEXthechapter \\[1em] \format_section_title:n {#3}}
    }
  }
}

% 定义新的接口 \sectionmark
\RenewDocumentCommand \sectionmark { s o m }
{
  % s 参数自动转化为布尔量，\booleanTF 结构判断
  \bool_if:NTF #1
  {
    % 星号调用: 前缀 *
    \markright{*\CTEXthesection #3}
    \tl_set:Nn \__section_tl {\;* \\[-.5em] \CTEXthesection \\[1em] \format_section_title:n {#3}}
  }
  {
    \IfValueTF{#2}
    {
      % 手动调用: 只使用 #2
      \markright{#2}
      \tl_set:Nn \__section_tl {\format_section_title:n {#2}}
    }
    {
      % 普通调用: 编号 + 标题
      \markright{\CTEXthesection #3}
      \tl_set:NV \__section_tl {\CTEXthesection \\[1em] \format_section_title:n {#3}}
    }
  }
}

% 语义接口
\NewDocumentCommand \manualSectionMark { m } { \sectionmark[#1]{} }
\NewDocumentCommand \manualChapterMark { m } { \chaptermark[#1]{} }

% 只在 mainmatter 启用侧栏
\bool_new:N \g__ustbbook_enable_sidebar_bool

% 本页禁用侧边栏
\NewDocumentCommand \noSideBarThisPage{}
{
  % 清除侧栏
  \RemoveFromHook{ shipout / background } [ustbbook-sidebar]
  % 下一页起添加侧栏
  \afterpage{ \ustbbook_add_sidebar: }
}

% 在 \mainmatter 后启用侧栏
\AddToHook{cmd/mainmatter/after}
{
  \bool_gset_true:N \g__ustbbook_enable_sidebar_bool
}
% 在 \backmatter 后禁用侧栏
\AddToHook{cmd/backmatter/after}
{
  \bool_gset_false:N \g__ustbbook_enable_sidebar_bool
}

% 颜色定义

% 科技蓝
\definecolor{kejilan}{RGB}{0,116,199}
% 钢铁红
\definecolor{gangtiehong}{RGB}{167,26,32}
% 金属灰
\definecolor{jinshuhui}{RGB}{179,179,179}

% 定义侧边栏
\cs_new_protected:Npn \ustbbook_add_sidebar:
{
  \AddToHook{ shipout / background } [ustbbook-sidebar]
  {
    \bool_if:NT \g__ustbbook_enable_sidebar_bool
    {
      \begin{tikzpicture}[remember~picture, overlay]
        \int_if_odd:nTF \c@page
        {
          % 奇数页: 右侧
          \path[fill=kejilan]
          ([xshift=15mm, yshift=10cm]current~page~text~area.north~east)
          rectangle
          ([xshift=35mm, yshift=-8cm]current~page~text~area.south~east)
          node[midway] (sidebarbox) {};
          \node[
            at=(sidebarbox),
            anchor=north,
            text~width=1.5em,
            inner~sep=2pt,
            xshift=-4mm,
            yshift=6.5cm
          ] { \textcolor{white!10}{\sffamily \__section_tl} };
        }
        {
          % 偶数页: 左侧
          \path[fill=kejilan]
          ([xshift=-15mm, yshift=10cm]current~page~text~area.north~west)
          rectangle
          ([xshift=-35mm, yshift=-8cm]current~page~text~area.south~west)
          node[midway] (sidebarbox) {};
          \node[
            at=(sidebarbox),
            anchor=north,
            text~width=1.5em,
            inner~sep=2pt,
            xshift=6mm,
            yshift=6.5cm
          ] { \textcolor{white!10}{\sffamily \__chapter_tl} };
        }
      \end{tikzpicture}
    }
  }
}
%%%%%%%%%%%%%%%%%%%%%%%%%%% 侧边栏 %%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%% 难度星级 %%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{ stackengine }

% 递归生成星号
\cs_new_protected:Npn \__level_tag_tokenstars:n #1
{
  \int_compare:nNnTF {#1} > {0}
    {
      % \ding{72}
      \faStar
      \__level_tag_tokenstars:n {#1 - 1}
    }
    {}
}

% 上下叠加
\cs_new_protected:Npn \__level_tag_stacked:nn #1 #2
{
  \stackanchor[1pt]
  { \__level_tag_tokenstars:n {#1} }
  { \__level_tag_tokenstars:n {#2} }
}

% 缩放盒子
\cs_new_protected:Npn \__level_tag_box_squeeze:n #1
{
  \hbox_set:Nn \l_tmpa_box { #1 }
  \makebox[1.5em][c]{%
    \box_scale:Nnn \l_tmpa_box
    % { 0.6 } % xscale-factor
    % { 0.6 } % yscale-factor
    { 0.47 } % xscale-factor
    { 0.47 } % yscale-factor
    \box_move_up:nn {1.5pt} {\box_use_drop:N \l_tmpa_box}
  }
}

% 用户接口命令
\NewDocumentCommand \taskGrade { o }
{
  \group_begin:
  \IfNoValueTF {#1}
  {
    % 没提供参数，默认显示 3 星
    \__level_tag_box_squeeze:n { \__level_tag_stacked:nn {1}{2} }
  }
  {
    % 有参数，但可能是空值
    \tl_if_blank:nTF {#1}
    {
      % 空参数 [] → 显示默认 3 星
      \__level_tag_box_squeeze:n { \__level_tag_stacked:nn {1}{2} }
    }
    {
      % 有效数字参数
      \int_case:nnF {#1}
      {
        {1} { \__level_tag_box_squeeze:n { \__level_tag_tokenstars:n {1} } }
          {2} { \__level_tag_box_squeeze:n { \__level_tag_tokenstars:n {2} } }
          {3} { \__level_tag_box_squeeze:n { \__level_tag_stacked:nn {1}{2} } }
          {4} { \__level_tag_box_squeeze:n { \__level_tag_stacked:nn {2}{2} } }
          {5} { \__level_tag_box_squeeze:n { \__level_tag_stacked:nn {2}{3} } }
      }
      {
        % fallback：非法数字也显示默认星级
        \__level_tag_box_squeeze:n { \__level_tag_stacked:nn {1}{2} }
      }
    }
  }
  \group_end:
}
%%%%%%%%%%%%%%%%%%%%%%%%%%% 难度星级 %%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%% 首行缩进 %%%%%%%%%%%%%%%%%%%%%%%%%%%
% 定义用户接口：缩进配置使用 choices 自动绑定
\keys_define:nn { ustb-book / global } {
  indent-first .choices:nn = { true, false } {
      \tl_if_eq:nnTF {#1} {true}
      { \setlength{\parindent}{2em} }
      { \setlength{\parindent}{0pt} }
    },
  indent-first .initial:n = true,
}

% 用户命令：简洁调用方式 \indentFirst {true|false}
\NewDocumentCommand \indentFirst { m } {
  \keys_set:nn { ustb-book / global } { indent-first = #1 }
}
%%%%%%%%%%%%%%%%%%%%%%%%%%% 首行缩进 %%%%%%%%%%%%%%%%%%%%%%%%%%%

\endinput

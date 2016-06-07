1.make -j36 2>&1 | tee build.log
    2>&1：表示将标准错误重定向到标准输出；tee：同时将log输出到控制台和文件

2.sudo chmod a+s /opt/platform-tools/adb
    将adb的执行权限设置为其所有者，其所有者为root则以root权限运行

3.禁止Win7驱动强制签名：bcdedit.exe -set loadoptions DDISABLE_INTEGRITY_CHECKS 
    恢复WIN7驱动强制签名：bcdedit -set loadoptions ENABLE_INTEGRITY_CHECKS 
    bcdedit /set testsigning ON

4.Windows下tasklist列出所有的进程和相应的信息，tskill查杀进程。

5.push modem
    adb root 
    adb remount 
     
    adb push modem_3_3g_n.img /system/etc/firmware/modem_3_3g_n.img 
     
    adb shell sync 
    adb shell sync 
    adb shell sync 
    adb reboot 
    pause

6.grep 
    Usage: grep [OPTION]... PATTERN [FILE]...
    <0>options:
        PATTERN is, by default, a basic regular expression (BRE).
        -E, --extended-regexp     PATTERN is an extended regular expression (ERE)

        -i, --ignore-case         ignore case distinctions  忽略大小写
        -n, --line-number         print line number with output lines
        -s, --no-messages         suppress error messages   不显示错误信息
        -R, -r, --recursive       equivalent to --directories=recurse
        -v, --invert-match        select non-matching lines 排除

    默认查找的是'标准输入'，所以要指定搜索的目录/文件：
    当搜索的是目录时，要指定'-r'；
    eg.
        grep "123" . -r
        grep "123" ./file

7.which
    在PATH变量指定的路径中，搜索某个系统命令的位置，并且返回第一个搜索结果。
    也就是说，使用which命令，就可以看到某个系统命令是否存在，以及执行的到底是哪一个位置的命令。

8.type
    用来区分某个命令到底是由shell自带的，还是由shell外部的独立二进制文件提供的。
    如果一个命令是外部命令，那么使用-p参数，会显示该命令的路径，相当于which命令。

9.whereis
    只能用于搜索二进制文件(-b)、源代码文件(-s)、说明文件(-m)。如果省略参数则返回所有的信息。

10.locate
    是"find -name"的另一种写法，但是查找方式跟find不同，它比find快得多。
    因为它不搜索具体目录，而是在一个数据库(/var/lib/locatedb)中搜索指定的文件。
    此数据库含有本地文件的所有信息，此数据库是linux系统自动创建的，数据库由updatedb程序来更新。
    updatedb是由cron daemon周期性建立的，默认情况下为每天更新一次。
    所以用locate命令你搜索不到最新更新的文件，除非你在用locate命令查找文件之前手动的用updatedb命令更新数据库。

11.mount 
    mount [-参数] [设备名称] [挂载点]
    [挂载点]必须是一个已经存在的目录，这个目录可以不为空，但挂载后这个目录下以前的内容将不可用，umount以后会恢复正常。
    [设备名称] 可以是一个分区，一个usb设备，光驱，软盘，网络共享等。
    <0>-o options  指定挂载系统选项：多个选项可以用","分割，某些选项只有在出现在文件 /etc/fstab 中时才有意义。
        -o remount,rw /
            remount     试图重新挂载一个已经挂载的文件系统。通常用来改变挂载标记，如由只读挂载改成可读写的。
            ro          以只读方式挂载
            rw          以读写方式挂载

12.mkdir 
    -p, --parents     no error if existing, make parent directories as needed

13.vim 
    <1>查找：
        :/1234
        n 向后查找
        N 向前查找
    <2>编辑：命令前面加数字表示重复的次数，加字母表示使用的缓冲区名称。使用英文句号"."可以重复上一个命令。
        0>行撤销：U。行撤销命令撤销所有在前一个编辑行上的操作。
        1>撤销：u
        2>反撤销：Ctrl+r
        3>选定文本块：使用v进入可视模式，移动光标键选定内容。 
        4>复制，yank（提起） ，常用的命令如下：
            y      在使用v模式选定了某一块的时候，复制选定块到缓冲区用； 
            yy    复制整行（nyy或者yny ，复制n行，n为数字）； 
            y^   复制当前到行头的内容； 
            y$    复制当前到行尾的内容； 
            yw   复制一个word （nyw或者ynw，复制n个word，n为数字）； 
            yG    复制至档尾（nyG或者ynG，复制到第n行，例如1yG或者y1G，复制到档尾）  
        5>剪切，delete，d与y命令基本类似，所以两个命令用法一样，包括含有数字的用法.  
            d      剪切选定块到缓冲区； 
            dd    剪切整行 
            d^    剪切至行首 
            d$     剪切至行尾 
            dw    剪切一个word 
            dG     剪切至档尾  
        6>粘贴，put（放下） 
            p      小写p代表贴至游标后（下），因为游标是在具体字符的位置上，所以实际是在该字符的后面 
            P      大写P代表贴至游标前（上） 
            整行的复制，粘贴在游标的上（下）一行；非整行的复制，则是粘贴在游标的前（后）
         
14.sublime text
    移动行：
        Ctrl + Shift + ↑/↓
    复制行：
        Ctrl + Shift + d
    单行注释：
        Ctrl + /
    多行注释：
        Ctrl + Shift + /
    折叠：
        Ctrl + Shift + [/]

15.wc - print newline, word, and byte counts for each file
    <0>options
        -c, --bytes
              print the byte counts
        -m, --chars
              print the character counts
        -l, --lines
              print the newline counts
        --files0-from=F
              read  input from the files specified by NUL-terminated names in file F; If F is -
              then read names from standard input
        -L, --max-line-length
              print the length of the longest line
        -w, --words
              print the word counts
    <1>eg.
        ls | wc -l

16.find
    find . -regex ".*.[c|h|cpp]" | xargs grep -n "#define MTK_RIL"        

    find /abc -name "*.log" | xargs grep "ERROR"

17.addr2line:解析函数地址到函数名和行号 http://www.ibm.com/developerworks/cn/linux/l-graphvis/ 
    Usage: prebuilts/gcc/linux-x86/arm/arm-eabi-4.8/bin/arm-eabi-addr2line [option(s)] [addr(s)]
    Convert addresses into line number/file name pairs.
    If no addresses are specified on the command line, they will be read from stdin
    The options are:
    # @<file>                Read options from <file>
    # -a --addresses         Show addresses
    # -b --target=<bfdname>  Set the binary file format
    # -e --exe=<executable>  Set the input file name (default is a.out)
    # -i --inlines           Unwind inlined functions
    # -j --section=<name>    Read section-relative offsets instead of addresses
    # -p --pretty-print      Make the output easier to read for humans
    # -s --basenames         Strip directory names
    # -f --functions         Show function names
    # -C --demangle[=style]  Demangle function names
    # -h --help              Display this information
    # -v --version           Display the program's version

    prebuilts/gcc/linux-x86/arm/arm-eabi-4.8/bin/arm-eabi-addr2line: supported targets: elf32-littlearm elf32-bigarm elf32-little elf32-big plugin srec symbolsrec verilog tekhex binary ihex
    Report bugs to <http://source.android.com/source/report-bugs.html>

    eg.
        ../alps/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8/bin/arm-eabi-addr2line -e ../alps/out/target/product/wt6753_66t_sz_l1/symbols/system/lib/libril.so -f 2800

18.env
    NAME
           env - run a program in a modified environment

    SYNOPSIS
           env [OPTION]... [-] [NAME=VALUE]... [COMMAND [ARG]...]

    DESCRIPTION
           Set each NAME to VALUE in the environment and run COMMAND.

    eg.
        env PATH=/usr/bin java -version        

19.正则表达式
    <0>符号解释"http://www.cnblogs.com/yirlin/archive/2006/04/12/373222.html"
    字符        描述
    \           将下一个字符标记为一个特殊字符、或一个原义字符、或一个 向后引用、或一个八进制转义符。例如，'n' 匹配字符 "n"。'\n' 匹配一个换行符。序列 '\\' 匹配 '\' 而 "\(" 则匹配 "("。
    ^           匹配输入字符串的开始位置。如果设置了 RegExp 对象的 Multiline 属性，^ 也匹配 '\n' 或 '\r' 之后的位置。
    $           匹配输入字符串的结束位置。如果设置了RegExp 对象的 Multiline 属性，$ 也匹配 '\n' 或 '\r' 之前的位置。
    *           匹配前面的子表达式零次或多次。例如，zo* 能匹配 "z" 以及 "zoo"。* 等价于{0,}。
    +           匹配前面的子表达式一次或多次。例如，'zo+' 能匹配 "zo" 以及 "zoo"，但不能匹配 "z"。+ 等价于 {1,}。
    ?           匹配前面的子表达式零次或一次。例如，"do(es)?" 可以匹配 "do" 或 "does" 中的"do" 。? 等价于 {0,1}。
    {n}         n 是一个非负整数。匹配确定的 n 次。例如，'o{2}' 不能匹配 "Bob" 中的 'o'，但是能匹配 "food" 中的两个 o。
    {n,}        n 是一个非负整数。至少匹配n 次。例如，'o{2,}' 不能匹配 "Bob" 中的 'o'，但能匹配 "foooood" 中的所有 o。'o{1,}' 等价于 'o+'。'o{0,}' 则等价于 'o*'。
    {n,m}       m 和 n 均为非负整数，其中n <= m。最少匹配 n 次且最多匹配 m 次。例如，"o{1,3}" 将匹配 "fooooood" 中的前三个 o。'o{0,1}' 等价于 'o?'。请注意在逗号和两个数之间不能有空格。
    ?           当该字符紧跟在任何一个其他限制符 (*, +, ?, {n}, {n,}, {n,m}) 后面时，匹配模式是非贪婪的。非贪婪模式尽可能少的匹配所搜索的字符串，而默认的贪婪模式则尽可能多的匹配所搜索的字符串。例如，对于字符串 "oooo"，'o+?' 将匹配单个 "o"，而 'o+' 将匹配所有 'o'。
    .           匹配除 "\n" 之外的任何单个字符。要匹配包括 '\n' 在内的任何字符，请使用象 '[.\n]' 的模式。
    (pattern)   匹配 pattern 并获取这一匹配。所获取的匹配可以从产生的 Matches 集合得到，在VBScript 中使用 SubMatches 集合，在JScript 中则使用 $0…$9 属性。要匹配圆括号字符，请使用 '\(' 或 '\)'。
    (?:pattern) 匹配 pattern 但不获取匹配结果，也就是说这是一个非获取匹配，不进行存储供以后使用。这在使用 "或" 字符 (|) 来组合一个模式的各个部分是很有用。例如， 'industr(?:y|ies)' 就是一个比 'industry|industries' 更简略的表达式。
    (?=pattern) 正向预查，在任何匹配 pattern 的字符串开始处匹配查找字符串。这是一个非获取匹配，也就是说，该匹配不需要获取供以后使用。例如，'Windows (?=95|98|NT|2000)' 能匹配 "Windows 2000" 中的 "Windows" ，但不能匹配 "Windows 3.1" 中的 "Windows"。预查不消耗字符，也就是说，在一个匹配发生后，在最后一次匹配之后立即开始下一次匹配的搜索，而不是从包含预查的字符之后开始。
    (?!pattern) 负向预查，在任何不匹配 pattern 的字符串开始处匹配查找字符串。这是一个非获取匹配，也就是说，该匹配不需要获取供以后使用。例如'Windows (?!95|98|NT|2000)' 能匹配 "Windows 3.1" 中的 "Windows"，但不能匹配 "Windows 2000" 中的 "Windows"。预查不消耗字符，也就是说，在一个匹配发生后，在最后一次匹配之后立即开始下一次匹配的搜索，而不是从包含预查的字符之后开始
    x|y         匹配 x 或 y。例如，'z|food' 能匹配 "z" 或 "food"。'(z|f)ood' 则匹配 "zood" 或 "food"。
    [xyz]       字符集合。匹配所包含的任意一个字符。例如， '[abc]' 可以匹配 "plain" 中的 'a'。
    [^xyz]      负值字符集合。匹配未包含的任意字符。例如， '[^abc]' 可以匹配 "plain" 中的'p'。
    [a-z]       字符范围。匹配指定范围内的任意字符。例如，'[a-z]' 可以匹配 'a' 到 'z' 范围内的任意小写字母字符。
    [^a-z]      负值字符范围。匹配任何不在指定范围内的任意字符。例如，'[^a-z]' 可以匹配任何不在 'a' 到 'z' 范围内的任意字符。
    \b          匹配一个单词边界，也就是指单词和空格间的位置。例如， 'er\b' 可以匹配"never" 中的 'er'，但不能匹配 "verb" 中的 'er'。
    \B          匹配非单词边界。'er\B' 能匹配 "verb" 中的 'er'，但不能匹配 "never" 中的 'er'。
    \cx         匹配由 x 指明的控制字符。例如， \cM 匹配一个 Control-M 或回车符。x 的值必须为 A-Z 或 a-z 之一。否则，将 c 视为一个原义的 'c' 字符。
    \d          匹配一个数字字符。等价于 [0-9]。
    \D          匹配一个非数字字符。等价于 [^0-9]。
    \f          匹配一个换页符。等价于 \x0c 和 \cL。
    \n          匹配一个换行符。等价于 \x0a 和 \cJ。
    \r          匹配一个回车符。等价于 \x0d 和 \cM。
    \s          匹配任何空白字符，包括空格、制表符、换页符等等。等价于 [ \f\n\r\t\v]。
    \S          匹配任何非空白字符。等价于 [^ \f\n\r\t\v]。
    \t          匹配一个制表符。等价于 \x09 和 \cI。
    \v          匹配一个垂直制表符。等价于 \x0b 和 \cK。
    \w          匹配包括下划线的任何单词字符。等价于'[A-Za-z0-9_]'。
    \W          匹配任何非单词字符。等价于 '[^A-Za-z0-9_]'。
    \xn         匹配 n，其中 n 为十六进制转义值。十六进制转义值必须为确定的两个数字长。例如，'\x41' 匹配 "A"。'\x041' 则等价于 '\x04' & "1"。正则表达式中可以使用 ASCII 编码。.
    \num        匹配 num，其中 num 是一个正整数。对所获取的匹配的引用。例如，'(.)\1' 匹配两个连续的相同字符。
    \n          标识一个八进制转义值或一个向后引用。如果 \n 之前至少 n 个获取的子表达式，则 n 为向后引用。否则，如果 n 为八进制数字 (0-7)，则 n 为一个八进制转义值。
    \nm         标识一个八进制转义值或一个向后引用。如果 \nm 之前至少有 nm 个获得子表达式，则 nm 为向后引用。如果 \nm 之前至少有 n 个获取，则 n 为一个后跟文字 m 的向后引用。如果前面的条件都不满足，若 n 和 m 均为八进制数字 (0-7)，则 \nm 将匹配八进制转义值 nm。
    \nml        如果 n 为八进制数字 (0-3)，且 m 和 l 均为八进制数字 (0-7)，则匹配八进制转义值 nml。
    \un         匹配 n，其中 n 是一个用四个十六进制数字表示的 Unicode 字符。例如， \u00A9 匹配版权符号 (?)。

    <1>匹配次数:
        +       一或多次
        *       零或多次
        ?       零或一次
        {m,n}   m到n次
        {m}     m次
        {m,}    至少m次

        ?只能匹配零个或一个字符，{n}和{m,n}也有一个重复次数的上限。
        但是其它的重复匹配语法在重复次数方面都没有上限，而这样会导致过度匹配的现象。

        *和+都是所谓的"贪婪型"元字符，它们在进行匹时是的行为模式是多多益善而不是适可而止的。
        它会尽可能的从一端文本的开头一直匹配到这段文本的末尾，而不是从这段文本的开头匹配到碰到第一个匹配时为止。 

        "懒惰型"元字符写法很简单，只要给"贪婪型"元字符加上一个?后缀即可。

20.adb
    log:
        adb logcat -v threadtime -b all | tee ~/log.txt

21.makefile
    eg.1
        #find any files except modem_config.mk
        MODEM_CONFIG_FILES=$(shell find device/qcom/$(TARGET_PRODUCT)/modem_config -type f | grep -v modem_config.mk)

        $(foreach  f,$(MODEM_CONFIG_FILES),\
            #get file name and do copy to
            $(eval ff = $(subst device/qcom/$(TARGET_PRODUCT)/modem_config/,,$(f)))\
            $(eval PRODUCT_COPY_FILES += $(f):system/etc/firmware/modem_config/$(ff)))

    ':=' & '='区别：
        1、“=”
            make会将整个makefile展开后，再决定变量的值。也就是说，变量的值将会是整个makefile中最后被指定的值。看例子：
                x = foo
                y = $(x) bar
                x = xyz
            在上例中，y的值将会是 xyz bar ，而不是 foo bar 。
        2、“:=”
            “:=”表示变量的值决定于它在makefile中的位置，而不是整个makefile展开后的最终值。
                x := foo
                y := $(x) bar
                x := xyz
            在上例中，y的值将会是 foo bar ，而不是 xyz bar 了。
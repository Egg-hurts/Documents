1.make -j36 2>&1 | tee build.log
    2>&1����ʾ����׼�����ض��򵽱�׼�����tee��ͬʱ��log���������̨���ļ�

2.sudo chmod a+s /opt/platform-tools/adb
    ��adb��ִ��Ȩ������Ϊ�������ߣ���������Ϊroot����rootȨ������

3.��ֹWin7����ǿ��ǩ����bcdedit.exe -set loadoptions DDISABLE_INTEGRITY_CHECKS 
    �ָ�WIN7����ǿ��ǩ����bcdedit -set loadoptions ENABLE_INTEGRITY_CHECKS 
    bcdedit /set testsigning ON

4.Windows��tasklist�г����еĽ��̺���Ӧ����Ϣ��tskill��ɱ���̡�

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

        -i, --ignore-case         ignore case distinctions  ���Դ�Сд
        -n, --line-number         print line number with output lines
        -s, --no-messages         suppress error messages   ����ʾ������Ϣ
        -R, -r, --recursive       equivalent to --directories=recurse
        -v, --invert-match        select non-matching lines �ų�

    Ĭ�ϲ��ҵ���'��׼����'������Ҫָ��������Ŀ¼/�ļ���
    ����������Ŀ¼ʱ��Ҫָ��'-r'��
    eg.
        grep "123" . -r
        grep "123" ./file

7.which
    ��PATH����ָ����·���У�����ĳ��ϵͳ�����λ�ã����ҷ��ص�һ�����������
    Ҳ����˵��ʹ��which����Ϳ��Կ���ĳ��ϵͳ�����Ƿ���ڣ��Լ�ִ�еĵ�������һ��λ�õ����

8.type
    ��������ĳ�����������shell�Դ��ģ�������shell�ⲿ�Ķ����������ļ��ṩ�ġ�
    ���һ���������ⲿ�����ôʹ��-p����������ʾ�������·�����൱��which���

9.whereis
    ֻ�����������������ļ�(-b)��Դ�����ļ�(-s)��˵���ļ�(-m)�����ʡ�Բ����򷵻����е���Ϣ��

10.locate
    ��"find -name"����һ��д�������ǲ��ҷ�ʽ��find��ͬ������find��öࡣ
    ��Ϊ������������Ŀ¼��������һ�����ݿ�(/var/lib/locatedb)������ָ�����ļ���
    �����ݿ⺬�б����ļ���������Ϣ�������ݿ���linuxϵͳ�Զ������ģ����ݿ���updatedb���������¡�
    updatedb����cron daemon�����Խ����ģ�Ĭ�������Ϊÿ�����һ�Ρ�
    ������locate�����������������¸��µ��ļ�������������locate��������ļ�֮ǰ�ֶ�����updatedb����������ݿ⡣

11.mount 
    mount [-����] [�豸����] [���ص�]
    [���ص�]������һ���Ѿ����ڵ�Ŀ¼�����Ŀ¼���Բ�Ϊ�գ������غ����Ŀ¼����ǰ�����ݽ������ã�umount�Ժ��ָ�������
    [�豸����] ������һ��������һ��usb�豸�����������̣����繲��ȡ�
    <0>-o options  ָ������ϵͳѡ����ѡ�������","�ָĳЩѡ��ֻ���ڳ������ļ� /etc/fstab ��ʱ�������塣
        -o remount,rw /
            remount     ��ͼ���¹���һ���Ѿ����ص��ļ�ϵͳ��ͨ�������ı���ر�ǣ�����ֻ�����ظĳɿɶ�д�ġ�
            ro          ��ֻ����ʽ����
            rw          �Զ�д��ʽ����

12.mkdir 
    -p, --parents     no error if existing, make parent directories as needed

13.vim 
    <1>���ң�
        :/1234
        n ������
        N ��ǰ����
    <2>�༭������ǰ������ֱ�ʾ�ظ��Ĵ���������ĸ��ʾʹ�õĻ��������ơ�ʹ��Ӣ�ľ��"."�����ظ���һ�����
        0>�г�����U���г��������������ǰһ���༭���ϵĲ�����
        1>������u
        2>��������Ctrl+r
        3>ѡ���ı��飺ʹ��v�������ģʽ���ƶ�����ѡ�����ݡ� 
        4>���ƣ�yank������ �����õ��������£�
            y      ��ʹ��vģʽѡ����ĳһ���ʱ�򣬸���ѡ���鵽�������ã� 
            yy    �������У�nyy����yny ������n�У�nΪ���֣��� 
            y^   ���Ƶ�ǰ����ͷ�����ݣ� 
            y$    ���Ƶ�ǰ����β�����ݣ� 
            yw   ����һ��word ��nyw����ynw������n��word��nΪ���֣��� 
            yG    ��������β��nyG����ynG�����Ƶ���n�У�����1yG����y1G�����Ƶ���β��  
        5>���У�delete��d��y����������ƣ��������������÷�һ���������������ֵ��÷�.  
            d      ����ѡ���鵽�������� 
            dd    �������� 
            d^    ���������� 
            d$     ��������β 
            dw    ����һ��word 
            dG     ��������β  
        6>ճ����put�����£� 
            p      Сдp���������α���£�����Ϊ�α����ھ����ַ���λ���ϣ�����ʵ�����ڸ��ַ��ĺ��� 
            P      ��дP���������α�ǰ���ϣ� 
            ���еĸ��ƣ�ճ�����α���ϣ��£�һ�У������еĸ��ƣ�����ճ�����α��ǰ����
         
14.sublime text
    �ƶ��У�
        Ctrl + Shift + ��/��
    �����У�
        Ctrl + Shift + d
    ����ע�ͣ�
        Ctrl + /
    ����ע�ͣ�
        Ctrl + Shift + /
    �۵���
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

17.addr2line:����������ַ�����������к� http://www.ibm.com/developerworks/cn/linux/l-graphvis/ 
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

19.������ʽ
    <0>���Ž���"http://www.cnblogs.com/yirlin/archive/2006/04/12/373222.html"
    �ַ�        ����
    \           ����һ���ַ����Ϊһ�������ַ�����һ��ԭ���ַ�����һ�� ������á���һ���˽���ת��������磬'n' ƥ���ַ� "n"��'\n' ƥ��һ�����з������� '\\' ƥ�� '\' �� "\(" ��ƥ�� "("��
    ^           ƥ�������ַ����Ŀ�ʼλ�á���������� RegExp ����� Multiline ���ԣ�^ Ҳƥ�� '\n' �� '\r' ֮���λ�á�
    $           ƥ�������ַ����Ľ���λ�á����������RegExp ����� Multiline ���ԣ�$ Ҳƥ�� '\n' �� '\r' ֮ǰ��λ�á�
    *           ƥ��ǰ����ӱ��ʽ��λ��Ρ����磬zo* ��ƥ�� "z" �Լ� "zoo"��* �ȼ���{0,}��
    +           ƥ��ǰ����ӱ��ʽһ�λ��Ρ����磬'zo+' ��ƥ�� "zo" �Լ� "zoo"��������ƥ�� "z"��+ �ȼ��� {1,}��
    ?           ƥ��ǰ����ӱ��ʽ��λ�һ�Ρ����磬"do(es)?" ����ƥ�� "do" �� "does" �е�"do" ��? �ȼ��� {0,1}��
    {n}         n ��һ���Ǹ�������ƥ��ȷ���� n �Ρ����磬'o{2}' ����ƥ�� "Bob" �е� 'o'��������ƥ�� "food" �е����� o��
    {n,}        n ��һ���Ǹ�����������ƥ��n �Ρ����磬'o{2,}' ����ƥ�� "Bob" �е� 'o'������ƥ�� "foooood" �е����� o��'o{1,}' �ȼ��� 'o+'��'o{0,}' ��ȼ��� 'o*'��
    {n,m}       m �� n ��Ϊ�Ǹ�����������n <= m������ƥ�� n �������ƥ�� m �Ρ����磬"o{1,3}" ��ƥ�� "fooooood" �е�ǰ���� o��'o{0,1}' �ȼ��� 'o?'����ע���ڶ��ź�������֮�䲻���пո�
    ?           �����ַ��������κ�һ���������Ʒ� (*, +, ?, {n}, {n,}, {n,m}) ����ʱ��ƥ��ģʽ�Ƿ�̰���ġ���̰��ģʽ�������ٵ�ƥ�����������ַ�������Ĭ�ϵ�̰��ģʽ�򾡿��ܶ��ƥ�����������ַ��������磬�����ַ��� "oooo"��'o+?' ��ƥ�䵥�� "o"���� 'o+' ��ƥ������ 'o'��
    .           ƥ��� "\n" ֮����κε����ַ���Ҫƥ����� '\n' ���ڵ��κ��ַ�����ʹ���� '[.\n]' ��ģʽ��
    (pattern)   ƥ�� pattern ����ȡ��һƥ�䡣����ȡ��ƥ����ԴӲ����� Matches ���ϵõ�����VBScript ��ʹ�� SubMatches ���ϣ���JScript ����ʹ�� $0��$9 ���ԡ�Ҫƥ��Բ�����ַ�����ʹ�� '\(' �� '\)'��
    (?:pattern) ƥ�� pattern ������ȡƥ������Ҳ����˵����һ���ǻ�ȡƥ�䣬�����д洢���Ժ�ʹ�á�����ʹ�� "��" �ַ� (|) �����һ��ģʽ�ĸ��������Ǻ����á����磬 'industr(?:y|ies)' ����һ���� 'industry|industries' �����Եı��ʽ��
    (?=pattern) ����Ԥ�飬���κ�ƥ�� pattern ���ַ�����ʼ��ƥ������ַ���������һ���ǻ�ȡƥ�䣬Ҳ����˵����ƥ�䲻��Ҫ��ȡ���Ժ�ʹ�á����磬'Windows (?=95|98|NT|2000)' ��ƥ�� "Windows 2000" �е� "Windows" ��������ƥ�� "Windows 3.1" �е� "Windows"��Ԥ�鲻�����ַ���Ҳ����˵����һ��ƥ�䷢���������һ��ƥ��֮��������ʼ��һ��ƥ��������������ǴӰ���Ԥ����ַ�֮��ʼ��
    (?!pattern) ����Ԥ�飬���κβ�ƥ�� pattern ���ַ�����ʼ��ƥ������ַ���������һ���ǻ�ȡƥ�䣬Ҳ����˵����ƥ�䲻��Ҫ��ȡ���Ժ�ʹ�á�����'Windows (?!95|98|NT|2000)' ��ƥ�� "Windows 3.1" �е� "Windows"��������ƥ�� "Windows 2000" �е� "Windows"��Ԥ�鲻�����ַ���Ҳ����˵����һ��ƥ�䷢���������һ��ƥ��֮��������ʼ��һ��ƥ��������������ǴӰ���Ԥ����ַ�֮��ʼ
    x|y         ƥ�� x �� y�����磬'z|food' ��ƥ�� "z" �� "food"��'(z|f)ood' ��ƥ�� "zood" �� "food"��
    [xyz]       �ַ����ϡ�ƥ��������������һ���ַ������磬 '[abc]' ����ƥ�� "plain" �е� 'a'��
    [^xyz]      ��ֵ�ַ����ϡ�ƥ��δ�����������ַ������磬 '[^abc]' ����ƥ�� "plain" �е�'p'��
    [a-z]       �ַ���Χ��ƥ��ָ����Χ�ڵ������ַ������磬'[a-z]' ����ƥ�� 'a' �� 'z' ��Χ�ڵ�����Сд��ĸ�ַ���
    [^a-z]      ��ֵ�ַ���Χ��ƥ���κβ���ָ����Χ�ڵ������ַ������磬'[^a-z]' ����ƥ���κβ��� 'a' �� 'z' ��Χ�ڵ������ַ���
    \b          ƥ��һ�����ʱ߽磬Ҳ����ָ���ʺͿո���λ�á����磬 'er\b' ����ƥ��"never" �е� 'er'��������ƥ�� "verb" �е� 'er'��
    \B          ƥ��ǵ��ʱ߽硣'er\B' ��ƥ�� "verb" �е� 'er'��������ƥ�� "never" �е� 'er'��
    \cx         ƥ���� x ָ���Ŀ����ַ������磬 \cM ƥ��һ�� Control-M ��س�����x ��ֵ����Ϊ A-Z �� a-z ֮һ�����򣬽� c ��Ϊһ��ԭ��� 'c' �ַ���
    \d          ƥ��һ�������ַ����ȼ��� [0-9]��
    \D          ƥ��һ���������ַ����ȼ��� [^0-9]��
    \f          ƥ��һ����ҳ�����ȼ��� \x0c �� \cL��
    \n          ƥ��һ�����з����ȼ��� \x0a �� \cJ��
    \r          ƥ��һ���س������ȼ��� \x0d �� \cM��
    \s          ƥ���κοհ��ַ��������ո��Ʊ������ҳ���ȵȡ��ȼ��� [ \f\n\r\t\v]��
    \S          ƥ���κηǿհ��ַ����ȼ��� [^ \f\n\r\t\v]��
    \t          ƥ��һ���Ʊ�����ȼ��� \x09 �� \cI��
    \v          ƥ��һ����ֱ�Ʊ�����ȼ��� \x0b �� \cK��
    \w          ƥ������»��ߵ��κε����ַ����ȼ���'[A-Za-z0-9_]'��
    \W          ƥ���κηǵ����ַ����ȼ��� '[^A-Za-z0-9_]'��
    \xn         ƥ�� n������ n Ϊʮ������ת��ֵ��ʮ������ת��ֵ����Ϊȷ�����������ֳ������磬'\x41' ƥ�� "A"��'\x041' ��ȼ��� '\x04' & "1"��������ʽ�п���ʹ�� ASCII ���롣.
    \num        ƥ�� num������ num ��һ����������������ȡ��ƥ������á����磬'(.)\1' ƥ��������������ͬ�ַ���
    \n          ��ʶһ���˽���ת��ֵ��һ��������á���� \n ֮ǰ���� n ����ȡ���ӱ��ʽ���� n Ϊ������á�������� n Ϊ�˽������� (0-7)���� n Ϊһ���˽���ת��ֵ��
    \nm         ��ʶһ���˽���ת��ֵ��һ��������á���� \nm ֮ǰ������ nm ������ӱ��ʽ���� nm Ϊ������á���� \nm ֮ǰ������ n ����ȡ���� n Ϊһ��������� m ��������á����ǰ��������������㣬�� n �� m ��Ϊ�˽������� (0-7)���� \nm ��ƥ��˽���ת��ֵ nm��
    \nml        ��� n Ϊ�˽������� (0-3)���� m �� l ��Ϊ�˽������� (0-7)����ƥ��˽���ת��ֵ nml��
    \un         ƥ�� n������ n ��һ�����ĸ�ʮ���������ֱ�ʾ�� Unicode �ַ������磬 \u00A9 ƥ���Ȩ���� (?)��

    <1>ƥ�����:
        +       һ����
        *       �����
        ?       ���һ��
        {m,n}   m��n��
        {m}     m��
        {m,}    ����m��

        ?ֻ��ƥ�������һ���ַ���{n}��{m,n}Ҳ��һ���ظ����������ޡ�
        �����������ظ�ƥ���﷨���ظ��������涼û�����ޣ��������ᵼ�¹���ƥ�������

        *��+������ν��"̰����"Ԫ�ַ��������ڽ���ƥʱ�ǵ���Ϊģʽ�Ƕ�����ƶ������ʿɶ�ֹ�ġ�
        ���ᾡ���ܵĴ�һ���ı��Ŀ�ͷһֱƥ�䵽����ı���ĩβ�������Ǵ�����ı��Ŀ�ͷƥ�䵽������һ��ƥ��ʱΪֹ�� 

        "������"Ԫ�ַ�д���ܼ򵥣�ֻҪ��"̰����"Ԫ�ַ�����һ��?��׺���ɡ�

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

    ':=' & '='����
        1����=��
            make�Ὣ����makefileչ�����پ���������ֵ��Ҳ����˵��������ֵ����������makefile�����ָ����ֵ�������ӣ�
                x = foo
                y = $(x) bar
                x = xyz
            �������У�y��ֵ������ xyz bar �������� foo bar ��
        2����:=��
            ��:=����ʾ������ֵ����������makefile�е�λ�ã�����������makefileչ���������ֵ��
                x := foo
                y := $(x) bar
                x := xyz
            �������У�y��ֵ������ foo bar �������� xyz bar �ˡ�
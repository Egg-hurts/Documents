0.tips:
    <1>Why are colons required for the if/while/def/class statements?
        The colon is required primarily to enhance readability (one of the results of the experimental ABC language). Consider this:

        if a == b
            print a
        versus

        if a == b:
            print a
        Notice how the second one is slightly easier to read. Notice further how a colon sets off the example in this FAQ answer; it’s a standard usage in English.
        Another minor reason is that the colon makes it easier for editors with syntax highlighting; 
        they can look for colons to decide when indentation needs to be increased instead of having to do a more elaborate parsing of the program text.
    <2>dir() & help()
        dir()用来查询一个类或者对象所有属性。
        >>>print dir(list)
        help()用来查询的说明文档。
        >>>print help(list)

        (list是Python内置的一个类)

1.运行方式：
    <1>命令行模式: 运行Python，在命令行输入命令并执行。
    <2>程序模式: 写一段Python程序并运行。
        1.py文件：
            hello.py：
                print('Hello World!')

            $python hello.py
        2.可执行脚本：
            hello.py：
                #!/usr/bin/env python
                print('Hello World!')
            
            chmod 755 hello.py
            ./hello.py

2.print()函数:
    >>>print('Hello World!')
    print是一个常用函数，其功能就是输出括号中得字符串。
    print后跟多个输出，以逗号分隔。
    （在Python 2.x中，print还可以是一个'关键字'，可写成print 'Hello World!'，但这在3.x中行不通 ）

3.数据类型：
    变量不需要声明，不需要删除，可以直接回收使用。
    type(): 查询数据类型
    id():对象ID
    用 is 比较
        a is b
        type(a) is type(b)
        对于较小的整数，python会选择缓存起来，所以这些对象的ID都是唯一的，不会因为定义了多个对象就产生多个ID：
        '''
            integer objects for all integers between -5 and 256, when you create an int in that range you actually just get back a reference to the existing object.
        '''
        "http://stackoverflow.com/questions/3402679/identifying-objects-why-does-the-returned-value-from-id-change"
        "http://stackoverflow.com/questions/4293408/ids-of-immutable-types"

    a=10         # int 整数
    a=1.3        # float 浮点数
    a=True       # 真值 (True/False)
    a='Hello!'   # 字符串
    以上是最常用的数据类型，对于字符串来说，也可以用双引号（此外还有分数，字符，复数（j）等其他数据类型）



4.序列：sequence(序列)是一组有顺序的对象（元素）的集合
    序列可以包含一个或多个元素，也可以没有任何元素。元素可以是基本数据类型或另一个序列，以及其他对象。

    序列有两种：tuple（定值表； 也有翻译为元组）和 list（表）
    tuple 和 list 的主要区别在于，一旦建立，tuple 的各个元素不可再变更，而 list 的各个元素可以再变更。
        >>>s1 = (2, 1.3, 'love', 5.6, 9, 12, False)         # s1是一个tuple
        >>>s2 = [True, 5, 'smile']                          # s2是一个list
        >>>s3 = [1,[3,4,5]]
        >>>s4 = []

    序列元素的下标从0开始：
        >>>print s1[0]
        >>>print s2[2]
        >>>print s3[1][2]

    对list的某个元素赋值：
        >>>s2[1] = 3.0

    范围引用：[下限:上限:步长]
        >>>print s1[0:]             # s1的所有元素，等效于s1[:]
        >>>print s1[:5]             # 从开始到下标4（下标5的元素 不包括在内）
        >>>print s1[2:]             # 从下标2到最后
        >>>print s1[0:5:2]          # 从下标0到下标4 (下标5不包括在内)，每隔2取一个元素（下标为0，2，4的元素）
        >>>print s1[2:0:-1]         # 从下标2到下标1
        在范围引用的时候，如果写明上限，那么这个上限本身不包括在内。

    尾部元素引用：
        >>>print s1[-1]             # 序列最后一个元素
        >>>print s1[-3]             # 序列倒数第三个元素
        同样，如果s1[0:-1], 那么最后一个元素不会被引用

    字符串是 tuple：字符串是一种特殊的元组，因此可以执行元组的相关操作。
        >>>str = 'abcdef'
        >>>print str[2:4]

    list:
        s.append(x) appends x to the end of the sequence (same as s[len(s):len(s)] = [x]) 
        s.extend(t) extends s with the contents of t (same as s[len(s):len(s)] = t) 

        list1 = [[i,j] for i in range(2) for j in range(3)]

        >>list1 = [1, 2, 3, 4, 5]
        >>list2 = [1, 4, 5] 
        >>list3 = list(set(list1) - set(list2))


5.运算：运算符从根本上都是定义在类内部的方法
    数学 +, -, *, /, **（乘方）, %
    判断 ==, !=, >, >=, <, <=, in（5 in [1,3,5]）
    逻辑 and, or, not

    eg.
        >>>print [1,2,3] - [3,4]
        会有错误信息，说明该运算符“-”没有定义。可以继承list类，添加对"-"的定义。

        class superList(list):
            def __sub__(self, b):
                a = self[:]     # 这里，self是supeList的对象。
                b = b[:]        
                while len(b) > 0:
                    element_b = b.pop()
                    if element_b in a:
                        a.remove(element_b)
                return a

        print superList([1,2,3]) - superList([3,4])
        如果 __sub__() 已经在父类中定义，你又在子类中定义了，那么子类的对象会参考子类的定义，而不会载入父类的定义。
        任何其他的属性也是这样。

6.if：
    if  <条件1>:
        statement
    elif <条件2>:
        statement
    elif <条件3>：
        statement
    else:
        statement

    tips：以四个空格的缩进来表示隶属关系, Python中不能随意缩进

    true_part if condition else false_part

7.range()函数：
    <1>这个函数的功能是新建一个表。
    <2>这个表的元素都是整数，从0开始，下一个元素比前一个大1，直到函数中所写的上限（不包括该上限本身）。
    eg. 
        idx = range(5)
        print idx
        可以看到idx是[0,1,2,3,4]

    python 3.2用下面语句代替 range(x):
        list(range(x))
    具体来说，在3.2中，range 生成了一个iterator，要转换成 list 的类型。        

8.循环
    for：
        for 元素 in 序列: 
            statement

        eg.        
            for a in range(10):
            print a**2

    while：
        while 条件:
            statement

9.中断循环
    continue
    break

10.函数
    <1>同过 def 关键字定义，可以返回多个值，返回 None 或者不返回。None 相当于C语言中的Null。
    <2>基本数据类型的参数：值传递；表作为参数：指针传递。
        def function_name(a,b,c):
            statement
            return something  # return不是必须的
    eg.
        def square_sum(a,b):
            c = a**2 + b**2
            return (a,b,c)

11.类
    <1>方法的第一个参数必须是self，无论是否用到。
    <2>子类在定义的括号中声明其父类，当括号中为object时，说明这个类没有父类。
        eg.
            class Bird(object):
                have_feather = True
                way_of_reproduction = 'egg'
                def move(self, dx, dy):
                    position = [0,0]
                    position[0] = position[0] + dx
                    position[1] = position[1] + dy
                    return position

            class Chicken(Bird):
                way_of_move = 'walk'
                possible_in_KFC = True

            class Oriole(Bird):
                way_of_move = 'fly'
                possible_in_KFC = False

            summer = Chicken()
            print summer.have_feather
            print summer.move(5,8)    
    <3>__init__()是一个特殊方法(special method)。Python有一些特殊方法，特点是名字前后有两个下划线。
        如果在类中定义了 __init__() 这个方法，创建对象时，Python会自动调用这个方法。这个过程也叫初始化。
    <4>对象属性
        通过赋值给self.attribute，给对象增加一些性质。
        self会传递给各个方法。在方法内部，可以通过引用self.attribute，查询或修改对象的性质。
        eg.
            class Human(object):
                def __init__(self, input_gender):
                    self.gender = input_gender
                def printGender(self):
                    print self.gender

            li_lei = Human('male') # 这里，'male'作为参数传递给__init__()方法的input_gender变量。
            print li_lei.gender
            li_lei.printGender()
    <5>类属性被所有同一类及其子类的对象共享。类属性值的改变会影响所有的对象。
        在方法中更改类变量属性的值是危险的，这样会影响根据这个类定义的所有对象的这一属性。
        属性是immutable的(比如整数、字符串)不会有影响；但属性是mutable的话(比如list)，就会出现问题。
        eg.
            class Human(object):
                Can_Talk = True
                Can_Walk = True
                Age = 0
                Name = ["Li", "Lei"]
             
            a = Human()
            b = Human()
             
            a.Age += 1
            print a.Age
            print b.Age
             
            a.Name[0] = "Wang"
            print a.Name
            print b.Name

        为什么immutable是可行的呢？原因是，在更改对象属性时，如果属性是immutable的，该属性会被复制出一个副本，存放在对象的__dict__中。
        你可以通过下面的方式查看：
        print a.__class__.__dict__
        print a.__dict__
        注意到类中和对象中各有一个Age。一个为0， 一个为1。所以我们在查找a.Age的时候，会先查到对象的__dict__的值，也就是1。
        但mutable的类属性，在更改属性值时，并不会有新的副本。所以更改会被所有的对象看到。

        所以，为了避免混淆，最好总是区分类属性和对象的属性，而不能依赖上述的immutable属性的复制机制。

12.import
    # 检查是单独执行还是被导入
    if __name__ == '__main__':
        # Yes
        statements
    else:
        # No (可能被作为模块导入)
        statements 

13.字符串
    <1>join & split
        str.join(iterable) 
            Return a string which is the concatenation of the strings in the iterable iterable. 
            A TypeError will be raised if there are any non-string values in iterable, including bytes objects. 
            The separator between elements is the string providing this method.
         
        >>> params = {"server":"mpilgrim", "database":"master", "uid":"sa", "pwd":"secret"}
        >>> ["%s=%s" % (k, v) for k, v in params.items()]
        ['server=mpilgrim', 'uid=sa', 'database=master', 'pwd=secret']
        >>> ";".join(["%s=%s" % (k, v) for k, v in params.items()])
        'server=mpilgrim;uid=sa;database=master;pwd=secret'
         
        >>> s='server=mpilgrim;uid=sa;database=master;pwd=secret'
        >>> s.split(";")
        ['server=mpilgrim', 'uid=sa', 'database=master', 'pwd=secret']
        >>> s.split(";", 1)  # split 接受一个可选的第二个参数，它是要分割的次数
        ['server=mpilgrim', 'uid=sa;database=master;pwd=secret']

14.文件操作
    python中对文件、文件夹的操作需要涉及到os模块和shutil模块。

    增：
        # 创建空文件
        os.mknod("test.txt")        
        # 直接打开一个文件，如果文件不存在则创建文件
        open("test.txt",w)

        # 创建目录
        os.mkdir("dir")

    删：
        # 删除文件
        os.remove("file")

        # 只能删除空目录
        os.rmdir("dir")
        # 空目录、有内容的目录都可以删
        shutil.rmtree("dir") 

    改：
        复制：
            # oldfile和newfile都只能是文件
            shutil.copyfile("oldfile","newfile")
            # oldfile只能是文件；new可以是文件或目标目录
            shutil.copy("oldfile","new")

            # 递归复制文件夹
            # olddir和newdir都只能是目录，且newdir必须不存在
            shutil.copytree("olddir","newdir")

        移动：
            # 移动文件/目录
            # Recursively move a file or directory (src) to another location (dst).
            # If the destination is an existing directory, then src is moved inside that directory. If the destination already exists but is not a directory, it may be overwritten depending on os.rename() semantics.
            # If the destination is on the current filesystem, then os.rename() is used. Otherwise, src is copied (using shutil.copy2()) to dst and then removed.
            shutil.move("oldpos","newpos")

        # 重命名文件/目录
        os.rename("oldname","newname")

        # 转换目录
        os.chdir("path")

    查：
        # 判断目标是否存在
        os.path.exists("goal")
        # 判断目标是否是目录
        os.path.isdir("goal")
        # 判断目标是否是文件
        os.path.isfile("goal")


15.编码问题:"http://www.cnblogs.com/huxi/archive/2010/12/05/1897271.html"
    <1>告知解释器，代码中的字符要以什么编码进行解析（默认是ascii），所以py文件也要保存为相应的编码
    # -*- coding: utf-8 -*-
    # coding: utf-8

    <2>字符串在Python内部的表示是unicode编码。
    因此，在做编码转换时，通常需要以unicode作为中间编码，即先将其他编码的字符串解码（decode）成unicode，再从unicode编码（encode）成另一种编码。
    unicode ------ encode('utf-8/GBK/ASCII/..') --->>> UTF-8/GBK/ASCII/..
    unicode <<<--- decode('utf-8/GBK/ASCII/..') ------ UTF-8/GBK/ASCII/..
    
    <3>str和unicode都是basestring的子类。严格意义上说，str其实是字节串，它是unicode经过编码后的字节组成的序列。
    >>> print repr('汉')     #utf-8
    '\xe6\xb1\x89'
    >>> print repr(u'汉')    #unicode
    u'\u6c49'
    >>> print repr('汉'.decode('utf-8'))     #utf-8 decode to unicode
    u'\u6c49'

    >>> len('汉')
    3
    >>> len(u'汉')
    1

    <4>读写文件
    内置的open()方法打开文件时，read()读取的是str，读取后需要使用正确的编码格式进行decode()。
    write()写入时，如果参数是unicode，则需要使用你希望写入的编码进行encode()，如果是其他编码格式的str，则需要先用该str的编码进行decode()，转成unicode后再使用写入的编码进行encode()。
    如果直接将unicode作为参数传入write()方法，Python将先使用源代码文件声明的字符编码进行编码然后写入。
    
    另外，模块codecs提供了一个open()方法，可以指定一个编码打开文件，使用这个方法打开的文件读取返回的将是unicode。
    写入时，如果参数是unicode，则使用open()时指定的编码进行编码后写入；如果是str，则先根据源代码文件声明的字符编码，解码成unicode后再进行前述操作。
    相对内置的open()来说，这个方法比较不容易在编码上出现问题。

16.引用、引用计数、浅拷贝、深拷贝
    '''
        If an object's value can be modified, the object is said to be mutable.
        If the value cannot be modified,the object is said to be immutable.
    '''
    使用=赋值操作符时，对于immutable对象，会创建一份拷贝；对于mutable对象，会创建引用，同时该对象引用计数加1。
    一个对象赋值或加入容器时，它的引用计数就会自增；当使用 del 时或变量赋值为其他值时，引用计数就会自减。
    当引用计数为0时，python的垃圾回收器就会回收该变量。

    copy.copy()：浅拷贝制创建一个新对象，但它包含的子元素仍然是原来对象子元素的引用
    copy.deepcopy()：深拷贝创建一个新对象，并递归复制所有子对象
    
    eg.
        >>> a = [1, 2, [3, 4]]
        >>> import copy
        >>> b = copy.deepcopy(a)
        >>> for i in a:
        ...     print i, id(i)
        ... 
        1 23824312
        2 23824288
        [3, 4] 140115353025280
        >>> for i in b:
        ...     print i, id(i)
        ... 
        1 23824312                  # 对于immutable元素，其引用不变
        2 23824288
        [3, 4] 140115353252928      # 对于mutable，深拷贝则会创建一个新对象（引用）
        >>> b = a[:]
        >>> for i in b:
        ...     print i, id(i)
        ... 
        1 23824312
        2 23824288
        [3, 4] 140115353025280      # 对于mutable，浅拷贝仍然保留之前的对象（引用）

17.selenium web自动化测试
    环境搭建：
        Selenium + python的自动化框架搭建
            > "http://blog.csdn.net/five3/article/details/7030704"
        Selenium2(WebDriver)总结(一)---启动浏览器、设置profile&加载插件
            > "http://www.cnblogs.com/puresoul/p/4251536.html"

    使用：
        轻松自动化---selenium-webdriver(python) (三)  对象定位
            > "http://www.cnblogs.com/fnng/p/3183777.html"
        轻松自动化---selenium-webdriver(python) (十二) 按键
            > "http://www.cnblogs.com/fnng/p/3258946.html"

    AutoIt GUI操作：
        selenium借助AutoIt识别上传（下载）详解
            > "http://www.cnblogs.com/fnng/p/4188162.html"

18.log
    python 的日志logging模块学习
        > "http://www.cnblogs.com/dkblog/archive/2011/08/26/2155018.html"

    eg.
        import logging

        logging.basicConfig(level=logging.DEBUG,
            format='%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s %(message)s',
            datefmt='%a, %d %b %Y %H:%M:%S',
            filename='myapp.log',
            filemode='w')

        logging.debug('This is debug message')
        logging.info('This is info message')
        logging.warning('This is warning message')
内网 IP 192.168.42.21 
外网 IP 218.18.53.212 




<1>M81C:
    AP:
        git clone ssh://用户名@192.168.42.21:29418/WT6753_65C_SZ 
        git checkout WT6753_65C_SZ

    Modem:
        git clone ssh://用户名@192.168.42.21:29418/MT_modem 
        git checkout WT6753_65C_SZ



<2>MA01C
    MA01-MT6753T 后续使用 MA01C-MT6753T(K96083A1) 
    MA01-MT6755  后续使用 MA01Q-MT6755(K96057A1)

    MA01C-MT6753T
        AP:
            git clone ssh://用户名@192.168.42.21:29418/WT6753_65C_SZ
            git checkout MA01C_main 
        Modem:
            git clone ssh://用户名@192.168.42.21:29418/MT_modem
            git checkout MA01C_main

    MA01Q-MT6755:
        AP:
            git clone ssh://用户名@192.168.42.21:29418/MT6755.L1.P96.3
            git checkout MT6755.L1.P96.3
        Modem(和 M81C modem用同一个库，分支不一样):
            git clone ssh://用户名@192.168.42.21:29418/MT_modem
            git checkout MT6755_SMT



<3>M91MP
    AP:
        git clone ssh://用户名@192.168.42.21:29418/WT6755_66_SZ_L -b WT6755_66_SZ_L 
    Modem:
        git clone ssh://用户名@192.168.42.21:29418/MT_modem -b WT6755_66_SZ_L
        git clone ssh://用户名@192.168.42.21:29418/MT_modem -b WT6755_66_SZ_C2K



<4>T86519A1 android_5.0 --- MMX 
    AMSS:
        repo init -u ssh://192.168.42.21:29418/manifest -b msm8916_mmx_dev -m msm8916_mmx_amss_l_dev_SZ.xml
        repo sync -c
    Android:
        repo init -u ssh://192.168.42.21:29418/manifest -b msm8916_mmx_dev -m msm8916_mmx_l_dev_SZ.xml
        repo sync -c



<5>T98035AA1_LATA   --- TCL
    AP:
        git clone ssh://用户名@192.168.42.21:29418/MT6572_L1.MP6
        git checkout MT6572_L1.MP6
    modem:
        git clone ssh://用户名@192.168.42.21:29418/MT_modem
        git checkout MT6572_L1.MP6



<6>T82918AA1        --- Karbonn
    NEW:
        Android： 
            repo init -u ssh://192.168.42.21:29418/manifest.git -b 8939 -m android_bra_karbonn_T82918AA1_sz.xml && repo sync -c 
            repo start bra_karbonn_T82918AA1_sz --all 
        modem： 
            repo init -u ssh://192.168.42.21:29418/manifest.git -b 8939 -m bra_8930_2150.1_modem.xml && repo sync -c 
            repo start bra_8930_2150.1_modem --all

    OLD:
        modem:
            repo init -u ssh://192.168.42.21:29418/manifest.git -b 8939 -m amss_trunk_LA2.1_MR1_sz.xml
            repo sync
            repo start trunk_LA2.1_MR1_sz --all

                build setup:
                <1> compile
                    cd ../amss/modem_proc/build
                    ./wt_build_8936.sh p=combo c=all s=Kar 

                    notes:
                        1>如果你要做sim1和sim2交换的话，你需要在../amss/wingcust/combo里面拷贝一个wl目录，并重命名为你的项目（比如说重命名为Kar）。（wl是传音的专门为sim卡交换做的客制化）
                        2>编译脚本为./wt_build_8936.sh p=combo c=all s=Kar (原理是首先把combo/all/里面的文件覆盖到amss/modem_proc/，然后再把Kar里面的文件覆盖到amss/modem_proc/里面)
                        3>编译脚本不管是8929的项目还是8939的项目，都使用wt_build_8936.sh。
                <2> pack
                    cd ../amss/common/build
                    python update_common_info.py contents_UG_8929.xml

                    notes:
                        主芯片如果是8929 使用 python update_common_info.py contents_UG_8929.xml
                        如果是8939 使用 python update_common_info.py contents_UG_8939_64.xml
         
        AP:
            repo init -u ssh://192.168.42.21:29418/manifest.git -b 8939 -m android_bra_karbonn_8939_LA2.1_L_MR1_sz.xml 
            repo sync
            repo start bra_karbonn_8939_LA2.1_L_MR1_sz --all



<7>S89116AA1        --- ASUS
    AMSS/DMSS Software AMSS8916      
    AMSS/DMSS Build ID M8939AAAAANLYD21530.1
    
    AP:
        repo init -u ssh://192.168.42.21:29418/manifest -b 8939 -m android_ASUS_S89116AA1_msm8939_21530.1.xml && repo sync -c
        repo start android_ASUS_S89116AA1_msm8939_21530.1 --all
    modem:
        repo init -u ssh://192.168.42.21:29418/manifest -b 8939 -m amss_ASUS_S89116AA1_msm8939_21530.1.xml && repo sync -c
        repo start amss_ASUS_S89116AA1_msm8939_21530.1 --all
    
    新基线amss_msm8939_21532.1原始基线：
        android: 
            repo init -u ssh://192.168.42.21:29418/manifest -b 8939 -m android_msm8939_21532.1.xml
            branch ：android_msm8939_21532.1 
        amss: 
            repo init -u ssh://192.168.42.21:29418/manifest -b 8939 -m amss_msm8939_21532.1.xml && repo sync
            repo start amss_msm8939_21532.1 --all

    从CS2原始amss基线创建开发分支如下：
        amss:
            repo init -u ssh://192.168.42.21:29418/manifest -b 8939 -m amss_ASUS_S89116AA1_msm8939_21532.1.xml && repo sync
            repo start amss_ASUS_S89116AA1_msm8939_21532.1 --all

        android:
            repo init -u ssh://192.168.42.21:29418/manifest -b 8939 -m android_ASUS_S89116AA1_msm8939_CS2.xml && repo sync
            repo start android_ASUS_S89116AA1_msm8939_CS2 --all


<8>T96085AB1        --- MMX
    AP:
        git clone ssh://用户名@192.168.42.21:29418/WT6755_66_SZ_L -b 
            remotes/origin/Android_MMX_T96085AB1_BaseLineAllPatch
            remotes/origin/Android_MMX_T96085AB1_BaseLineCTS



<9>T98350AA1代码路径:
    Android代码:
        git clone ssh://用户名@192.168.42.24:29418/Mtk6735  -b Android_INTEX_T98350AA1_MT6735_V2.39.1_BaseLine
    Modem代码:
        git clone ssh://用户名@192.168.42.24:29418/Mtk_Modem -b Modem_INTEX_T98350AA1_MT6735


<10>奇酷项目K96086AA1 MT6750 MP 代码地址：
    android：
        repo init -u ssh://192.168.42.24:29418/manifest -b MT6750 -m android_QIKU_K96086AA1_MT6750_V1.xml
        分支：android_QIKU_K96086AA1_MT6750_V1

        全网通，即1603_A01
        电信版，即1603_A02
        移动版，即1603_M01

    modem：
        repo init -u ssh://192.168.42.24:29418/manifest -b MT6750 -m modem_QIKU_K96086AA1_MT6750_V1.xml
        分支：modem_QIKU_K96086AA1_MT6750_V1
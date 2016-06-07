MTK modem&AP配置：
Steps for building project

 1) Untar ${customer_project}_KERNEL.tar.gz to Folder A
     e.g. tar zxf ${customer_project}_KERNEL.tar.gz

 2) Untar ${customer_project}_INHOUSE.tar.gz and overwrite to Folder A
     e.g.  cat ${customer_project}_INHOUSE.tar.gz* | tar zxf -

 3) build modem imag.. please refer to "Build_Configure_Modem_MOLY" sheet

        ①C2K:进入 ../MT_modem/C2K/stack/CP 目录，执行./build.bat查看一下项目名称，
            执行./build.bat "WT6753_65C_SZ_L1(C2K_SVLTE)" new 进行编译
        ②非C2K：进入 ../MT_modem/LTTG_LWG_DSDS 目录，执行
            ./make.sh "MT6753_XXX_(LTTG_xxx).mak" new 
            或者 ./make.sh "MT6753_XXX_(LWG_xxx).mak" new

        然后进行重命名：perl device/mediatek/build/build/tools/modemRenameCopy.pl [Modem Codebase Path] [Modem Project Makefile Name]
        eg.
        perl device/mediatek/build/build/tools/modemRenameCopy.pl ../../MT_modem/LTTG_LWG_DSDS/ "WT6753_65C_SZ_L1(LTTG_DSDS)"
 
 4) copy modem folder to alps/vendor/mediatek/proprietary/custom/${project}/modem/${modem}

 5) open alps/device/${company}/${project}/ProjectConfig.mk
    open kernel-3.10/arch/arm64/configs/wt6753_66t_sz_l1_debug_defconfig
 
 6) set CUSTOM_MODEM=${modem}

 7) Run AOSP build command to build target project.




关闭modem3
at+efun=0
at+esuo=9   #切换到modem3
at+epof     #关modem3
at+esuo=4   #切换到MD1
at+epof     #关MD1




【band select】
具体的band是否勾选，受NVRAM_EF_AS_BAND_SETTING_LID中默认值的影响以及AT+CSRA配置的模式的影响。
如果不让band41设置为非勾选状态，可以通过修改NVRAM_EF_AS_BAND_SETTING_LID的默认值:NVRAM_EF_AS_BAND_SETTING_DEFAULT,将其中的band41对应的bit位设置为0即可
修改nvram后，使用半擦下载或者将NVRAM_EF_AS_BAND_SETTING_LID_VERNO的值+1，可以使得代码中的修改的默认值生效。



4G voice：
    LTE+CDMA    ->  SVLTE
    LTE+GSM     ->  SGLTE

    LTE/CDMA    ->  SRLTE
    LTE/GSM     ->  CSFB




__OP01__ ，是针对CMCC定义。
__OP02__ ，是针对China Unicom定义。
__OP09__ ，是针对China Telecom定义。

配置为OP09:
OPTR_SPEC_SEG_DEF = OP09_SPEC0212_SEGDEFAULT




driver only版本:
----mtk原始release给贵司的版本，贵司没有改动过code。




Modem初始化SIM卡的时间花费因卡而异，无法给出准确时间。
但Modem在SIM初始化完成后会告知Android，因此仅仅需要关注于Android内部的状态即可。
方法如下：
监听ACTION_SIM_STATE_CHANGED，来判断是否launch对应的apk。
如果这个intent中“state”为ready，则表示SIM卡已经ready；
如果为Absent，则表示SIM卡未插。
Intent中的“simid”存储的是这个Intent对应的是哪一张SIM卡。




Android 5.0以上的版本建立数据的机制：
先将所有符合条件的数据连线建起来，然后比较这些不同网络的分数，分数高的会被保留，分数低的会被断开。
断开后我们会设置一个delay timer, google默认的20s。
log:
    "startAlarmForReconnect: delay=20000"
code:
    DcTrackerBase.java
    protect static final int APN_DELAY_DEFAULT_MILLIS = 20000;




切换数据业务的卡：
数据业务切换到卡2的过程是需要先将卡1的ps etach，会发送"RIL_REQUEST_ALLOW_DATA"。
等response回来后将卡1的状态机切换为idle，后才会执行卡2的ps attach动作,即"RIL_REQUEST_SET_ACTIVE_PS_SLOT"




设置中的VoLTE开关应默认为开启状态
上层菜单读取只是一个数据库值，设置device.mk的persist.mtk.volte.enable和DatabaseHelper.java中将ENHANCED_4G_MODE_ENABLED使能就行.




log过滤关键字：
Modem:
    非C2K：
        MD3 debug trace: 
            CSS is not allowed to send +ECGREG to AP0  //C2K的CGATT查询ECGREG注册状态
        UE_MODE:
            MSG_ID_RAC_GMSS_UEMODE_PARAM_UPDATE_REQ     UE_MODE_PS_MODE_2 / UE_MODE_CS_PS_MODE_1
        rsrp:
            store PCell power level RSRP

        A2/B2/.. enter cond

    C2K：
        (<<<|>>>).*?(?<!Null)$

        PilotStrength.0     //EVDO
        PilotPn.0=.* PilotStrength.0
        Strength.0          //1x
        Stale.0=0, Pilot PN.0=.* Strength.0.*   , Stale.1=1,    //1x
        (CP Search Results Active)|(CP RMC RUP SEARCHER STATUS)     //1x|EVDO

        1x:
            (<<<|>>>) Msg Id.*?(?<!Null)$
            CP State=Idle

        EVDO:
            ATState=(Idle|Connected)


AP：
    >radio_log:
        >RILJ:(../alps/vendor/mediatek/proprietary/hardware/ril/c2k/include/telephony/ril.h)
            RILJ.*(<|>)

        >Network REG:
            < .*_REGISTRATION_STATE {1,
            < DATA_REGISTRATION_STATE.*([SUB0])
            GsmSST  : [GsmSST0] Poll ServiceState done:  oldSS=[0 0 voice home data home

        >Network switch:
            RIL     : [RILData_GSM_IRAT] setNetworkTransmitState: id = 0, name= ccmni0, state = 0.
            C2K_RIL : [RILData_C2K_IRAT] setNetworkTransmitState: id = 0, name= ccmni0, state = 1.

            REQUEST_SET_PREFERRED_NETWORK_TYPE 
            
            >Network score:
                DctController: [TNF 1]new score 60
                DctController: [TNF 1]  my score=50
            
            DCT     : [0]startAlarmForReconnect: delay=

        >Data:
            DcActivatingState|SETUP_DATA_CALL|RIL_REQUEST_ALLOW_DATA
            NETWORK_STATE_CHANGED_ACTION

            >state：
                TelephonyManager: setDataEnabled 
                notifyMobileDataChange, enable = 1      //change data state manually
                isDataAllowed: not allowed due to - Attached= false     //unattached
                Wait for attach
                onDataConnectionAttached    //Attached
                trySetupData

                DataSubSelector: calculateDefaultDataSim: insertedSimCount = 1 insertedStatus = 2
                
            >flow:
                updateDataActivity
                updateDataActivity: ((sent)|(newActivity))

            >WiFi:
                WifiService: setWifiEnabled:
            
        >APN:
            通过ctlte这个apn建立CID 0 默认承载，attach上lte
            AT+CGDCONT=0,"IPV4V6","ctlte",,0,0,0,0,0,0

            DCT : [2]createAllApnList: X mAllApnSettings=[[ApnSettingV3] CTLTE, 1491, 46011, ctlte, , , , , , 3, default | dun | supl, IPV4V6, IP, true, 0, 0, false, 0, 0, 0, 0, , , [ApnSettingV3] CTWAP, 1492, 46011, ctwap, , http://mmsc.vnet.mobi, 10.0.0.200, 80, , 3, mms, IP, IP, true, 0, 0, false, 0, 0, 0, 0, , , [ApnSettingV3] ctvpdn, 1493, 46011, ctvpdn, , , , , , 2, *, IP, IP, true, 0, 0, false, 0, 0, 0, 0, , ]

        >SIM Card:
            < UNSOL_SIM_PLUG_

        >AT CMD:
            AT ?< \+(CSQ|ECSQ|HDRCSQ)
            (ESIMS|EUSIM|EMDSTATUS)                                     //sim card
            AT [<>].*(CLCC|CEND|CONN|CDV|ORIG|CCWA|CHV|RING|CLIP)       //1x call
            AT[<>].*(CLCC|ECPI|ATD|CHLD|CEER)                           //GSM call
            AT [<>].*(CMGS|HCMGS|cmgf)                                  //CDMA SMS
            (AT < \+)(CREG|VSER)                                        //1x network REG&SERVICE state
            AT[<>].*(CREG|CEREG)                                        //3GPP Network REG state
            AT< \+ESIMS                                                 //SIM card

            AT ?[<>]
            >非C2K：
                AT[<>].*?(?<!OK)$
            >C2K:
                AT [<>].*?(?<!OK)$
                
    >sys_log:
        ityServic.. NetworkAgentInfo [WIFI () - 101] EVENT_NETWORK_INFO_CHANGED, going from CONNECTED to DISCONNECTED
        ConnectivityService: NetworkAgentInfo [WIFI () - 301] EVENT_NETWORK_INFO_CHANGED, going from CONNECTED to DISCONNECTED
        NETWORK_STATE_CHANGED_ACTION

    >main_log:
        >Network:
            preferred_network_mode
            SignalClusterView: setNetworkType

        >Data:
            getDataEnabled: getInt retVal=true 
            NETWORK_STATE_CHANGED_ACTION

        ActivityManager: Broadcast: Intent

        >Setting:
            Settings.Global.putInt(mContext.getContentResolver
            NetworkSettings:

        >Telecomm:
            Telecom : (?!.*TelecomServiceImpl)




MD1：非C2K
MD3：C2K
固件位置：system/etc/firmware/




SUB0:卡1（PS+CS）
SUB1:卡2（PS+CS）
SUB2/SUB10:专指LTE PS域（卡1）




RIL & Telephony
    ../alps/hardware/ril   
    ../alps/vendor/mediatek/proprietary/hardware

    ../alps/frameworks/base/telephony  
    ../alps/frameworks/opt/telephony
    ../alps/vendor/mediatek/proprietary/frameworks/base/telephony




init:
    ../alps/system/core/init/keywords.h
    ../alps/system/core/init/builtins.c

    添加脚本开机执行:
        <1>首先准备好要执行的脚本: 
            my_script.sh:
                #!/system/bin/sh
                #echo hello_world
        <2>将脚本存放到/system/etc下：
            1>先将脚本存放到某个目录下，如 ../alps/device/mediatek/mt6755/my_script.sh
            2>配置../alps/device/mediatek/mt6755/device.mk文件，在编译期拷贝到out下的../system/etc
                PRODUCT_COPY_FILES += $(LOCAL_PATH)/my_script.sh:system/etc/my_script.sh
        <3>在init.rc中加入该脚本，使其开机执行：
            # chown root shell /system/etc/my_script.sh
            # chmod 0550 /system/etc/my_script.sh
            service my_script /system/etc/my_script.sh
                class main
                user root
                group root
                oneshot
        <4>在../alps/system/core/include/private/android_filesystem_config.h文件中加入该脚本的可执行权限:
            { 00550, AID_ROOT,      AID_SHELL,     0, "system/etc/my_script.sh" },

1.Network Registration

    

2.Signal(Strength) & RF

    Signal quality +CSQ
    Extended signal quality +CESQ
    Received signal level indication +ECSQ（MTK）

    Get 2G/3G/4G RF temperature and 3G/4G Tx power +ETHERMAL（MTK）

    Set phone functionality +CFUN 
        +CFUN=4 flight mode

3.SIM card

    Restricted SIM access +CRSM
    Subscriber number +CNUM
    Set card slot +CSUS

    Change the dual SIM mode of Gemini modem +EFUN（MTK） *
        AT+EFUN=1   //SIM1 only
        AT+EFUN=2   //SIM2 only
        AT+EFUN=3   //Dual SIM

    Set active SIM which should do PS attach +EACTS（MTK）

    Set CT LTE mode +ECTMODE
        0 SVLTE
        1 TDD data only
        2 4G switch-off

    Indicate the SIM is inserted or not and related cause +ESIMS（MTK）   *
    Indicate the inserted SIM card is SIM or USIM +EUSIM（MTK）   *
    AP to notify MD1 that MD3 is active or not and how to access SIM card +EMDSTATUS（MTK）   *
    Set functionaliy for multiple SIM project +CFUN（MTK）    CFUN=4(flight mode)

4.PS

    Define PDP context +CGDCONT
    Define secondary PDP context +CGDSCONT
    PS attach or detach +CGATT
    PDP context activate or deactivate +CGACT
    PDP context modify +CGCMOD
    Enter data state +CGDATA
    Show PDP address(es) +CGPADDR
    GPRS mobile station class +CGCLASS
    Packet domain event reporting +CGEREP/+CGEV
    GPRS network registration status +CGREG
    EPS network registration status +CEREG
    PDP context read dynamic parameters +CGCONTRDP
    Secondary PDP context read dynamic parameters +CGSCONTRDP

5.CS

    List current calls +CLCC

    Call progress information +ECPI（MTK）

    Voice call +CDV（CDMA 1x）
    Call originated indication ^ORIG（CDMA 1x）
    Call Connected indication ^CONN（CDMA 1x）
    Hang up voice call +CHV（CDMA 1x）
    Call ended indication ^CEND（CDMA 1x）

6.SMS

7.Phone Book
    
    Read phonebook entries +CPBR

8.SS

    Execute SS/USSD operation +ECUSD（MTK）
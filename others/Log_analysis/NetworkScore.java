"D ConnectivityService: updateNetworkScore for NetworkAgentInfo [WIFI () - 301] to 60"
   \
    >"../alps/frameworks/base/services/core/java/com/android/server/ConnectivityService.java"
    private void updateNetworkScore(NetworkAgentInfo nai, int score) {
        if (DBG) log("updateNetworkScore for " + nai.name() + " to " + score);
        if (score < 0) {
            loge("updateNetworkScore for " + nai.name() + " got a negative score (" + score +
                    ").  Bumping score to min of 0");
            score = 0;
        }

        final int oldScore = nai.getCurrentScore();
        nai.setCurrentScore(score);

        rematchAllNetworksAndRequests(nai, oldScore);

        sendUpdatedScoreToFactories(nai);
    }   \
         \
          \
           \
        private void sendUpdatedScoreToFactories(NetworkAgentInfo nai) {
            for (int i = 0; i < nai.networkRequests.size(); i++) {
                NetworkRequest nr = nai.networkRequests.valueAt(i);
                // Don't send listening requests to factories. b/17393458
                if (!isRequest(nr)) continue;
                sendUpdatedScoreToFactories(nr, nai.getCurrentScore());
            }                   \
        }                        \
                                  \
        private void sendUpdatedScoreToFactories(NetworkRequest networkRequest, int score) {
            if (VDBG) log("sending new Min Network Score(" + score + "): " + networkRequest.toString());
            for (NetworkFactoryInfo nfi : mNetworkFactoryInfos.values()) {
                nfi.asyncChannel.sendMessage(android.net.NetworkFactory.CMD_REQUEST_NETWORK, score, 0,
                    networkRequest);    \
            }                            \
        }                                 \
                                           \
                                "../alps/frameworks/base/core/java/com/android/internal/util/AsyncChannel.java"
                                public void sendMessage(int what, int arg1, int arg2, Object obj) {
                                    Message msg = Message.obtain();
                                    msg.what = what;
                                    msg.arg1 = arg1;
                                    msg.arg2 = arg2;
                                    msg.obj = obj;
                                    sendMessage(msg);
                                }           \
                                             \
                                              \
                                               \
                                                /**
                                                 * Send a message to the destination handler.
                                                 *
                                                 * @param msg
                                                 */
                                                public void sendMessage(Message msg) {
                                                    msg.replyTo = mSrcMessenger;
                                                    try {
                                                        mDstMessenger.send(msg);
                                                    } catch (RemoteException e) {
                                                        replyDisconnected(STATUS_SEND_UNSUCCESSFUL);
                                                    }
                                                }
|
|                                                
"D DctController: [TNF 1]new score 60 for exisiting request NetworkRequest [ id=1, legacyType=-1, [ Capabilities: INTERNET&NOT_RESTRICTED&TRUSTED&NOT_VPN] ]"
"D DctController: [TNF 1]  my score=50, my filter=[ Transports: CELLULAR Capabilities: MMS&SUPL&DUN&FOTA&IMS&CBS&IA&RCS&XCAP&EIMS&INTERNET&NOT_RESTRICTED&TRUSTED&NOT_VPN&DM&WAP&NET&CMMAIL&TETHERING&RCSE Specifier: <1>]"
"D DctController: [TNF 1]evalRequest request = NetworkRequest [ id=1, legacyType=-1, [ Capabilities: INTERNET&NOT_RESTRICTED&TRUSTED&NOT_VPN] ] with requested = true(60) my score:50"
"D DctController: [TNF 1]  releaseNetworkFor"
   \
    >"../alps/frameworks/base/core/java/android/net/NetworkFactory.java"
    @Override
    public void handleMessage(Message msg) {
        switch (msg.what) {
            case CMD_REQUEST_NETWORK: {
                handleAddRequest((NetworkRequest)msg.obj, msg.arg1);
                break;      \
            }                \
                              \
                               \
            private void handleAddRequest(NetworkRequest request, int score) {
                NetworkRequestInfo n = mNetworkRequests.get(request.requestId);
                if (n == null) {
                    if (DBG) log("got request " + request + " with score " + score);
                    n = new NetworkRequestInfo(request, score);
                    mNetworkRequests.put(n.request.requestId, n);
                } else {
                    if (VDBG) log("new score " + score + " for exisiting request " + request);
                    n.score = score;
                }
                if (VDBG) log("  my score=" + mScore + ", my filter=" + mCapabilityFilter);

                evalRequest(n);
            }           \
                         \
                          \
                           \
        private void evalRequest(NetworkRequestInfo n) {
            if (VDBG) log("evalRequest request = " + n.request + " with requested = " + n.requested
                             + "(" + n.score + ") my score:" + mScore);
            // M: change design from [n.score < mScore] to [n.score <= mScore]
            if (n.requested == false && n.score <= mScore &&
                    n.request.networkCapabilities.satisfiedByNetworkCapabilities(
                    mCapabilityFilter) && acceptRequest(n.request, n.score)) {
                if (VDBG) log("  needNetworkFor");
                needNetworkFor(n.request, n.score);
                n.requested = true;
            } else if (n.requested == true &&
                    (n.score > mScore || n.request.networkCapabilities.satisfiedByNetworkCapabilities(
                    mCapabilityFilter) == false || acceptRequest(n.request, n.score) == false)) {
                if (VDBG) log("  releaseNetworkFor");
                releaseNetworkFor(n.request);
                n.requested = false;        \
            } else {                         \
                if (VDBG) log("  done");      \
            }                                  \
        }                                       \
                                                |
                                                |
"D DctController: [TNF 1]Cellular releasing Network for NetworkRequest [ id=1, legacyType=-1, [ Capabilities: INTERNET&NOT_RESTRICTED&TRUSTED&NOT_VPN] ]"
"D DctController: [DctController] [IRAT_DctController] releaseNetworkFor: IRAT change phone ID:0"
   \
    >"../alps/frameworks/opt/telephony/src/java/com/android/internal/telephony/dataconnection/DctController.java"
    "private class TelephonyNetworkFactory extends NetworkFactory"
    @Override
    protected void releaseNetworkFor(NetworkRequest networkRequest) {
        log("Cellular releasing Network for " + networkRequest);

        //M: Fix google Issue
        //if (!SubscriptionManager.isUsableSubIdValue(mPhone.getSubId())) {
        if (mPendingReq.get(networkRequest.requestId) != null ) {
            log("Sub Info has not been ready, remove request.");
            mPendingReq.remove(networkRequest.requestId);
            return;
        }

        // M: [C2K][IRAT] Mapping phone ID for SVLTE during release
        int phoneId = mPhone.getPhoneId();
        if (CdmaFeatureOptionUtils.isCdmaLteDcSupport()) {
            phoneId = SvlteUtils.getSlotId(phoneId);
            logd("[IRAT_DctController] releaseNetworkFor: IRAT change phone ID:" + phoneId);
        }

        if (getRequestPhoneId(networkRequest) == phoneId) {
            DcTrackerBase dcTracker = ((PhoneBase) mPhone).mDcTracker;
            String apn = apnForNetworkRequest(networkRequest);
            if (dcTracker.isApnSupported(apn)) {
                releaseNetwork(networkRequest);
            } else {                        \
                log("Unsupported APN");      \
            }                                 \
                                               \
        } else {                                \
            log("Request not release");          \
        }                                         \
    }                                              \
                                                   |
                                                   |
"D DctController: [DctController] releaseNetwork request=NetworkRequest [ id=1, legacyType=-1, [ Capabilities: INTERNET&NOT_RESTRICTED&TRUSTED&NOT_VPN] ], requestInfo=[ request=NetworkRequest [ id=1, legacyType=-1, [ Capabilities: INTERNET&NOT_RESTRICTED&TRUSTED&NOT_VPN] ], executed=true, priority=0, gid=0, phoneId=0, factoryId=0]"
"D DctController: [DctController] releaseRequest, request= [ request=NetworkRequest [ id=1, legacyType=-1, [ Capabilities: INTERNET&NOT_RESTRICTED&TRUSTED&NOT_VPN] ], executed=true, priority=0, gid=0, phoneId=0, factoryId=0]"
"D DctController: [DctController] processRequests"
   \
    >"../alps/frameworks/opt/telephony/src/java/com/android/internal/telephony/dataconnection/DctController.java"
    private int releaseNetwork(NetworkRequest request) {
        RequestInfo requestInfo = mRequestInfos.get(request.requestId);
        logd("releaseNetwork request=" + request + ", requestInfo=" + requestInfo);

        mRequestInfos.remove(request.requestId);

        String specifier = request.networkCapabilities.getNetworkSpecifier();
        boolean bToAttachingState = false;
        int phoneId = -1;
        if (specifier != null && !specifier.equals("")) {
            int subId =  Integer.parseInt(specifier);
            if (subId < SubscriptionManager.INVALID_SUBSCRIPTION_ID &&
                request.networkCapabilities.
                hasCapability(NetworkCapabilities.NET_CAPABILITY_EIMS)) {
                bToAttachingState = true;
                phoneId = mSubController.getPhoneId(subId);
            }
        }

        releaseRequest(requestInfo);-------------------------------------------------------------------\
        processRequests();------------------------------------------------------------------------------\
                                                                                                         \
        if (bToAttachingState) {                                                                          \
            logd("ECC w/o SIM, disconnectAllSync to transit to attaching state: " + bToAttachingState      \
                 + ", Set phoneId: " + phoneId + " to attaching state");                                    \
            mDcSwitchAsyncChannel[phoneId].disconnectAllSync();                                              \
        }                                                                                                     \
                                                                                                               \
        return PhoneConstants.APN_REQUEST_STARTED;                                                              \
    }                                                                                                            \
                                                                                                    void releaseRequest(RequestInfo request) {
                                                                                                        logd("releaseRequest, request= " + request);
                                                                                                        sendMessage(obtainMessage(EVENT_RELEASE_REQUEST, request));
                                                                                                    }

                                                                                                    void processRequests() {
                                                                                                        logd("processRequests");
                                                                                                        // remove redundant messages firstly, this situation happens offen.
                                                                                                        removeMessages(EVENT_PROCESS_REQUESTS);
                                                                                                        sendMessage(obtainMessage(EVENT_PROCESS_REQUESTS));
                                                                                                    }
|
|
"D DctController: [DctController] handleMessage msg={ when=0 what=103 obj=[ request=NetworkRequest [ id=1, legacyType=-1, [ Capabilities: INTERNET&NOT_RESTRICTED&TRUSTED&NOT_VPN] ], executed=true, priority=0, gid=0, phoneId=0, factoryId=0] target=com.android.internal.telephony.dataconnection.DctController obj=[ request=NetworkRequest [ id=1, legacyType=-1, [ Capabilities: INTERNET&NOT_RESTRICTED&TRUSTED&NOT_VPN] ], executed=true, priority=0, gid=0, phoneId=0, factoryId=0] }"
"D DctController: [DctController] onReleaseRequest request=[ request=NetworkRequest [ id=1, legacyType=-1, [ Capabilities: INTERNET&NOT_RESTRICTED&TRUSTED&NOT_VPN] ], executed=true, priority=0, gid=0, phoneId=0, factoryId=0]"
   \
    >"../alps/frameworks/opt/telephony/src/java/com/android/internal/telephony/dataconnection/DctController.java"
    @Override
    public void handleMessage(Message msg) {
        logd("handleMessage msg=" + msg);
        switch (msg.what) {
            //......
            case EVENT_RELEASE_REQUEST:
                onReleaseRequest((RequestInfo) msg.obj);
                break;      \
                             \
                              \
                               \
            private void onReleaseRequest(RequestInfo requestInfo) {
                logd("onReleaseRequest request=" + requestInfo);
                if (requestInfo != null && requestInfo.executed) {
                    String apn = apnForNetworkRequest(requestInfo.request);
                    //int phoneId = getRequestPhoneId(requestInfo.request);
                    int phoneId = requestInfo.phoneId;
                    PhoneBase phoneBase = getActivePhone(phoneId);
                    DcTrackerBase dcTracker = phoneBase.mDcTracker;
                    dcTracker.decApnRefCount(apn);
                    requestInfo.executed = false; \
                }                                  \
            }                                       \
                                                    |
                                                    |
"D DCT     : [0]decApnRefCount name = default"
"D DCT     : [0]decApnRefCount apnContext = {mApnType=default mState=CONNECTED mWaitingApns={[[ApnSettingV3] 中国电信互联网设置CTNET, 1153, 46011, ctnet, , , , , , 3, default | dun | supl, IPV4V6, IP, true, 0, 0, false, 0, 0, 0, 0, , ]} mWaitingApnsPermanentFailureCountDown=1 mApnSetting={[ApnSettingV3] 中国电信互联网设置CTNET, 1153, 46011, ctnet, , , , , , 3, default | dun | supl, IPV4V6, IP, true, 0, 0, false, 0, 0, 0, 0, , } mReason=connected mDataEnabled=true mDependencyMet=true}"
"D DCT     : [0]setEnabled(0, false) with old state = true and enabledCount = 1"
   \
    >"../alps/frameworks/opt/telephony/src/java/com/android/internal/telephony/dataconnection/DcTracker.java"
    @Override
    public void decApnRefCount(String name) {
        ApnContext apnContext = mApnContexts.get(name);
        log("decApnRefCount name = " + name);
        if (apnContext != null) {
            log("decApnRefCount apnContext = " + apnContext);
            apnContext.decRefCount();
        }                       \
    }                            \
                >"../alps/frameworks/opt/telephony/src/java/com/android/internal/telephony/dataconnection/ApnContext.java"                                                                                                          \
                public void decRefCount() {
                    synchronized (mRefCountLock) {
                        if (mRefCount-- == 1) {
                            mDcTracker.setEnabled(mDcTracker.apnTypeToId(mApnType), false);
                        }                   \
                    }                        \
                }                             \
                            >"../alps/frameworks/opt/telephony/src/java/com/android/internal/telephony/dataconnection/DcTrackerBase.java"
                            protected void setEnabled(int id, boolean enable) {
                                if (DBG) {
                                    log("setEnabled(" + id + ", " + enable + ") with old state = " + mDataEnabled[id]
                                            + " and enabledCount = " + mEnabledCount);
                                }
                                Message msg = obtainMessage(DctConstants.EVENT_ENABLE_NEW_APN);
                                msg.arg1 = id;
                                msg.arg2 = (enable ? DctConstants.ENABLED : DctConstants.DISABLED);
                                sendMessage(msg);
                            }
|
|
"D DCT     : [0]handleMessage msg={ when=-1ms what=270349 target=com.android.internal.telephony.dataconnection.DcTracker }"
"D DCT     : [0]onEnableApn: apnContext={mApnType=default mState=CONNECTED mWaitingApns={[[ApnSettingV3] 中国电信互联网设置CTNET, 1153, 46011, ctnet, , , , , , 3, default | dun | supl, IPV4V6, IP, true, 0, 0, false, 0, 0, 0, 0, , ]} mWaitingApnsPermanentFailureCountDown=1 mApnSetting={[ApnSettingV3] 中国电信互联网设置CTNET, 1153, 46011, ctnet, , , , , , 3, default | dun | supl, IPV4V6, IP, true, 0, 0, false, 0, 0, 0, 0, , } mReason=connected mDataEnabled=true mDependencyMet=true} call applyNewState"
"D DCT     : [0]applyNewState(default, false(true), true(true))"
"D DCT     : [0]cleanUpConnection: E tearDown=true reason=dataDisabled apnContext={mApnType=default mState=CONNECTED mWaitingApns={[[ApnSettingV3] 中国电信互联网设置CTNET, 1153, 46011, ctnet, , , , , , 3, default | dun | supl, IPV4V6, IP, true, 0, 0, false, 0, 0, 0, 0, , ]} mWaitingApnsPermanentFailureCountDown=1 mApnSetting={[ApnSettingV3] 中国电信互联网设置CTNET, 1153, 46011, ctnet, , , , , , 3, default | dun | supl, IPV4V6, IP, true, 0, 0, false, 0, 0, 0, 0, , } mReason=dataDisabled mDataEnabled=false mDependencyMet=true}"
"D DCT     : [0]cleanUpConnection: tearing downapnContext={mApnType=default mState=CONNECTED mWaitingApns={[[ApnSettingV3] 中国电信互联网设置CTNET, 1153, 46011, ctnet, , , , , , 3, default | dun | supl, IPV4V6, IP, true, 0, 0, false, 0, 0, 0, 0, , ]} mWaitingApnsPermanentFailureCountDown=1 mApnSetting={[ApnSettingV3] 中国电信互联网设置CTNET, 1153, 46011, ctnet, , , , , , 3, default | dun | supl, IPV4V6, IP, true, 0, 0, false, 0, 0, 0, 0, , } mReason=dataDisabled mDataEnabled=false mDependencyMet=true}"
"D DCT     : [0]cleanUpConnection: X tearDown=true reason=dataDisabled apnContext={mApnType=default mState=DISCONNECTING mWaitingApns={[[ApnSettingV3] 中国电信互联网设置CTNET, 1153, 46011, ctnet, , , , , , 3, default | dun | supl, IPV4V6, IP, true, 0, 0, false, 0, 0, 0, 0, , ]} mWaitingApnsPermanentFailureCountDown=1 mApnSetting={[ApnSettingV3] 中国电信互联网设置CTNET, 1153, 46011, ctnet, , , , , , 3, default | dun | supl, IPV4V6, IP, true, 0, 0, false, 0, 0, 0, 0, , } mReason=dataDisabled mDataEnabled=false mDependencyMet=true} dcac=DC-2"
    \
    >"../alps/frameworks/opt/telephony/src/java/com/android/internal/telephony/dataconnection/DcTracker.java"
    @Override
    public void handleMessage (Message msg) {
        if (DBG) log("handleMessage msg=" + msg);
        //......
                    default:
                // handle the message in the super class DataConnectionTracker
                super.handleMessage(msg);
                break;          \
        }                        \
    }                             \
                >"../alps/frameworks/opt/telephony/src/java/com/android/internal/telephony/dataconnection/DcTrackerBase.java"
                @Override
                public void handleMessage(Message msg) {
                    switch (msg.what) {
                        //......
                        case DctConstants.EVENT_ENABLE_NEW_APN:
                            onEnableApn(msg.arg1, msg.arg2);
                            break;  \
                                     \
                                      \
                                >"../alps/frameworks/opt/telephony/src/java/com/android/internal/telephony/dataconnection/DcTracker.java"                                      
                                @Override
                                protected void onEnableApn(int apnId, int enabled) {
                                    ApnContext apnContext = mApnContexts.get(apnIdToType(apnId));
                                    if (apnContext == null) {
                                        loge("onEnableApn(" + apnId + ", " + enabled + "): NO ApnContext");
                                        return;
                                    }
                                    // TODO change our retry manager to use the appropriate numbers for the new APN
                                    if (DBG) log("onEnableApn: apnContext=" + apnContext + " call applyNewState");
                                    applyNewState(apnContext, enabled == DctConstants.ENABLED, apnContext.getDependencyMet());
                                }                   \
                                                     \
                                                      \
                                                private void applyNewState(ApnContext apnContext, boolean enabled, boolean met) {
                                                    boolean cleanup = false;
                                                    boolean trySetup = false;
                                                    if (DBG) {
                                                        log("applyNewState(" + apnContext.getApnType() + ", " + enabled +
                                                                "(" + apnContext.isEnabled() + "), " + met + "(" +
                                                                apnContext.getDependencyMet() +"))");
                                                    }
                                                    //......

                                                    if (cleanup) cleanUpConnection(true, apnContext);
                                                    if (trySetup) trySetupData(apnContext);     \
                                                }                                                \      
                                                                                                  \
                                                                    protected void cleanUpConnection(boolean tearDown, ApnContext apnContext) {

                                                                        if (apnContext == null) {
                                                                            if (DBG) log("cleanUpConnection: apn context is null");
                                                                            return;
                                                                        }

                                                                        DcAsyncChannel dcac = apnContext.getDcAc();
                                                                        if (DBG) {
                                                                            log("cleanUpConnection: E tearDown=" + tearDown + " reason=" + apnContext.getReason() +
                                                                                    " apnContext=" + apnContext);
                                                                        }
                                                                        if (tearDown) {
                                                                            if (apnContext.isDisconnected()) {
                                                                            //......
                                                                            } else {
                                                                                // Connection is still there. Try to clean up.
                                                                                if (dcac != null) {
                                                                                    if (apnContext.getState() != DctConstants.State.DISCONNECTING) {
                                                                                        boolean disconnectAll = false;
                                                                                        if (PhoneConstants.APN_TYPE_DUN.equals(apnContext.getApnType())) {
                                                                                            // CAF_MSIM is this below condition required.
                                                                                            // if (PhoneConstants.APN_TYPE_DUN.equals(PhoneConstants.APN_TYPE_DEFAULT)) {
                                                                                            if (teardownForDun()) {
                                                                                                if (DBG) {
                                                                                                    log("cleanUpConnection: disconnectAll DUN connection");
                                                                                                }
                                                                                                // we need to tear it down - we brought it up just for dun and
                                                                                                // other people are camped on it and now dun is done.  We need
                                                                                                // to stop using it and let the normal apn list get used to find
                                                                                                // connections for the remaining desired connections
                                                                                                disconnectAll = true;
                                                                                            }
                                                                                        }
                                                                                        if (DBG) {
                                                                                            log("cleanUpConnection: tearing down" + (disconnectAll ? " all" :"")
                                                                                                    + "apnContext=" + apnContext);
                                                                                        }
                                                                                        Message msg = obtainMessage(DctConstants.EVENT_DISCONNECT_DONE, apnContext);
                                                                                        if (disconnectAll) {
                                                                                            dcac.tearDownAll(apnContext.getReason(), msg);
                                                                                        } else {
                                                                                            dcac.tearDown(apnContext, apnContext.getReason(), msg);----------\
                                                                                        }                                                                     \
                                                                                        apnContext.setState(DctConstants.State.DISCONNECTING);                 \
                                                                                        mDisconnectPendingCount++;                                              \
                                                                                    }                                                                            \
                                                                        //......                                                                                  \
                                                                                                                                                                   \
                                                                        // Make sure reconnection alarm is cleaned up if there is no ApnContext                     \
                                                                        // associated to the connection.                                                             \
                                                                        if (dcac != null) {                                                                           \
                                                                            cancelReconnectAlarm(apnContext);                                                          \
                                                                        }                                                                                               \
                                                                        if (DBG) {                                                                                       \
                                                                            log("cleanUpConnection: X tearDown=" + tearDown + " reason=" + apnContext.getReason() +       \
                                                                                    " apnContext=" + apnContext + " dcac=" + apnContext.getDcAc());                        \
                                                                        }                                                                                                   \
                                                                    }                                                                                                        \
                                                                                                                                    >"../alps/frameworks/opt/telephony/src/java/com/android/internal/telephony/dataconnection/DcAsyncChannel.java"
                                                                                                                                    /**                       
                                                                                                                                     * Tear down the connection through the apn on the network.
                                                                                                                                     *
                                                                                                                                     * @param onCompletedMsg is sent with its msg.obj as an AsyncResult object.
                                                                                                                                     *        With AsyncResult.userObj set to the original msg.obj.
                                                                                                                                     */
                                                                                                                                    public void tearDown(ApnContext apnContext, String reason, Message onCompletedMsg) {
                                                                                                                                        if (DBG) {-------------------------------------------------------------------------->    private static final boolean DBG = false;
                                                                                                                                            log("tearDown: apnContext=" + apnContext
                                                                                                                                                    + " reason=" + reason + " onCompletedMsg=" + onCompletedMsg);
                                                                                                                                        }
                                                                                                                                        sendMessage(DataConnection.EVENT_DISCONNECT,
                                                                                                                                              \          new DisconnectParams(apnContext, reason, onCompletedMsg));
                                                                                                                                    }          \
                                                                                                                                                \
                                                                                                                                                |
                                                                                                                                                |
"D DC-2    : DcActiveState: EVENT_DISCONNECT dp={mTag=0 mApnContext={mApnType=default mState=DISCONNECTING mWaitingApns={[[ApnSettingV3] 中国电信互联网设置CTNET, 1153, 46011, ctnet, , , , , , 3, default | dun | supl, IPV4V6, IP, true, 0, 0, false, 0, 0, 0, 0, , ]} mWaitingApnsPermanentFailureCountDown=1 mApnSetting={[ApnSettingV3] 中国电信互联网设置CTNET, 1153, 46011, ctnet, , , , , , 3, default | dun | supl, IPV4V6, IP, true, 0, 0, false, 0, 0, 0, 0, , } mReason=dataDisabled mDataEnabled=false mDependencyMet=true} mReason=dataDisabled mOnCompletedMsg={what=0x4200f when=-5d21h32m8s602ms obj={mApnType=default mState=DISCONNECTING mWaitingApns={[[ApnSettingV3] 中国电信互联网设置CTNET, 1153, 46011, ctnet, , , , , , 3, default | dun | supl, IPV4V6, IP, true, 0, 0, false, 0, 0, 0, 0, , ]} mWaitingApnsPermanentFailureCountDown=1 mApnSetting={[ApnSettingV3] 中国电信互联网设置CTNET, 1153, 46011, ctnet, , , , , , 3, default | dun | supl, IPV4V6, IP, true, 0, 0, false, 0, 0, 0, 0, , } mReason=dataDisabled mDataEnabled=false mDependencyMet=true} target=Handler (com.android.internal.telephony.dataconnection.DcTracker) {1e5947bb} replyTo=null}} dc={DC-2: State=DcActiveState mApnSetting=[ApnSettingV3] 中国电信互联网设置CTNET, 1153, 46011, ctnet, , , , , , 3, default | dun | supl, IPV4V6, IP, true, 0, 0, false, 0, 0, 0, 0, ,  RefCount=1 mCid=1 mCreateTime=-1 mLastastFailTime=-1 mLastFailCause=NONE mTag=134 mRetryManager=RetryManager: { forever=false maxRetry=10 curMaxRetry=10 retry=0 config={default_randomization=2000,5000,10000,20000,40000,80000:5000,160000:5000,320000:5000,640000:5000,1280000:5000,1800000:5000} retryArray={5000:2000 10000:2000 20000:2000 40000:2000 80000:5000 160000:5000 320000:5000 640000:5000 1280000:5000 1800000:5000 }} mDcFailCauseManager=DcFailCauseManager: { operator=NONE maxRetry=0 retryTime=0 randomizationTime0 retryCount0} mLinkProperties={InterfaceName: ccmni1 LinkAddresses: [100.113.98.25/32,]  Routes: [0.0.0.0/0 -> 100.113.98.25 ccmni1,] DnsAddresses: [202.96.128.86,] Domains: null MTU: 1420 TcpBufferSizes: 131072,262144,1048576,4096,16384,524288 PcscfAddresses: [] } linkCapabilities=[ Transports: CELLULAR Capabilities: SUPL&DUN&INTERNET&NOT_RESTRICTED&TRUSTED&NOT_VPN LinkUpBandwidth>=153Kbps LinkDnBandwidth>=2516Kbps Specifier: <1>] mApnContexts=[{mApnType=default mState=DISCONNECTING mWaitingApns={[[ApnSettingV3] 中国电信互联网设置CTNET, 1153, 46011, ctnet, , , , , , 3, default | dun | supl, IPV4V6, IP, true, 0, 0, false, 0, 0, 0, 0, , ]} mWaitingApnsPermanentFailureCountDown=1 mApnSetting={[ApnSettingV3] 中国电信互联网设置CTNET, 1153, 46011, ctnet, , , , , , 3, default | dun | supl, IPV4V6, IP, true, 0, 0, false, 0, 0, 0, 0, , } mReason=dataDisabled mDataEnabled=false mDependencyMet=true}]}"
"D DC-2    : DcActiveState msg.what=EVENT_DISCONNECT RefCount=1"
"D DC-2    : tearDownData radio is on, call deactivateDataCall"
   \
    >"../alps/frameworks/opt/telephony/src/java/com/android/internal/telephony/dataconnection/DataConnection.java"
    @Override
    public boolean processMessage(Message msg) {
        boolean retVal;

        switch (msg.what) {
            //......
            case EVENT_DISCONNECT: {
                DisconnectParams dp = (DisconnectParams) msg.obj;
                if (DBG) {
                    log("DcActiveState: EVENT_DISCONNECT dp=" + dp
                            + " dc=" + DataConnection.this);
                }
                if (mApnContexts.contains(dp.mApnContext)) {
                    if (DBG) {
                        log("DcActiveState msg.what=EVENT_DISCONNECT RefCount="
                                + mApnContexts.size());
                    }

                    if (mApnContexts.size() == 1) {
                        mApnContexts.clear();
                        mDisconnectParams = dp;
                        mConnectionParams = null;
                        dp.mTag = mTag;
                        tearDownData(dp);------------------\
                        transitionTo(mDisconnectingState);  \
                                                             \
                                    /**                                   
                                     * TearDown the data connection when the deactivation is complete a Message with
                                     * msg.what == EVENT_DEACTIVATE_DONE and msg.obj == AsyncResult with AsyncResult.obj
                                     * containing the parameter o.
                                     *
                                     * @param o is the object returned in the AsyncResult.obj.
                                     */
                                    private void tearDownData(Object o) {
                                        int discReason = RILConstants.DEACTIVATE_REASON_NONE;
                                        if ((o != null) && (o instanceof DisconnectParams)) {
                                            DisconnectParams dp = (DisconnectParams) o;

                                            if (TextUtils.equals(dp.mReason, Phone.REASON_RADIO_TURNED_OFF)) {
                                                discReason = RILConstants.DEACTIVATE_REASON_RADIO_OFF;
                                            } else if (TextUtils.equals(dp.mReason, Phone.REASON_PDP_RESET)) {
                                                discReason = RILConstants.DEACTIVATE_REASON_PDP_RESET;
                                            }
                                        }
                                        if (mPhone.mCi.getRadioState().isOn()) {
                                            if (DBG) log("tearDownData radio is on, call deactivateDataCall");
                                            /// M: [C2K][IRAT] Use RilArbitrator to deactivate data.
                                            deactivateDataCall(mCid, discReason,
                                                    obtainMessage(EVENT_DEACTIVATE_DONE, mTag, 0, o));-----------------------------\
                                        } else {                                                                                    \
                                            if (DBG) log("tearDownData radio is off sendMessage EVENT_DEACTIVATE_DONE immediately"); \
                                            AsyncResult ar = new AsyncResult(o, null, null);                                          \
                                            sendMessage(obtainMessage(EVENT_DEACTIVATE_DONE, mTag, 0, ar));                            \
                                        }                                                                                               \
                                    }                                                                                                    \
                                                                                                            private void deactivateDataCall(int cid, int reason, Message result) {
                                                                                                                if (!CdmaFeatureOptionUtils.isCdmaLteDcSupport() || !SvlteUtils.isActiveSvlteMode(mPhone)) {
                                                                                                                    mPhone.mCi.deactivateDataCall(cid, reason, result);
                                                                                                                } else {
                                                                                                                    getRilDcArbitrator().deactivateDataCall(cid, reason, result);
                                                                                                                }           \                             \
                                                                                                            }                \                             \
                                                                                                                              \                             \
                                                                                    private IRilDcArbitrator getRilDcArbitrator() {                          \
                                                                                        return ((SvltePhoneProxy) PhoneFactory.getPhone(SvlteModeController   \  
                                                                                                .getActiveSvlteModeSlotId())).getRilDcArbitrator();            \
                                                                                                }                                                               \                                                 
                                                                                                                                                                 \
"D PhoneFactory: getPhone:- phoneId != DEFAULT_PHONE_ID return sProxyPhones[phoneId] phoneId=0 phone=Handler (com.mediatek.internal.telephony.ltedc.svlte.SvltePhoneProxy) {93da7fb}"
"I PHONE   : [IRAT_SvlteRilArbitrator] deactivateDataCall: mSuspendDataRequest = false,mPsCi = com.android.internal.telephony.RIL@4aa1cdf, cid = 1"
"D RILJ    : [0230]> DEACTIVATE_DATA_CALL 1 0 [SUB0]"



            case EVENT_PROCESS_REQUESTS:
                onProcessRequest();
                break;      \
                             \


"D DCT     : [0]phoneSubId = 1"
"D DCT     : [0]getDataEnabled: getInt retVal=true"
"D DC-2    : makeNetworkCapabilities: check data enable:true"
"D DCT     : [0]fetchDunApn: config_tether_apndata dunSetting=null"
    private NetworkCapabilities makeNetworkCapabilities() {
        NetworkCapabilities result = new NetworkCapabilities();
        result.addTransportType(NetworkCapabilities.TRANSPORT_CELLULAR);

        // M: check if data enabled
        boolean isDataEnable = mDct.getDataEnabled();
        log("makeNetworkCapabilities: check data enable:" + isDataEnable);

        // M: [C2K][IRAT] Change LTE_DC_SUB_ID to IRAT support slot sub ID for IRAT.
        int subId = mPhone.getSubId();
        if (CdmaFeatureOptionUtils.isCdmaLteDcSupport()) {
            subId = SvlteUtils.getSvlteSubIdBySubId(subId);
        }

        int phoneId = mSubController.getPhoneId(mSubController.getDefaultDataSubId());

        if (mApnSetting != null) {
            for (String type : mApnSetting.types) {
                switch (type) {
                    //......
                    case PhoneConstants.APN_TYPE_DUN: {
                        ApnSetting securedDunApn = mDct.fetchDunApn();
                        if (securedDunApn == null || securedDunApn.equals(mApnSetting)) {
                            result.addCapability(NetworkCapabilities.NET_CAPABILITY_DUN);
                        }
                        break;
                    }

"C2K_RIL : <fd 15> AT < RING"
\
 \
  \
   \
    "ril/c2k/c2k-ril/ril_cc.c":
    else if (strStartsWith(s, "+CRING:") || strStartsWith(s, "RING")) {
            if (!oemSupportEnable(g_oem_support_flag)
                    || oemVcallInSupportEnable(g_oem_support_flag)) {
                RIL_onUnsolicitedResponse(RIL_UNSOL_RESPONSE_CALL_STATE_CHANGED,
                        NULL, 0);
                //at_send_command("AT+SPEAKER=4", NULL);    //xfge
            }
|
|
"RILJ    : [UNSL]< UNSOL_RESPONSE_CALL_STATE_CHANGED [SUB0]"
\
 \
  \
   \
    "CdmaCallTracker.java":
    case EVENT_CALL_STATE_CHANGE:
         pollCallsWhenSafe();
         \
          \
           \
            \
            "CallTracker.java":
            protected void pollCallsWhenSafe() {
                mNeedsPoll = true;

                if (checkNoOperationsPending()) {
                    mLastRelevantPoll = obtainMessage(EVENT_POLL_CALLS_RESULT);
                    mCi.getCurrentCalls(mLastRelevantPoll);
                }
            }
            \
             \
              \
               \
                "RIL.java":   
                getCurrentCalls (Message result) {
                    RILRequest rr = RILRequest.obtain(RIL_REQUEST_GET_CURRENT_CALLS, result);

                    if (RILJ_LOGD) riljLog(rr.serialString() + "> " + requestToString(rr.mRequest));

                    send(rr);
                }
|
|
"RILJ    : [3671]> GET_CURRENT_CALLS [SUB0]"
|
|
"CLCC"
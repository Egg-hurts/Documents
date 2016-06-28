It's possible to write code that wins every performance test in the world, but still feels sluggish, hang or freeze for significant periods, or take too long to process input. The worst thing that can happen to your app's responsiveness is an "Application Not Responding" (ANR) dialog.

In Android, the system guards against applications that are insufficiently responsive for a period of time by displaying a dialog that says your app has stopped responding, such as the dialog in Figure 1. At this point, your app has been unresponsive for a considerable period of time so the system offers the user an option to quit the app. It's critical to design responsiveness into your application so the system never displays an ANR dialog to the user.

This document describes how the Android system determines whether an application is not responding and provides guidelines for ensuring that your application stays responsive.

###What Triggers ANR?

Generally, the system displays an ANR if an application cannot respond to user input. For example, if an application blocks on some I/O operation (frequently a network access) on the UI thread so the system can't process incoming user input events. Or perhaps the app spends too much time building an elaborate in-memory structure or computing the next move in a game on the UI thread. It's always important to make sure these computations are efficient, but even the most efficient code still takes time to run.

In any situation in which your app performs a potentially lengthy operation, **you should not perform the work on the UI thread**, but instead create a worker thread and do most of the work there. This keeps the UI thread (which drives the user interface event loop) running and prevents the system from concluding that your code has frozen. Because such threading usually is accomplished at the class level, you can think of responsiveness as a class problem. (Compare this with basic code performance, which is a method-level concern.)

In Android, application responsiveness is monitored by the Activity Manager and Window Manager system services. Android will display the ANR dialog for a particular application when it detects one of the following conditions:

 - No response to an input event (such as key press or screen touch events) within 5 seconds.
 - A BroadcastReceiver hasn't finished executing within 10 seconds.

###How to Avoid ANRs

Android applications normally run entirely on a single thread by default the "UI thread" or "main thread"). This means anything your application is doing in the UI thread that takes a long time to complete can trigger the ANR dialog because your application is not giving itself a chance to handle the input event or intent broadcasts.

Therefore, any method that runs in the UI thread should do as little work as possible on that thread. In particular, activities should do as little as possible to set up in key life-cycle methods such as onCreate() and onResume(). Potentially long running operations such as network or database operations, or computationally expensive calculations such as resizing bitmaps should be done in a worker thread (or in the case of databases operations, via an asynchronous request).

The most effective way to create a worker thread for longer operations is with the AsyncTask class. Simply extend AsyncTask and implement the doInBackground() method to perform the work. To post progress changes to the user, you can call publishProgress(), which invokes the onProgressUpdate() callback method. From your implementation of onProgressUpdate() (which runs on the UI thread), you can notify the user. For example:
```
private class DownloadFilesTask extends AsyncTask<URL, Integer, Long> {
    // Do the long-running work in here
    protected Long doInBackground(URL... urls) {
        int count = urls.length;
        long totalSize = 0;
        for (int i = 0; i < count; i++) {
            totalSize += Downloader.downloadFile(urls[i]);
            publishProgress((int) ((i / (float) count) * 100));
            // Escape early if cancel() is called
            if (isCancelled()) break;
        }
        return totalSize;
    }

    // This is called each time you call publishProgress()
    protected void onProgressUpdate(Integer... progress) {
        setProgressPercent(progress[0]);
    }

    // This is called when doInBackground() is finished
    protected void onPostExecute(Long result) {
        showNotification("Downloaded " + result + " bytes");
    }
}
```
To execute this worker thread, simply create an instance and call execute():
```
new DownloadFilesTask().execute(url1, url2, url3);
```
**Although it's more complicated than AsyncTask, you might want to instead create your own Thread or HandlerThread class. If you do, you should set the thread priority to "background" priority by calling Process.setThreadPriority() and passing THREAD_PRIORITY_BACKGROUND. If you don't set the thread to a lower priority this way, then the thread could still slow down your app because it operates at the same priority as the UI thread by default.**

If you implement Thread or HandlerThread, be sure that your UI thread does not block while waiting for the worker thread to complete—do not call Thread.wait() or Thread.sleep(). Instead of blocking while waiting for a worker thread to complete, your main thread should provide a Handler for the other threads to post back to upon completion. Designing your application in this way will allow your app's UI thread to remain responsive to input and thus avoid ANR dialogs caused by the 5 second input event timeout.

The specific constraint on BroadcastReceiver execution time emphasizes **what broadcast receivers are meant to do: small**, discrete amounts of work in the background such as saving a setting or registering a Notification. So as with other methods called in the UI thread, applications should avoid potentially long-running operations or calculations in a broadcast receiver. But instead of doing intensive tasks via worker threads, your application should start an IntentService if a potentially long running action needs to be taken in response to an intent broadcast.

`Tip: You can use StrictMode to help find potentially long running operations such as network or database operations that you might accidentally be doing on your main thread.`

###Reinforce Responsiveness

Generally, **100 to 200ms is the threshold** beyond which users will perceive slowness in an application. As such, here are some additional tips beyond what you should do to avoid ANR and make your application seem responsive to users:

 - If your application is doing work in the background in response to user input, **show that progress is being made** (such as with a ProgressBar in your UI).
 - For games specifically, do calculations for moves in a **worker thread**.
 - If your application has a time-consuming initial setup phase, consider **showing a splash screen or rendering the main view as quickly as possible**, indicate that loading is in progress and fill the information asynchronously. In either case, you should indicate somehow that progress is being made, lest the user perceive that the application is frozen.
 - Use performance tools such as **Systrace and Traceview to determine bottlenecks** in your app's responsiveness.

[1]:http://developer.android.com/training/articles/perf-anr.html#Reinforcing
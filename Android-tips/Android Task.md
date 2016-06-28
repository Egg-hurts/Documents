A task is a collection of activities that users interact with when performing a certain job. The activities are arranged in a stack (the back stack), in the order in which each activity is opened.

The device Home screen is the starting place for most tasks. When the user touches an icon in the application launcher (or a shortcut on the Home screen), that application's task comes to the foreground. If no task exists for the application (the application has not been used recently), then a new task is created and the "main" activity for that application opens as the root activity in the stack.


----------


To summarize the default behavior for activities and tasks:

When Activity A starts Activity B, Activity A is stopped, but the system retains its state (such as scroll position and text entered into forms). If the user presses the Back button while in Activity B, Activity A resumes with its state restored.
When the user leaves a task by pressing the Home button, the current activity is stopped and its task goes into the background. The system retains the state of every activity in the task. If the user later resumes the task by selecting the launcher icon that began the task, the task comes to the foreground and resumes the activity at the top of the stack.
If the user presses the Back button, the current activity is popped from the stack and destroyed. The previous activity in the stack is resumed. When an activity is destroyed, the system does not retain the activity's state.
Activities can be instantiated multiple times, even from other tasks.


----------


As discussed above, the system's default behavior preserves the state of an activity when it is stopped. This way, when users navigate back to a previous activity, its user interface appears the way they left it. However, you can—and should—proactively retain the state of your activities using callback methods, in case the activity is destroyed and must be recreated.

When the system stops one of your activities (such as when a new activity starts or the task moves to the background), the system might destroy that activity completely if it needs to recover system memory. When this happens, information about the activity state is lost. If this happens, the system still knows that the activity has a place in the back stack, but when the activity is brought to the top of the stack the system must recreate it (rather than resume it). In order to avoid losing the user's work, you should proactively retain it by implementing the ***onSaveInstanceState()*** callback methods in your activity.


----------


As such, if Activity A starts Activity B, Activity B can define in its manifest how it should associate with the current task (if at all) and Activity A can also request how Activity B should associate with current task. If both activities define how Activity B should associate with a task, then Activity A's request (as defined in the intent) is honored over Activity B's request (as defined in its manifest).

Note: Some launch modes available for the manifest file are not available as flags for an intent and, likewise, some launch modes available as flags for an intent cannot be defined in the manifest.


----------


**Handling affinities**

The affinity indicates which task an activity prefers to belong to. By default, all the activities from the same application have an affinity for each other. So, by default, all activities in the same application prefer to be in the same task. However, you can modify the default affinity for an activity. Activities defined in different applications can share an affinity, or activities defined in the same application can be assigned different task affinities.

You can modify the affinity for any given activity with the taskAffinity attribute of the <activity> element.

The taskAffinity attribute takes a string value, which must be unique from the default package name declared in the <manifest> element, because the system uses that name to identify the default task affinity for the application.

The affinity comes into play in two circumstances:

 - When the intent that launches an activity contains the FLAG_ACTIVITY_NEW_TASK flag.
A new activity is, by default, launched into the task of the activity that called startActivity(). It's pushed onto the same back stack as the caller. However, if the intent passed to startActivity() contains the FLAG_ACTIVITY_NEW_TASK flag, the system looks for a different task to house the new activity. Often, it's a new task. However, it doesn't have to be. If there's already an existing task with the same affinity as the new activity, the activity is launched into that task. If not, it begins a new task.
If this flag causes an activity to begin a new task and the user presses the Home button to leave it, there must be some way for the user to navigate back to the task. Some entities (such as the notification manager) always start activities in an external task, never as part of their own, so they always put FLAG_ACTIVITY_NEW_TASK in the intents they pass to startActivity(). If you have an activity that can be invoked by an external entity that might use this flag, take care that the user has a independent way to get back to the task that's started, such as with a launcher icon (the root activity of the task has a CATEGORY_LAUNCHER intent filter; see the Starting a task section below).
 - When an activity has its allowTaskReparenting attribute set to "true".
In this case, the activity can move from the task it starts to the task it has an affinity for, when that task comes to the foreground.
For example, suppose that an activity that reports weather conditions in selected cities is defined as part of a travel application. It has the same affinity as other activities in the same application (the default application affinity) and it allows re-parenting with this attribute. When one of your activities starts the weather reporter activity, it initially belongs to the same task as your activity. However, when the travel application's task comes to the foreground, the weather reporter activity is reassigned to that task and displayed within it.

Tip: If an .apk file contains more than one "application" from the user's point of view, you probably want to use the taskAffinity attribute to assign different affinities to the activities associated with each "application".


----------
If there's already an existing task with the same affinity as the new activity, the activity is launched into that task. If not, it begins a new task.

The affinity of a task is determined by reading the affinity of its root activity.

You can set up an activity as the entry point for a task by giving it an intent filter with "android.intent.action.MAIN" as the specified action and "android.intent.category.LAUNCHER" as the specified category.


----------


FLAG_ACTIVITY_CLEAR_TOP
If the activity being started is already running in the current task, then instead of launching a new instance of that activity, all of the other activities on top of it are destroyed and this intent is delivered to the resumed instance of the activity (now on top), through onNewIntent()).
There is no value for the launchMode attribute that produces this behavior.

FLAG_ACTIVITY_CLEAR_TOP is most often used in conjunction with FLAG_ACTIVITY_NEW_TASK. When used together, these flags are a way of locating an existing activity in another task and putting it in a position where it can respond to the intent.

Note: If the launch mode of the designated activity is "standard", it too is removed from the stack and a new instance is launched in its place to handle the incoming intent. That's because a new instance is always created for a new intent when the launch mode is "standard".


----------


Constant	Value	Description

 - standard	0	The default mode, which will usually create a new instance of the activity when it is started, though this behavior may change with the introduction of other options such as Intent.FLAG_ACTIVITY_NEW_TASK.
 - singleTop	1	If, when starting the activity, there is already an instance of the same activity class in the foreground that is interacting with the user, then re-use that instance. This existing instance will receive a call to Activity.onNewIntent() with the new Intent that is being started.
 - singleTask	2	If, when starting the activity, there is already a task running that starts with this activity, then instead of starting a new instance the current task is brought to the front. The existing instance will receive a call to Activity.onNewIntent() with the new Intent that is being started, and with the Intent.FLAG_ACTIVITY_BROUGHT_TO_FRONT flag set. This is a superset of the singleTop mode, where if there is already an instance of the activity being started at the top of the stack, it will receive the Intent as described there (without the FLAG_ACTIVITY_BROUGHT_TO_FRONT flag set). See the Tasks and Back Stack document for more details about tasks.
 - singleInstance	3	Only allow one instance of this activity to ever be running. This activity gets a unique task with only itself running in it; if it is ever launched again with the same Intent, then that task will be brought forward and its Activity.onNewIntent() method called. If this activity tries to start a new activity, that new activity will be launched in a separate task. See the Tasks and Back Stack document for more details about tasks.


----------

Clearing the back stack

If the user leaves a task for a long time, the system clears the task of all activities except the root activity. When the user returns to the task again, only the root activity is restored. The system behaves this way, because, after an extended amount of time, users likely have abandoned what they were doing before and are returning to the task to begin something new.

There are some activity attributes that you can use to modify this behavior:

 - alwaysRetainTaskState
If this attribute is set to "true" in the root activity of a task, the default behavior just described does not happen. The task retains all activities in its stack even after a long period.
 - clearTaskOnLaunch
If this attribute is set to "true" in the root activity of a task, the stack is cleared down to the root activity whenever the user leaves the task and returns to it. In other words, it's the opposite of alwaysRetainTaskState. The user always returns to the task in its initial state, even after a leaving the task for only a moment.
 - finishOnTaskLaunch
This attribute is like clearTaskOnLaunch, but it operates on a single activity, not an entire task. It can also cause any activity to go away, including the root activity. When it's set to "true", the activity remains part of the task only for the current session. If the user leaves and then returns to the task, it is no longer present.


----------


----------
[1]:http://developer.android.com/guide/components/tasks-and-back-stack.html
[2]:http://developer.android.com/guide/components/recents.html
[3]:http://developer.android.com/reference/android/R.styleable.html#AndroidManifestActivity_launchMode
[4]:http://developer.android.com/design/patterns/navigation.html
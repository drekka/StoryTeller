# StoryTeller
A logging framework that promotes following data rather than functionality in logs.

### WTF - Another logging framework!!!

Yep. Another one. But with a difference ...

The idea that drives Story Teller is quite simple: ***To debug an application, developers need to see the threads of data as they weave their way through the code.***

Other logging frameworks use a very crass shotgun approach (IMHO) base on assuming that the *severity* of a log statement can be used to derive useful logging output. There is no way to target the logging and usually a huge amount of useless output is produced. The real problem with these frameworks is that they are based on dated assumptions and designs from systems where CPU and storage are unlimited, and where producing Gigabytes of logs is thought to be useful. Mostly by people who have no idea what developers actually need. 

Story Teller takes a different approch - it targets what developers acutally need by combining the ability to base logging on dynamic data driven *Keys*, with a query driven logging criteria. This enabled the developer to target their logging on the specific data relevant to the problem at hand. This produces very concise logs which contain only relevant and useful information.

# Installation

## Carthage

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

This project can be dynamically included using [Carthage](https://github.com/Carthage/Carthage). This is recommended if you are using iOS8+.

Simple create a  file called ***CartFile*** in the root of your project and add a line of text like this:

```
github "drekka/StoryTeller" >= 0.1
```
fire up a command line and execute from our projects root directory:

```
carthage bootstrap
```

This will download and compile Story Teller into a framework in *<project-root>/Carthage/Build/iOS/StoryTeller.framework*.

Then simply add this framework as you would any other.

## Cocoapods

At the moment I don't support [Cocoapods](https://cocoapods.org) because I regard it as as hacky poor quality solution. And I don't use it on my personal projects. I have created a posspec in the root of Story Teller, but so far it doesn't pass the pod lint tests and typically with any Ruby hack projects, is giving errors that make no sense. I'll get around to supporting it one day. But it's not something I use. Feel free to figure it out if you want.

## Submodules or Manual includes

Another fine way to include Story Teller is to use [Git Submodules](https://chrisjean.com/git-submodules-adding-using-removing-and-updating/). Whilst more technical in nature, it gves you the best control of the software. Use the following URL for your submodule or if you want to manually check Story Teller out:

[https://github.com/drekka/StoryTeller.git]()

# Adding logging to your code

Story Teller has one basic logging statement:

```objectivec
STLog(<key>, <message-template>, <args ...>); 
```
This looks very similar to other logging frameworks. Except that they would either having `key` replaced with a severity level, or have multiple statements such as `logDebug`, `logInfo`, etc. 

## Magic keys

Story Teller's ***Key*** is the important differentiator between it and these other logging frameworks. With Story Teller, *the key can be anything you want !"* An account number, a user id, a class, or any object you want to be able to base a search on when debugging and whatever makes sense in your app. Here are some examples:

```objectivec
STLog(user, "User %@ is logging", user.id);
STLog(@(EnumValueGUI), "GUI is doing %@ with %@", aGUIValue, anotherGUIVaue);
STLog(currentView, "GUI is doing something with %@", currentView);
STLog(@"abc", @"ABC, ha ha ha ha ha");
```

## What if I don't have an accessible key?

Often you might want to log based on something , but be in some method that doesn't have access to that data. Story Teller solves this with the concept of **Key Scopes**. You can tell it to make a specific key cover a range of log statements any log statements that are in that scope are regarded as being logged under the scope's key. Here's an example:

```objectivec
STLog(user, "User %@ is logging", user.id);
STStartScope(user.id);
/// ...  do stuff
STLog(account, "User %@'s account: %@", user.id, account.id); 
[self goDoSomethingWithAccount:account];
```

When reporting based on user, the second log statement (key:account) will also be printed because it's within the scope of user.

Scopes follow these rules: 

 * Normal Objective-C scopes for variables. This is because under the hood, Story Teller is using a dynamically added variable to detect when the scope ends. Normally this is the end of the current method, loop or if statement. Assume a `STScopeStart(...)` is a variable declaration and you will ge the idea. 
 * Story Teller's then includes any called code. So any logging within a method or API is also included with the scope. This enables logging across a wide range of classes to be accessed using one key without having to specifically pass that key around.  

 In the above example, any logging with in `goDoSomethingWithAccount:` will also be logged when logging for the user.

# Configuring logging

## On startup

Story Teller uses a set of options which it obtains via this process on startup:

1. A default setup is first created with no logging active.
2. Story Teller then searches all bundles in the app for a file called ***StoryTellerConfig.json***. If found this file is read and the base config is updated with any settings it contains.
3. Finally the process is checked and if any of the arguments set on the process match known keys in the config, then those values are updated.

The basic idea is that you can add a ***StoryTellerConfig.json*** file to your app to provide the general config you want to run with, and then during development you can override at will by setting arguments in XCode's scheme for your app.

Current the Json file has two settings and looks something like this:

```json
{
    "activeLogs": [
        "abc",                           /* A specific string key */
        12,                              /* A numeric (Enum?) key */
        "[User].account.balance > 500"   /* Any account over $500 */
    ],
    "loggerClass": "STConsoleLogger"  /* Optional */
}
```

### Settings

Key  | Value
------------- | -------------
activeLogs | A comma separated list of keys to activate. This is the main setting for turning on logging.
loggerClass | If you want to set a different class for the, use this setting to specify the class. The class must implement `<STLogger>` and have a no-arg constructor. You only need to put the class name in this setting. Story Teller will handle the rest. By default, Story Teller uses a simple console logger.

## Programmatically

You can also programmically enable and disable logging as well. To enable logging, use this statement:

```objectivec
STStartLogging(<key>);
```

# Smart Logging Criteria

The `activeLogs` configuration setting contains an comma seperated list of smart criteria which activate the log statements. The  `STStartLogging(<criteria>);` Objective-C statement does the same thing, except you can only pass one criteria at a time. 

So what are these criteria? Here are the options


## General logging

First up there are two special logs you can activate:

```objectivec
STStartLogging(@"LogAll");
STStartLogging(@"LogRoots");
```

*** LogAll*** activates all log statements and disregards any other logging criteira. This is literally a turn everything on option so don't expect to use it often and it's not really what Story Teller is about.

***LogRoots*** is similar to *LogAll* except that it only logs when there are not scopes active. The idea is to get a log showing the highlevel activity in the system. So how well it works depends on how well you setup you log statements. LogRoots will also be overridden by LogAll if it is turned on.


## Simple value criteria

When Story Teller encounters a single value in a criteria, it makes the assumption that the same value has been used as a key. Simple values can be either strings or numbers. Using strings mades a good descriptive sense, whilst integers can be a good idea for matching enums. Notice that with strings, if you don't have any white space in the value, you can enter it without quotes. 

For example:

```objectivec
STLog("abc", @"Log some abc stuff");
STLog("GUI System", @"Log view @ %@", aRect);
STLog(@(EnumValueX), @"Log related to EnumValueX");
```

```objectivec
STStartLogging(@"abc");
STStartLogging(@"\"GUI System\"");
STStartLogging(@(EnumValueX)); 
```

## Classes or Protocol criteria 

### Instances

You can log based on the type of the key used like this:

`[class-name] | <protocol-name>`

These will search for any logging where the key is an instance of the class (or is a subclass of it), or an instance that implements the specified protocol. Here's an example:

```objectivec
STLog(User, @"Log message for a user");
```

```objectivec
STStartLogging(@"[User]");
STStartLogging(@"<Person>");    /* Assuming User implements Person */
```

## KVC Property criteria

`[class-name].keypath op value`
`<protocol-name>.keypath op value`

This criteria looks for keys that matches the specified class or protocol, then examine the `keypath` on the object for the required value. Here are some examples

```objectivec
STStartLogging(@"[User].account.name == \"derek's account\"");
STStartLogging(@"[User].account.balance > 500");
STStartLogging(@"<Banking>.active == YES");
STStartLogging(@"<Banking>.lastLogon == nil");
STStartLogging(@"<Banking>.customer != <Banker>");
```
As you can see there is a lot of power here to decide what gets logged. Values fall into several types:

 * **Strings** - any string. Quotes are required if it incudes whitespace.
 * **Numbers** - Any number, integer or decimal format. Number queries can use all the standard comparison operators: **==** ,**!=** ,**<** ,**<=** ,**>** or **>=**.
 * **nil checks** - 'nil' keyword which checks for nils exactly the same as Objective-C does. Nil checks  can only use the logical operators: **==** and **!=**.
 * **type checks** - either a class or protocol declaration. The same way we declare the type of the key being searched.  Type checks can only use the logical operators: **==** and **!=**.

## Runtim criteria

*Rarely used, but I needed it for another project.* 

Sometimes you might use a Class or Protocol object for a key, or want to search on a property that returns a Class or Protocol. In those cases you can use the **is** keyword to tell Story Teller to look for the matching Class or Protocol rather than testing an object to see if it implements the type. 

For example:

```objectivec
STLog([User class], @"Log message for class");
STLog(@protocol(NSCopying), @"Log message for NSCopying");
```

Looking for Class or Protocol keys

```objectivec
STStartLogging(@"is [User]");
STStartLogging(@"is <NSCopying>");
```

Looking for Class or Protocol values in properties

```objectivec
STStartLogging(@"[User].accountClass is [MerchantAccount]");
STStartLogging(@"[User].bankingProtocol is <InternetBanking>");
```

# Execution blocks

Story Teller has another trick up it's sleeve. Often we want to run a set of statements to assemble some data before logging or even to log a number of statements at once. With other frameworks we have to manually add some boiler plate around the statements to make sure they are not always being executed. Story Teller has a statement built specifically for this purpose:

```objectivec
STExecuteBlock(<key>, ^(id key) {
     // Statements go here.
});
``` 

The block will only be executed if they currently active logging matches the key. This makes it a perfect way to handle larger and more complex logging situations.

## Release vs Debug

Story Teller is very much a Debug orientated logger. Is is not designed to be put into production apps. To that effect, it has a strip mode. Simply add this macro to your **Release** macro declarations and all Story Teller loggin will be stripped out, leaving your Release version a lean mean speed machine.

Disable macro name: **`DISABLE_STORY_TELLER`**

## Async

Story Teller does not support async logging at this time. Async logging is a response to a bad idea. The only time it is needed is when the developer is logging a massive amount of information to a file, usually because they have been told it's *'necessary'*. Often by someone who is not a developer and doesn't understand programming. I've never in 30 years seen an instance where one of these sorts of logs has been of any use. But some 3rd party libraries which support async come with it configured on as it allows them to log faster and claim performance gains.

When debugging a problem or a unit test, developers will invaraibly turn off async because the delay between an event occuring and the logged statements appearing in the log is too long. If they appear at all. 

Developers need to see things when they occur. Not some undetermined time in the future. This is why Story Teller does not support async.

## Performance

Performance is something that is a factor when logging because logging to the console or a file is inheriantly slow. Traditional logging frameworks endevour to speed things up by using simple boolean controls or using async logging. This comes from the basic design concept which they all subscribe to - *that we want to log everything and sort it out later.* 

This is a flawed concept. It produces a lot of logging and causes significant slow downs. And it's very wasteful. Especially in the mobile world where dumping everything into a file just on the off chance that someone might want to look at it is quite out of the question. 

Because of Story Teller's smart logging, it will often be faster than traditional logging frameworks simply because the reduction in output more than compensates for the extra processing required.

### Update - some bench marks

I decided to get an idea of how Story Teller actually compared. So I created a test project and put both Story Teller and a *Very Popular 3rd party logging framework* into it. 

I configured the project to log 1,000 lines of text to the console and store the duration of the process. I also made sure that each line of text was different. I then added further processing to do this loop  10 times and average the durations. 

I then ran this with the other framework set to 'Debug', and Story Teller configured with a criteria similar to `'[Dummy].forbar = YES'` with the log key being an instance of class Dummy. Finally I turned off async logging on the other framework as no developer works with it on and Story Teller does not support it. The idea was to make sure that I was comparing oranges with oranges.

The results where suprising. In a straight time run of logging Story Teller was actually **4x faster** than the competitor. This totally surprised me and the only thing I could think of was that the competitor must have a lot of compexity in it that I simply haven't added to Story Teller. But still - ***4x?***

I then ran the tests again. This time the competitor easily out performed Story Teller. This was expected as the competitor was designed around very fast boolean switches and could optimize out the logging statements. Story Teller on the other hand, has to leave everything in places because the logging decisions are made at runtime. 

Still, Story Teller ran the same loop of avg(1,000)x10 very fast. In the region of 0.001 sec per 1,000 log statements (not logging) and 0.1 sec when logging. So even with it's significantly more intelligent logging, it's no slouch.


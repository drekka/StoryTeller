# StoryTeller
A logging framework that promotes following data rather than functionality in logs.

### WTF - Another logging framework!!!

Yep. Another one. But with a difference. *Read on ...*

All the frameworks I have found *(both in the Java and Objective-C worlds)* follow a very old fashioned logging approach *(IMHO)*: Logging statements are keyed based on a severity of the data being logged. So when debugging a problem, the developer takes a guesstimate of what severity level to log that will most likely show the information they need.

The problem with this approach is that it usually results in a large amount of output which requires significant effort to troll through. There is no way for the developer to focus in on the problem and when debugging a problem, developers really want to trace a particular piece of information through the code, regardless of where it goes and what the 'severity' is.

So I decided to think different.

The idea that realised Story Teller is quite simple: ***To debug an application, developers need to see the threads of data as they weave their way through the code.***

Story Teller concentrates on giving developers a logging system that allows them to interrogate the data in order to decide whether to log or not. This enables it to provide very concise logs which only contain output related to the problem at hand.

## Setup

### Carthage

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

This project can be dynamically included using [Carthage](https://github.com/Carthage/Carthage). This is recommended if you are using iOS8+.

Simple create a  file called ***CartFile*** in the root of your project and add a line of text like this:

```
github "drekka/StoryTeller" >= 0.1
```
fire up a command line and execute from your project's root directory:

```
carthage bootstrap
```

This will checkout Story Teller, compile and build Story Teller into a framework in *<project-root>/Carthage/Build/iOS/StoryTeller.framework*.

Then all you have to do is simply add this framework as you would any other framework. Story Teller can then be added to classes using this import:

```objectivec
#import <StoryTeller/StoryTeller.h>
```

No other setup is required. By being present in your project, Story Teller will bootstrap itself on application start. 

### Cocoapods

At the moment I don't support [Cocoapods](https://cocoapods.org) because I regard it as as hacky poor quality solution. And I don't use it on my personal projects. I have created a posspec in the root of Story Teller, but so far it doesn't pass the pod lint tests and typically with any Ruby hack projects, is giving errors that make no sense. I'll get around to supporting it one day. But it's not something I use. Feel free to figure it out if you want.

### Submodules or Manual includes

Another fine way to include Story Teller is to use [Git Submodules](https://chrisjean.com/git-submodules-adding-using-removing-and-updating/). Whilst more technical in nature, it gves you the best control of the software. Use the following URL for your submodule or if you want to manually check Story Teller out:

[https://github.com/drekka/StoryTeller.git]()

Note: that you can also use the `--submodules` option of Carthage to create a dependency as a submodule.

## Adding logging to your code

Story Teller has one basic logging statement:

```objectivec
log(<key>, <message-template>, <args ...>); 
```
This looks very similar to other logging frameworks. Except that they would either having `key` replaced with a severity level, or have multiple statements such as `logDebug`, `logInfo`, etc.

Story Teller's ***Key*** is the important differentiator. ***It can be anything you want!*** 

*The idea is that it is an identifier or object that you can later use to trace data through the system.* This is where Story Teller's strength is. The key might be an account number, a user object, a class, an NSNumber or anything you want to be able to search on when debugging. Whatever makes sense in your app. Here's some examples:

```objectivec
log(user.id, "User %@ is logging", user.id);
log(user, "User %@ is logging", user.id);
log(@(SubSystemGuiId), "Drawing view at %@", aRect);
```

### What if I don't have an accessible key?

Often you might want to be logging based on something like a user, but be in some method that doesn't have that user object available. So how do you log it?

Story Teller has the concept of **Key Scopes**. You can tell it that any logging statements for the current scope are regarded as being under a specific key, even if the log statements do not use that key or cannot access it. Here's an example:

```objectivec
log(user, "User %@ is logging", user.id);
startScope(user);
/// ...  do stuff
log(account, "User %@'s account: %@", user.id, account.id); 
[self goDoSomethingWithAccount:account];
```

So when reporting based on user, the second log statement (key:account) will also be printed because it's within the scope of user even though it does not use the user key.

*Scopes follow the normal Objective-C rules for variable scopes. When enabled they will continue until the end of the current variable scope. Normally this is the end of the current method, loop or if statement.*

However Story Teller's scopes **also include any called methods**. So any logging within a method or API is also included with the defined scope. This enables logging across a wide range of classes to be accessed using one key without having to specifically pass that key around. 

In the above example, any logging with in the `goDoSomethingWithAccount:` method will also be logged when logging for key:user is active.

## Configuration

Story Teller reads it's config using this process:

1. A default setup is first created with no logging active.

2. Story Teller then searches all bundles in the app for a file called ***StoryTellerConfig.json***. This file is read and the base config is updated with any settings it contains.

3. Finally the process is checked and if any of the arguments set on the process match known keys in the config, then those values are updated.

The basic idea is that you can add a ***StoryTellerConfig.json*** file to your app to provide the general config you want to run with, and then during development you can override at will by setting arguments in XCode's scheme for your app. Here is an example one:

```json
{
"logAll": "YES",
"logRoot": "NO",
"activeLogs": ["abc", "def"],
"loggerClass": "STConsoleLogger"
}
```

### Programmatically

You can also programmically enable logging as well using this statement:

```objectivec
startLogging(<criteria>);
```

### Config settings

The following is a list of config settings:

Key  | Value
------------- | -------------
logAll | Enables every log statement regardless of it's key. Useful for bugging but might produce a lot of output.
LogRoots | Similar to *logAll* except that only top scope log statements are activated. In other words, log statements to are not within `startScope(...)` commands. Useful for getting a high level view of whats occuring.
activeLogs | A comma separated list of `criteria` which defines the logging that will occur. This is the main setting for activating on logging.
loggerClass | If you want to set a different class for the, use this setting to specify the class. The class must implement `STLogger` and have a no-arg constructor. You only need to put the class name in this setting. Story Teller will handle the rest.

## Smart Logging Criteria

The `activeLogs` configuration setting contains an comma seperated list of smart criteria which activate the log statements. The  `startLogging(<criteria>);` Objective C statement does the same thing, except you can only pass one criteria at a time. 

So what are these criteria? Here are the options

### Single value criteria

When Story Teller encounters a single value in a criteria, it makes the assumption that the same value has been used as a key. A single value criteria can be any of the following types: **String**, **Number** or **Boolean**. Here is an example:

```
...
"activeLogs":["DerekC, \"GUI system\", 12, true, YES],  
...
```

You can use any of these types, although using the booleans would not normally make sense. Using strings mades a good descriptive sense and integers can be a good idea for matching enums. Notice that with strings, if you don't have any white space in the value, you can enter it without quotes. For example:

```objectivec
log("GUI System", @"Log view @ %@", aRect);
log(@(EnumValueX), @"Log related to EnumValueX");
```

```objectivec
startLogging(@"GUI-System");
startLogging(@"\"GUI-System\"");
startLogging(@"5"); // EnumValueX -> 5
```

### Classes and Protocols 

#### Instances

You can log based on the type of the key used like this"

`[class-name] | <protocol-name>`

These will search for any logging where the key is an instance of the class (or is a subclass of it), or an instance that implements the specified protocol. Here's an example:

```objectivec
log(User, @"Log message for a user");
```

```objectivec
startLogging(@"[User]");
startLogging(@"<NSCopying>");
```

#### Runtime keys

Secondly you can add the **isa** prefix to search for log statements where the actual class or protocol has been used as a key, rather that an instance of one.

`isa [class-name] | <protocol-name>`

For example:

```objectivec
log([User class], @"Log message for class");
log(@protocol(NSCopying), @"Log message for NSCopying");
```

```objectivec
startLogging(@"isa [User]");
startLogging(@"isa <NSCopying>");
```

### KVC Property criteria

`[class-name].keypath op value`
`<protocol-name>.keypath op value`

This criteria looks for keys that matches the specified class or protocol, then examine the `keypath` on the object for the required value. Here are some examples

```objectivec
log(user, @"Log message for user");
```

```objectivec
startLogging(@"[User].account.name == \"derek's account\"");
startLogging(@"[User].account.balance > 500");
startLogging(@"<Banking>.active == YES");
```
As you can see there is a lot of power here to decide what gets logged. 

Operators include all the standard comparison operators: **==** ,**!=** ,**<** ,**<=** ,**>** or **>=**.


## Execution blocks

Story Teller has another trick up it's sleeve. Often we want to run a set of statements to assemble some data before logging or even to log a number of statements at once. With other frameworks we have to manually add some boiler plate around the statements to make sure they are not always being executed. Story Teller has a statement built specifically for this purpose:

```objectivec
executeBlock(<key>, ^(id key) {
     // Statements go here.
});
``` 

The block will only be executed if they currently active logging matches the key. This makes it a perfect way to handle larger and more complex logging situations.

## Release vs Debug

Story Teller is very much a Debug orientated logger. Is is not designed to be put into production apps. To that effect, it has a strip mode. Simply add this macro to your **Release** macro declarations and Story Teller will strip out all logging code, leaving your Release version a lean mean speed machine.

Disable macro name: **`DISABLE_STORY_TELLER`**

## Performance

Generally speaking most loging frameworks optimize their logging decision making down to a set of booleans. This means they are fast, however it makes them relatively inflexible during the logging process. Hence the concept of log levels and class based criteria compromises but given you some basic control, but keeping this fast.

Story Teller makes every attempt to keep things as fast as possible. But because of the more intensive decision making it does, it's unlikely to be able to compete with other loggers when dealing with large volumes of logging. But all things considered, would you really want to log that much anyway?

Finally, given the performance of today's hardware, it's unlikely they Story Teller will slow down any software enough to cause a problem.



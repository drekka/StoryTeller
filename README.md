# StoryTeller
A logging framework that promotes following data rather than functionality in logs.

### WTF - Another logging framework!!!

Yep. Another one. But Story Teller is different to every other one you might have looked at.

The idea behind Story Teller is quite simple: ***To debug an application, developers need to see the threads of data as they weave their way through the code.***

Because it's the data that triggers the bugs and if you cannot see the data you cannot debug the problem. 

Other logging frameworks base their logging on a combination of issue severity and source code location. So when writing or using the logging, developers are asking themselves *How important is the imformation and where in the source code is it?* These are the wrong questions.

Just ask yourself how many times you have turned on Debug logging and had to troll through massive logs trying to figure out what happened with account X?

Story Teller bases it's logging around a simpler and more important question: ***What is this about?***

Story Teller concentrates it's criteria around answering that question. So rather than turning on Debug logging, you can enable logging of anything to do with account X. And see only those log statements in the output.

## Setup

### Carthage

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

This project can be dynamically included using Carthage. This is recommended if you are using iOS8+.

### Cocoapods

You can use cocoapods to include this project.

## Adding Story Teller logging

## Turning on a log


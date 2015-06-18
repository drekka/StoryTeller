# StoryTeller
A logging framework that promotes following data rather than functionality in logs.

The premise of Story Teller is quite simple: To debug an application, developers need to see the threads of data as they weave their way through the code. Because it's the data that triggers the bugs and if you cannot see the data you cannot debug the problem. 

Every logging framework I've seen bases their logging criteria on a combination of severity and source code location, totally disregarding the data being used. They have it wrong! 

Story Teller addresses the logging needs of the debugging developer by targetting the data as the criteria for logging. By logging based on data, the resulting logs will contain only relevant log entries they are interested in. Thus being considerably smaller than traditional logs which are notoriously hard to read. 

Setup is also easier as the developer does not have to partition their logging up by severity and diagnose which parts of the code need to have logging activated. Story Teller uses just one logging statement everywhere.

## Setup

## Logging

## Activating


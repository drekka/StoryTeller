# StoryTeller 

*A log should tell a story, not drown the reader in irrelevance* 

Story Teller is an advanced logging framework that takes an entirely different approach to logging - swapping the limitations of severity levels for smart active search criteria.

See how it works on the main [Story Teller site](http://drekka.github.io/StoryTeller).

# V1.7.5

* Fixed bugs in test code.
* Removed line feed from line assembly code. Added it in console logger.
* Removed key as argument to block when executing a block for a key.

# V1.7.4

* Refactored the log assembly code to avoid multiple threads mixing text on a single line.

# v1.7.3

* Fixing bug where a weakly referenced key would crash the app if logging was done in a dealloc.

# V1.7.2 #

* Added option to log the thread number.
* Added option to draw a picture of the thread similar to a git branch view as the logging occurs. The ASCII based character image illustrates which messages are on the main thread and which are on background threads.


# How to contribute

Thanks for taking an interest in contributing to the BaseBot framework. 

If you haven't already, check out the [readme](https://github.com/ans-group/basebot-app/blob/master/readme.md) which should give you a good overview over project structure, conventions etc.

## Testing

We're sorely lacking in any form of automated testing. Implementing unit tests would be a great contribution for someone looking to help.

## Submitting changes

Please create a [Pull Request](https://github.com/ans-group/basebot-app/pull/new/master) with a clear list of what you've done (read more about [pull requests](http://help.github.com/pull-requests/)).

Always write a clear log message for your commits. One-line messages are fine for small changes, but bigger changes should look like this:

    $ git commit -m "A brief summary of the commit
    > 
    > A paragraph describing what changed and its impact."

## Coding conventions

We utilize the [Standard](https://standardjs.com/) JS style conventions. Some highlights of the style are:

* **2 spaces** – for indentation
* **Single quotes for strings** – except to avoid escaping
* **No unused variables** – this one catches tons of bugs!
* **No semicolons**
* **Space after keywords** if (condition) { ... }
* **Space after function name** function name (arg) { ... }
* Always use === instead of == – but obj == null is allowed to check null || undefined.
* Always handle the node.js err function parameter
* Declare browser globals with /* global */ comment at top of file
  * Prevents accidental use of vaguely-named browser globals like open, length, event, and name.
  * Example: /* global alert, prompt */
  * Exceptions are: window, document, and navigator

Thanks,
Calvin, Nathan and the rest of ANS

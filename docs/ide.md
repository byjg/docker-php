# Using the Image in Your IDE

You don't need to have PHP installed on your machine to access all the features
your IDE can offer. You can use the Docker PHP Image by ByJG. 

If you are using [PHPStorm](https://www.jetbrains.com/phpstorm/) from Jetbrains, you can easily add any PHP version using the
tutorial below.

First, go to "File -> Settings -> Languages/Framework" and click on the ellipsis 
beside the "CLI Interpreter" text box. 

![img.png](img.png)

Then, click on "Add (+) -> From Docker, Vagrant, etc."

![img_1.png](img_1.png)

On the next screen, you need to set the proper image. If you want to use PHP Version 7.3,
you need to fill in the image name `byjg/php:7.3-cli`. Make sure you have Docker installed and properly
set up in the [PHPStorm IDE](https://www.jetbrains.com/phpstorm/). If you can't see the "Server" `docker`, click on "New" and 
after setup, continue the process as shown below:

![img_2.png](img_2.png)

If everything is OK, you will see the PHP Version and XDebug. You can deselect the option
"Visible only for this project" if you want to have these configurations for all PHP projects you have.

![img_3.png](img_3.png)

And voilà! Just select this new version for your project, and you can have auto-complete, debug, etc.,
as if you had PHP installed on your machine.

![img_4.png](img_4.png)

You can repeat this process for any PHP version you want. 
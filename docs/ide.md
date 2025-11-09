---
sidebar_position: 6
---

# Using the Image in Your IDE

You don't need PHP installed locally to get full IDE support. Use the ByJG Docker PHP images to get:

- Code completion and IntelliSense
- XDebug debugging
- PHPUnit test running
- Multiple PHP versions without conflicts

## PHPStorm / IntelliJ IDEA

### Setup Instructions

#### Step 1: Open CLI Interpreter Settings

Navigate to **File → Settings → Languages & Frameworks → PHP**

Click the **ellipsis (...)** beside the "CLI Interpreter" field.

![PHPStorm Settings](img.png)

#### Step 2: Add Docker-based Interpreter

Click **Add (+) → From Docker, Vagrant, VM, WSL...**

![Add Interpreter](img_1.png)

#### Step 3: Configure Docker Image

1. Select your Docker server (or create one with **New**)
2. Choose **Docker** as the remote type
3. Enter the image name: `byjg/php:8.3-cli` (or your preferred version)
4. Click **OK**

![Configure Image](img_2.png)

:::tip
Make sure Docker is running and properly configured in PHPStorm before proceeding.
:::

#### Step 4: Verify Configuration

You should see:
- PHP version detected
- XDebug extension loaded
- Other installed extensions

**Optional:** Uncheck "Visible only for this project" to use this interpreter across all projects.

![Verify Configuration](img_3.png)

#### Step 5: Select Interpreter for Your Project

Back in the PHP settings, select your newly created interpreter from the dropdown.

![Select Interpreter](img_4.png)

### Features Available

With this setup, you get:

✅ **Code Completion** - Full IntelliSense for PHP functions and classes
✅ **XDebug Integration** - Set breakpoints and debug your code
✅ **PHPUnit Support** - Run and debug tests directly from IDE
✅ **Code Inspections** - Real-time code quality checks
✅ **Multiple PHP Versions** - Switch between PHP versions per project

### Using Multiple PHP Versions

Repeat the setup process for each PHP version you need:

```
byjg/php:8.3-cli
byjg/php:8.2-cli
byjg/php:7.4-cli
```

Then switch between them in your project settings as needed.

## VS Code

For VS Code setup with these Docker images, see the [official PHP Docker extension documentation](https://marketplace.visualstudio.com/items?itemName=zobo.php-intellisense). 
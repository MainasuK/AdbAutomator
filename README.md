# AdbAutomator

Swift Adb command line client. 

```shell
$ adb --version
Android Debug Bridge version 1.0.41
Version 29.0.6-6198805
Installed as /usr/local/bin/adb
```

## Usage 
This wrapper use `Foundation.Process` to spawn a new process to drive the adb. Please check the [Adb.swift](./Sources/AdbAutomator/Adb.swift) to learn more details. 
# ace-shared-classes
Examples of using ACE shared classes with independent servers

## Components

The DemoApplication relies on a class called [demo.shared.java.ClassThatMustBeShared](SharedJava/src/demo/shared/java/ClassThatMustBeShared.java)
being available to it when it calls Class.forName() during flow operation, and as the name implies the class will only 
load in the shared classloader of an ACE server. This simulates scenarios where a Java class must be shared across a 
whole server in order to enable process-wide data caching or for other reasons.

[ClassThatMustBeShared](SharedJava/src/demo/shared/java/ClassThatMustBeShared.java) resides in the [SharedJava](SharedJava) 
project and is packaged in several ways to allow for different solutions:

- [SharedJavaLibrary](SharedJavaLibrary) is an ACE shared library that includes SharedJava
- [SharedJava.jar](SharedJava.jar) is a standard Java JAR file that can be copied into the shared-classes directory manually
- [SharedJava-configuration.zip](SharedJava-configuration.zip) is a ZIP file containing SharedJava.jar for use with CP4i

The following scenarios illustrate how these three options can be used.

## ACE local build

```
git clone https://github.com/trevor-dolby-at-ibm-com/ace-shared-classes.git
mqsicreateworkdir /tmp/ace-shared-classes-work-dir
ibmint deploy --input-path ace-shared-classes --output-work-directory /tmp/ace-shared-classes-work-dir --project DemoApplicationJava --project DemoApplication
mkdir /tmp/ace-shared-classes-work-dir/shared-classes
cp ace-shared-classes/SharedJava.jar /tmp/ace-shared-classes-work-dir/shared-classes
```

`IntegrationServer -w /tmp/ace-shared-classes-work-dir` shows
```
2022-10-28 14:29:42.771344: BIP1990I: Integration server 'ace-shared-classes-work-dir' starting initialization; version '12.0.6.0' (64-bit)
2022-10-28 14:29:42.781144: BIP9905I: Initializing resource managers.
2022-10-28 14:29:45.316572: BIP9906I: Reading deployed resources.
2022-10-28 14:29:45.319712: BIP9907I: Initializing deployed resources.
2022-10-28 14:29:45.322396: BIP2155I: About to 'Initialize' the deployed resource 'DemoApplication' of type 'Application'.
2022-10-28 14:29:45.626800: BIP2155I: About to 'Start' the deployed resource 'DemoApplication' of type 'Application'.
2022-10-28 14:29:45.629024: BIP2269I: Deployed resource 'TimerFlow' (uuid='TimerFlow',type='MessageFlow') started successfully.
2022-10-28 14:29:45.637     48
2022-10-28 14:29:45.639     48 ClassThatMustBeShared loaded with correct classloader: com.ibm.broker.classloading.SharedClassLoader
2022-10-28 14:29:45.639     48
2022-10-28 14:29:45.640     48 Hello from ClassThatMustBeShared!
2022-10-28 14:29:45.870960: BIP2866I: IBM App Connect Enterprise administration security is inactive.
2022-10-28 14:29:45.877184: BIP3132I: The HTTP Listener has started listening on port '7600' for 'RestAdmin http' connections.
2022-10-28 14:29:45.882848: BIP1991I: Integration server has finished initialization.
2022-10-28 14:29:50.651     48 Hello from ClassThatMustBeShared!
2022-10-28 14:29:55.660     48 Hello from ClassThatMustBeShared!
```


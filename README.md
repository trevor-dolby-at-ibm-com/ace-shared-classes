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

## ACE local build with server.conf.yaml

```
git clone https://github.com/trevor-dolby-at-ibm-com/ace-shared-classes.git
mqsicreateworkdir /tmp/ace-shared-classes-work-dir
ibmint deploy --input-path ace-shared-classes --output-work-directory /tmp/ace-shared-classes-work-dir --project DemoApplicationJava --project DemoApplication
echo "additionalSharedClassesDirectories: '$PWD/ace-shared-classes'" >> /tmp/ace-shared-classes-work-dir/server.conf.yaml
```

`IntegrationServer -w /tmp/ace-shared-classes-work-dir` shows
```
2022-10-31 12:14:15.739106: BIP1990I: Integration server 'ace-shared-classes-work-dir' starting initialization; version '12.0.7.0' (64-bit)
2022-10-31 12:14:15.748438: BIP9905I: Initializing resource managers.
2022-10-31 12:14:18.330068: BIP9906I: Reading deployed resources.
2022-10-31 12:14:18.333194: BIP9907I: Initializing deployed resources.
2022-10-31 12:14:18.336440: BIP2155I: About to 'Initialize' the deployed resource 'DemoApplication' of type 'Application'.
2022-10-31 12:14:18.641088: BIP2155I: About to 'Start' the deployed resource 'DemoApplication' of type 'Application'.
2022-10-31 12:14:18.643352: BIP2269I: Deployed resource 'TimerFlow' (uuid='TimerFlow',type='MessageFlow') started successfully.
2022-10-31 12:14:18.650     48
2022-10-31 12:14:18.652     48 ClassThatMustBeShared loaded with correct classloader: com.ibm.broker.classloading.SharedClassLoader
2022-10-31 12:14:18.652     48
2022-10-31 12:14:18.653     48 Hello from ClassThatMustBeShared!
2022-10-31 12:14:18.988936: BIP2866I: IBM App Connect Enterprise administration security is inactive.
2022-10-31 12:14:18.995642: BIP3132I: The HTTP Listener has started listening on port '7600' for 'RestAdmin http' connections.
2022-10-31 12:14:19.001164: BIP1991I: Integration server has finished initialization.
2022-10-31 12:14:23.663     48 Hello from ClassThatMustBeShared!
2022-10-31 12:14:28.672     48 Hello from ClassThatMustBeShared!
```

## Container build

The local build approach will also work in a Dockerfile, with appropriate adjustments for work directory names and so on.
Containers built this way will have the SharedJava JAR already in place for the server to pick up, and so no further 
configuration is needed.

See [Dockerfile](Dockerfile) for details; to build the image, run
```
docker build -t ace-shared-classes .
```
and then to run the image locally
```
$  docker run -e LICENSE=accept --rm -ti ace-shared-classes:latest
2022-10-28 20:33:39.278992: BIP1990I: Integration server 'ace-server' starting initialization; version '12.0.6.0' (64-bit) 
2022-10-28 20:33:39.296112: BIP9905I: Initializing resource managers. 
2022-10-28 20:33:47.176212: BIP9906I: Reading deployed resources. 
2022-10-28 20:33:47.186588: BIP9907I: Initializing deployed resources. 
2022-10-28 20:33:47.198916: BIP2155I: About to 'Initialize' the deployed resource 'DemoApplication' of type 'Application'. 
2022-10-28 20:33:47.712512: BIP2155I: About to 'Start' the deployed resource 'DemoApplication' of type 'Application'. 
2022-10-28 20:33:47.713152: BIP2269I: Deployed resource 'TimerFlow' (uuid='TimerFlow',type='MessageFlow') started successfully. 
2022-10-28 20:33:47.753     47 
2022-10-28 20:33:47.767     47 ClassThatMustBeShared loaded with correct classloader: com.ibm.broker.classloading.SharedClassLoader
2022-10-28 20:33:47.769     47 
2022-10-28 20:33:47.778     47 Hello from ClassThatMustBeShared!
2022-10-28 20:33:49.027304: BIP2866I: IBM App Connect Enterprise administration security is inactive. 
2022-10-28 20:33:49.061516: BIP3132I: The HTTP Listener has started listening on port '7600' for 'RestAdmin http' connections. 
2022-10-28 20:33:49.096320: BIP1991I: Integration server has finished initialization. 
2022-10-28 20:33:52.795     47 Hello from ClassThatMustBeShared!
2022-10-28 20:33:57.807     47 Hello from ClassThatMustBeShared!
```
or the image can be tagged and pushed to a registry and then run in a container environment such as Kubernetes.

This approach will also work for CP4i custom containers using /home/aceuser/ace-server as the work directory into which
the BAR is deployed and SharedJava JAR is copied.

## CP4i configuration with SharedJava in the BAR file

```
additionalSharedClassesDirectories: '{SharedJavaLibrary}'
```

Use DemoApplication/DemoApplicationWithSharedJavaLibrary.bar as the application, and the server should start up and print the "Hello" lines
as expected:
```
2022-10-28 19:52:22.258844: BIP9906I: Reading deployed resources.
2022-10-28 19:52:22.269136: BIP9907I: Initializing deployed resources.
2022-10-28 19:52:22.269514: BIP8099I: Shared library used for plugins: SharedJavaLibrary - will not be available to applications
2022-10-28 19:52:22.344920: BIP2155I: About to 'Initialize' the deployed resource 'DemoApplication' of type 'Application'.
2022-10-28T19:52:22.542Z Integration server not ready yet
2022-10-28 19:52:24.153262: BIP2155I: About to 'Start' the deployed resource 'DemoApplication' of type 'Application'.
2022-10-28 19:52:24.153938: BIP2269I: Deployed resource 'TimerFlow' (uuid='TimerFlow',type='MessageFlow') started successfully.
2022-10-28 19:52:26.246 26
2022-10-28 19:52:26.351 26 ClassThatMustBeShared loaded with correct classloader: com.ibm.broker.classloading.SharedClassLoader
2022-10-28 19:52:26.442 26
2022-10-28 19:52:26.446 26 Hello from ClassThatMustBeShared!
2022-10-28T19:52:27.551Z Integration server not ready yet
2022-10-28 19:52:29.542 26 Hello from ClassThatMustBeShared!
2022-10-28 19:52:31.653796: BIP2866I: IBM App Connect Enterprise administration security is authentication, authorization file.
2022-10-28 19:52:31.842192: BIP3132I: The HTTP Listener has started listening on port '7600' for 'RestAdmin http' connections.
2022-10-28 19:52:31.845558: BIP1991I: Integration server has finished initialization.
```

## CP4i configuration with SharedJava JAR file in a generic files configuration

Create a "generic files" configuration containing SharedJava-configuration.zip and also a server.conf.yaml configuration
containg the additionalSharedClassesDirectories setting:
```
additionalSharedClassesDirectories: '/home/aceuser/generic/extra-classes'
```

Use DemoApplication/DemoApplication.bar as the application, and the server should start up and print the "Hello" lines
as expected:
```
2022-10-28 19:46:46.842152: BIP9906I: Reading deployed resources.
2022-10-28 19:46:46.846716: BIP9907I: Initializing deployed resources.
2022-10-28 19:46:46.848556: BIP2155I: About to 'Initialize' the deployed resource 'DemoApplication' of type 'Application'.
2022-10-28 19:46:48.709208: BIP2155I: About to 'Start' the deployed resource 'DemoApplication' of type 'Application'.
2022-10-28 19:46:48.751304: BIP2269I: Deployed resource 'TimerFlow' (uuid='TimerFlow',type='MessageFlow') started successfully.
2022-10-28 19:46:49.350 25
2022-10-28 19:46:49.356 25 ClassThatMustBeShared loaded with correct classloader: com.ibm.broker.classloading.SharedClassLoader
2022-10-28 19:46:49.356 25
2022-10-28 19:46:49.443 25 Hello from ClassThatMustBeShared!
2022-10-28T19:46:51.271Z Integration server not ready yet
2022-10-28 19:46:53.956 25 Hello from ClassThatMustBeShared!
2022-10-28T19:46:56.346Z Integration server not ready yet
2022-10-28 19:46:56.456368: BIP2866I: IBM App Connect Enterprise administration security is authentication, authorization file.
2022-10-28 19:46:56.652188: BIP3132I: The HTTP Listener has started listening on port '7600' for 'RestAdmin http' connections.
2022-10-28 19:46:56.656252: BIP1991I: Integration server has finished initialization.
2022-10-28 19:46:59.047 25 Hello from ClassThatMustBeShared!
2022-10-28T19:47:01.354Z Integration server is ready
```


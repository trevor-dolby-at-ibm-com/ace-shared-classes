// Copyright (c) 2022 Open Technologies for Integration
// Licensed under the MIT license (see LICENSE for details)

package demo.shared.java;

public class ClassThatMustBeShared
{
	//! This code block forces the class to be loaded with the shared classloader to simulate
	//! a scenario where the JAR needs to be shared; actual scenarios might include Java static
	//! variables used for caching data or connections across the whole server.
	static
	{
		String classloaderName = ClassThatMustBeShared.class.getClassLoader().getClass().getCanonicalName();
		if ( classloaderName.equals("com.ibm.broker.classloading.SharedClassLoader") )
		{
			System.out.println("");
			System.out.println("ClassThatMustBeShared loaded with correct classloader: "+classloaderName);
			System.out.println("");
		}
		else
		{
			System.out.println("");
			System.out.println("ClassThatMustBeShared must be loaded with the SharedClassloader");
			System.out.println("Actual classloader: "+classloaderName);
			System.out.println("Throwing RuntimeException . . .");
			System.out.println("");
			throw new RuntimeException("Wrong classloader used for ClassThatMustBeShared");
		}

	}
	
	//! Method that shows the class has been loaded and is usable
	public static void printHello()
	{
		System.out.println("Hello from ClassThatMustBeShared!");
	}
}

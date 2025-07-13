vous dites que j'obtiens des erreurs avec mvn clean install -U car y'avais un
point "." à la fin du coup je l'ai refait et voici ce que j'ai obtenu avec l'
erreur de syntaxe "." à la fin enlevé :
 at org.mockito.internal.util.MockUtil.createMock(MockUtil.java:99)
        at org.mockito.internal.MockitoCore.mock(MockitoCore.java:84)
        at org.mockito.Mockito.mock(Mockito.java:2104)
        at org.mockito.internal.configuration.MockAnnotationProcessor.processAnnotationForMock(MockAnnotationProcessor.java:79)
        at org.mockito.internal.configuration.MockAnnotationProcessor.process(MockAnnotationProcessor.java:28)
        at org.mockito.internal.configuration.MockAnnotationProcessor.process(MockAnnotationProcessor.java:25)
        at org.mockito.internal.configuration.IndependentAnnotationEngine.createMockFor(IndependentAnnotationEngine.java:44)
        at org.mockito.internal.configuration.IndependentAnnotationEngine.process(IndependentAnnotationEngine.java:72)
        at org.mockito.internal.configuration.InjectingAnnotationEngine.processIndependentAnnotations(InjectingAnnotationEngine.java:62)
        at org.mockito.internal.configuration.InjectingAnnotationEngine.process(InjectingAnnotationEngine.java:47)
        at org.mockito.MockitoAnnotations.openMocks(MockitoAnnotations.java:81)     
        ... 74 more
Caused by: java.lang.IllegalArgumentException: Java 21 (65) is not supported by the current version of Byte Buddy which officially supports Java 20 (64) - update Byte Buddy or set net.bytebuddy.experimental as a VM property
        at net.bytebuddy.utility.OpenedClassReader.of(OpenedClassReader.java:96)    
        at net.bytebuddy.dynamic.scaffold.TypeWriter$Default$ForInlining.create(TypeWriter.java:4011)
        at net.bytebuddy.dynamic.scaffold.TypeWriter$Default.make(TypeWriter.java:2224)
        at net.bytebuddy.dynamic.DynamicType$Builder$AbstractBase$UsingTypeWriter.make(DynamicType.java:4050)
        at net.bytebuddy.dynamic.DynamicType$Builder$AbstractBase.make(DynamicType.java:3734)
        at org.mockito.internal.creation.bytebuddy.InlineBytecodeGenerator.transform(InlineBytecodeGenerator.java:402)
        at java.instrument/java.lang.instrument.ClassFileTransformer.transform(ClassFileTransformer.java:244)
        at java.instrument/sun.instrument.TransformerManager.transform(TransformerManager.java:188)
        at java.instrument/sun.instrument.InstrumentationImpl.transform(InstrumentationImpl.java:610)
        at java.instrument/sun.instrument.InstrumentationImpl.retransformClasses0(Native Method)
        at java.instrument/sun.instrument.InstrumentationImpl.retransformClasses(InstrumentationImpl.java:225)
        at org.mockito.internal.creation.bytebuddy.InlineBytecodeGenerator.triggerRetransformation(InlineBytecodeGenerator.java:281)
        ... 96 more

[ERROR] com.biblio.service.PretServiceTest.testPreterExemplaireSuccess -- Time elapsed: 0.056 s <<< ERROR!
org.mockito.exceptions.base.MockitoException:

Mockito cannot mock this class: interface com.biblio.repository.AdherentRepository. 

If you're not sure why you're getting this error, please open an issue on GitHub.   


Java               : 21
JVM vendor name    : Eclipse Adoptium
JVM vendor version : 21.0.7+6-LTS
JVM name           : OpenJDK 64-Bit Server VM
JVM version        : 21.0.7+6-LTS
JVM info           : mixed mode, sharing
OS name            : Windows 11
OS version         : 10.0


You are seeing this disclaimer because Mockito is configured to create inlined mocks.
You can learn about inline mocks and their limitations under item #39 of the Mockito class javadoc.

Underlying exception : org.mockito.exceptions.base.MockitoException: Could not modify all classes [interface org.springframework.data.jpa.repository.JpaRepository, interface org.springframework.data.repository.Repository, interface org.springframework.data.repository.query.QueryByExampleExecutor, interface org.springframework.data.repository.PagingAndSortingRepository, interface org.springframework.data.repository.CrudRepository, interface com.biblio.repository.AdherentRepository]
        at com.biblio.service.PretServiceTest.setUp(PretServiceTest.java:56)        
        at java.base/jdk.internal.reflect.DirectMethodHandleAccessor.invoke(DirectMethodHandleAccessor.java:103)
        at java.base/java.lang.reflect.Method.invoke(Method.java:580)
        at org.junit.platform.commons.util.ReflectionUtils.invokeMethod(ReflectionUtils.java:725)
        at org.junit.jupiter.engine.execution.MethodInvocation.proceed(MethodInvocation.java:60)
        at org.junit.jupiter.engine.execution.InvocationInterceptorChain$ValidatingInvocation.proceed(InvocationInterceptorChain.java:131)
        at org.junit.jupiter.engine.extension.TimeoutExtension.intercept(TimeoutExtension.java:149)
        at org.junit.jupiter.engine.extension.TimeoutExtension.interceptLifecycleMethod(TimeoutExtension.java:126)
        at org.junit.jupiter.engine.extension.TimeoutExtension.interceptBeforeEachMethod(TimeoutExtension.java:76)
        at org.junit.jupiter.engine.execution.ExecutableInvoker$ReflectiveInterceptorCall.lambda$ofVoidMethod$0(ExecutableInvoker.java:115)
        at org.junit.jupiter.engine.execution.ExecutableInvoker.lambda$invoke$0(ExecutableInvoker.java:105)
        at org.junit.jupiter.engine.execution.InvocationInterceptorChain$InterceptedInvocation.proceed(InvocationInterceptorChain.java:106)
        at org.junit.jupiter.engine.execution.InvocationInterceptorChain.proceed(InvocationInterceptorChain.java:64)
        at org.junit.jupiter.engine.execution.InvocationInterceptorChain.chainAndInvoke(InvocationInterceptorChain.java:45)
        at org.junit.jupiter.engine.execution.InvocationInterceptorChain.invoke(InvocationInterceptorChain.java:37)
        at org.junit.jupiter.engine.execution.ExecutableInvoker.invoke(ExecutableInvoker.java:104)
        at org.junit.jupiter.engine.execution.ExecutableInvoker.invoke(ExecutableInvoker.java:98)
        at org.junit.jupiter.engine.descriptor.ClassBasedTestDescriptor.invokeMethodInExtensionContext(ClassBasedTestDescriptor.java:506)
        at org.junit.jupiter.engine.descriptor.ClassBasedTestDescriptor.lambda$synthesizeBeforeEachMethodAdapter$21(ClassBasedTestDescriptor.java:491)
        at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.lambda$invokeBeforeEachMethods$3(TestMethodTestDescriptor.java:171)
        at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.lambda$invokeBeforeMethodsOrCallbacksUntilExceptionOccurs$6(TestMethodTestDescriptor.java:199)  
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.invokeBeforeMethodsOrCallbacksUntilExceptionOccurs(TestMethodTestDescriptor.java:199)
        at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.invokeBeforeEachMethods(TestMethodTestDescriptor.java:168)
        at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.execute(TestMethodTestDescriptor.java:131)
        at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.execute(TestMethodTestDescriptor.java:66)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$6(NodeTestTask.java:151)
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$8(NodeTestTask.java:141)
        at org.junit.platform.engine.support.hierarchical.Node.around(Node.java:137)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$9(NodeTestTask.java:139)
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.executeRecursively(NodeTestTask.java:138)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.execute(NodeTestTask.java:95)
        at java.base/java.util.ArrayList.forEach(ArrayList.java:1596)
        at org.junit.platform.engine.support.hierarchical.SameThreadHierarchicalTestExecutorService.invokeAll(SameThreadHierarchicalTestExecutorService.java:41)        
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$6(NodeTestTask.java:155)
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$8(NodeTestTask.java:141)
        at org.junit.platform.engine.support.hierarchical.Node.around(Node.java:137)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$9(NodeTestTask.java:139)
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.executeRecursively(NodeTestTask.java:138)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.execute(NodeTestTask.java:95)
        at java.base/java.util.ArrayList.forEach(ArrayList.java:1596)
        at org.junit.platform.engine.support.hierarchical.SameThreadHierarchicalTestExecutorService.invokeAll(SameThreadHierarchicalTestExecutorService.java:41)        
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$6(NodeTestTask.java:155)
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$8(NodeTestTask.java:141)
        at org.junit.platform.engine.support.hierarchical.Node.around(Node.java:137)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$9(NodeTestTask.java:139)
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.executeRecursively(NodeTestTask.java:138)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.execute(NodeTestTask.java:95)
        at org.junit.platform.engine.support.hierarchical.SameThreadHierarchicalTestExecutorService.submit(SameThreadHierarchicalTestExecutorService.java:35)
        at org.junit.platform.engine.support.hierarchical.HierarchicalTestExecutor.execute(HierarchicalTestExecutor.java:57)
        at org.junit.platform.engine.support.hierarchical.HierarchicalTestEngine.execute(HierarchicalTestEngine.java:54)
        at org.junit.platform.launcher.core.EngineExecutionOrchestrator.execute(EngineExecutionOrchestrator.java:147)
        at org.junit.platform.launcher.core.EngineExecutionOrchestrator.execute(EngineExecutionOrchestrator.java:127)
        at org.junit.platform.launcher.core.EngineExecutionOrchestrator.execute(EngineExecutionOrchestrator.java:90)
        at org.junit.platform.launcher.core.EngineExecutionOrchestrator.lambda$execute$0(EngineExecutionOrchestrator.java:55)
        at org.junit.platform.launcher.core.EngineExecutionOrchestrator.withInterceptedStreams(EngineExecutionOrchestrator.java:102)
        at org.junit.platform.launcher.core.EngineExecutionOrchestrator.execute(EngineExecutionOrchestrator.java:54)
        at org.junit.platform.launcher.core.DefaultLauncher.execute(DefaultLauncher.java:114)
        at org.junit.platform.launcher.core.DefaultLauncher.execute(DefaultLauncher.java:86)
        at org.junit.platform.launcher.core.DefaultLauncherSession$DelegatingLauncher.execute(DefaultLauncherSession.java:86)
        at org.apache.maven.surefire.junitplatform.LazyLauncher.execute(LazyLauncher.java:56)
        at org.apache.maven.surefire.junitplatform.JUnitPlatformProvider.execute(JUnitPlatformProvider.java:184)
        at org.apache.maven.surefire.junitplatform.JUnitPlatformProvider.invokeAllTests(JUnitPlatformProvider.java:148)
        at org.apache.maven.surefire.junitplatform.JUnitPlatformProvider.invoke(JUnitPlatformProvider.java:122)
        at org.apache.maven.surefire.booter.ForkedBooter.runSuitesInProcess(ForkedBooter.java:385)
        at org.apache.maven.surefire.booter.ForkedBooter.execute(ForkedBooter.java:162)
        at org.apache.maven.surefire.booter.ForkedBooter.run(ForkedBooter.java:507) 
        at org.apache.maven.surefire.booter.ForkedBooter.main(ForkedBooter.java:495)
Caused by: org.mockito.exceptions.base.MockitoException: Could not modify all classes [interface org.springframework.data.jpa.repository.JpaRepository, interface org.springframework.data.repository.Repository, interface org.springframework.data.repository.query.QueryByExampleExecutor, interface org.springframework.data.repository.PagingAndSortingRepository, interface org.springframework.data.repository.CrudRepository, interface com.biblio.repository.AdherentRepository]
        at net.bytebuddy.TypeCache.findOrInsert(TypeCache.java:168)
        at net.bytebuddy.TypeCache$WithInlineExpunction.findOrInsert(TypeCache.java:399)
        at net.bytebuddy.TypeCache.findOrInsert(TypeCache.java:190)
        at net.bytebuddy.TypeCache$WithInlineExpunction.findOrInsert(TypeCache.java:410)
        ... 74 more
Caused by: java.lang.IllegalStateException:
Byte Buddy could not instrument all classes within the mock's type hierarchy        

This problem should never occur for javac-compiled classes. This problem has been observed for classes that are:
 - Compiled by older versions of scalac
 - Classes that are part of the Android distribution
        at org.mockito.internal.creation.bytebuddy.InlineBytecodeGenerator.triggerRetransformation(InlineBytecodeGenerator.java:285)
        at org.mockito.internal.creation.bytebuddy.InlineBytecodeGenerator.mockClass(InlineBytecodeGenerator.java:218)
        at org.mockito.internal.creation.bytebuddy.TypeCachingBytecodeGenerator.lambda$mockClass$0(TypeCachingBytecodeGenerator.java:78)
        at net.bytebuddy.TypeCache.findOrInsert(TypeCache.java:168)
        at net.bytebuddy.TypeCache$WithInlineExpunction.findOrInsert(TypeCache.java:399)
        at net.bytebuddy.TypeCache.findOrInsert(TypeCache.java:190)
        at net.bytebuddy.TypeCache$WithInlineExpunction.findOrInsert(TypeCache.java:410)
        at org.mockito.internal.creation.bytebuddy.TypeCachingBytecodeGenerator.mockClass(TypeCachingBytecodeGenerator.java:75)
        at org.mockito.internal.creation.bytebuddy.InlineDelegateByteBuddyMockMaker.createMockType(InlineDelegateByteBuddyMockMaker.java:414)
        at org.mockito.internal.creation.bytebuddy.InlineDelegateByteBuddyMockMaker.doCreateMock(InlineDelegateByteBuddyMockMaker.java:373)
        at org.mockito.internal.creation.bytebuddy.InlineDelegateByteBuddyMockMaker.createMock(InlineDelegateByteBuddyMockMaker.java:352)
        at org.mockito.internal.creation.bytebuddy.InlineByteBuddyMockMaker.createMock(InlineByteBuddyMockMaker.java:56)
        at org.mockito.internal.util.MockUtil.createMock(MockUtil.java:99)
        at org.mockito.internal.MockitoCore.mock(MockitoCore.java:84)
        at org.mockito.Mockito.mock(Mockito.java:2104)
        at org.mockito.internal.configuration.MockAnnotationProcessor.processAnnotationForMock(MockAnnotationProcessor.java:79)
        at org.mockito.internal.configuration.MockAnnotationProcessor.process(MockAnnotationProcessor.java:28)
        at org.mockito.internal.configuration.MockAnnotationProcessor.process(MockAnnotationProcessor.java:25)
        at org.mockito.internal.configuration.IndependentAnnotationEngine.createMockFor(IndependentAnnotationEngine.java:44)
        at org.mockito.internal.configuration.IndependentAnnotationEngine.process(IndependentAnnotationEngine.java:72)
        at org.mockito.internal.configuration.InjectingAnnotationEngine.processIndependentAnnotations(InjectingAnnotationEngine.java:62)
        at org.mockito.internal.configuration.InjectingAnnotationEngine.process(InjectingAnnotationEngine.java:47)
        at org.mockito.MockitoAnnotations.openMocks(MockitoAnnotations.java:81)     
        ... 74 more
Caused by: java.lang.IllegalArgumentException: Java 21 (65) is not supported by the current version of Byte Buddy which officially supports Java 20 (64) - update Byte Buddy or set net.bytebuddy.experimental as a VM property
        at net.bytebuddy.utility.OpenedClassReader.of(OpenedClassReader.java:96)    
        at net.bytebuddy.dynamic.scaffold.TypeWriter$Default$ForInlining.create(TypeWriter.java:4011)
        at net.bytebuddy.dynamic.scaffold.TypeWriter$Default.make(TypeWriter.java:2224)
        at net.bytebuddy.dynamic.DynamicType$Builder$AbstractBase$UsingTypeWriter.make(DynamicType.java:4050)
        at net.bytebuddy.dynamic.DynamicType$Builder$AbstractBase.make(DynamicType.java:3734)
        at org.mockito.internal.creation.bytebuddy.InlineBytecodeGenerator.transform(InlineBytecodeGenerator.java:402)
        at java.instrument/java.lang.instrument.ClassFileTransformer.transform(ClassFileTransformer.java:244)
        at java.instrument/sun.instrument.TransformerManager.transform(TransformerManager.java:188)
        at java.instrument/sun.instrument.InstrumentationImpl.transform(InstrumentationImpl.java:610)
        at java.instrument/sun.instrument.InstrumentationImpl.retransformClasses0(Native Method)
        at java.instrument/sun.instrument.InstrumentationImpl.retransformClasses(InstrumentationImpl.java:225)
        at org.mockito.internal.creation.bytebuddy.InlineBytecodeGenerator.triggerRetransformation(InlineBytecodeGenerator.java:281)
        ... 96 more

[ERROR] com.biblio.service.PretServiceTest.testRetournerExemplaireSuccess -- Time elapsed: 0.048 s <<< ERROR!
org.mockito.exceptions.base.MockitoException:

Mockito cannot mock this class: interface com.biblio.repository.AdherentRepository. 

If you're not sure why you're getting this error, please open an issue on GitHub.   


Java               : 21
JVM vendor name    : Eclipse Adoptium
JVM vendor version : 21.0.7+6-LTS
JVM name           : OpenJDK 64-Bit Server VM
JVM version        : 21.0.7+6-LTS
JVM info           : mixed mode, sharing
OS name            : Windows 11
OS version         : 10.0


You are seeing this disclaimer because Mockito is configured to create inlined mocks.
You can learn about inline mocks and their limitations under item #39 of the Mockito class javadoc.

Underlying exception : org.mockito.exceptions.base.MockitoException: Could not modify all classes [interface org.springframework.data.jpa.repository.JpaRepository, interface org.springframework.data.repository.Repository, interface org.springframework.data.repository.query.QueryByExampleExecutor, interface org.springframework.data.repository.PagingAndSortingRepository, interface org.springframework.data.repository.CrudRepository, interface com.biblio.repository.AdherentRepository]
        at com.biblio.service.PretServiceTest.setUp(PretServiceTest.java:56)        
        at java.base/jdk.internal.reflect.DirectMethodHandleAccessor.invoke(DirectMethodHandleAccessor.java:103)
        at java.base/java.lang.reflect.Method.invoke(Method.java:580)
        at org.junit.platform.commons.util.ReflectionUtils.invokeMethod(ReflectionUtils.java:725)
        at org.junit.jupiter.engine.execution.MethodInvocation.proceed(MethodInvocation.java:60)
        at org.junit.jupiter.engine.execution.InvocationInterceptorChain$ValidatingInvocation.proceed(InvocationInterceptorChain.java:131)
        at org.junit.jupiter.engine.extension.TimeoutExtension.intercept(TimeoutExtension.java:149)
        at org.junit.jupiter.engine.extension.TimeoutExtension.interceptLifecycleMethod(TimeoutExtension.java:126)
        at org.junit.jupiter.engine.extension.TimeoutExtension.interceptBeforeEachMethod(TimeoutExtension.java:76)
        at org.junit.jupiter.engine.execution.ExecutableInvoker$ReflectiveInterceptorCall.lambda$ofVoidMethod$0(ExecutableInvoker.java:115)
        at org.junit.jupiter.engine.execution.ExecutableInvoker.lambda$invoke$0(ExecutableInvoker.java:105)
        at org.junit.jupiter.engine.execution.InvocationInterceptorChain$InterceptedInvocation.proceed(InvocationInterceptorChain.java:106)
        at org.junit.jupiter.engine.execution.InvocationInterceptorChain.proceed(InvocationInterceptorChain.java:64)
        at org.junit.jupiter.engine.execution.InvocationInterceptorChain.chainAndInvoke(InvocationInterceptorChain.java:45)
        at org.junit.jupiter.engine.execution.InvocationInterceptorChain.invoke(InvocationInterceptorChain.java:37)
        at org.junit.jupiter.engine.execution.ExecutableInvoker.invoke(ExecutableInvoker.java:104)
        at org.junit.jupiter.engine.execution.ExecutableInvoker.invoke(ExecutableInvoker.java:98)
        at org.junit.jupiter.engine.descriptor.ClassBasedTestDescriptor.invokeMethodInExtensionContext(ClassBasedTestDescriptor.java:506)
        at org.junit.jupiter.engine.descriptor.ClassBasedTestDescriptor.lambda$synthesizeBeforeEachMethodAdapter$21(ClassBasedTestDescriptor.java:491)
        at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.lambda$invokeBeforeEachMethods$3(TestMethodTestDescriptor.java:171)
        at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.lambda$invokeBeforeMethodsOrCallbacksUntilExceptionOccurs$6(TestMethodTestDescriptor.java:199)  
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.invokeBeforeMethodsOrCallbacksUntilExceptionOccurs(TestMethodTestDescriptor.java:199)
        at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.invokeBeforeEachMethods(TestMethodTestDescriptor.java:168)
        at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.execute(TestMethodTestDescriptor.java:131)
        at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.execute(TestMethodTestDescriptor.java:66)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$6(NodeTestTask.java:151)
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$8(NodeTestTask.java:141)
        at org.junit.platform.engine.support.hierarchical.Node.around(Node.java:137)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$9(NodeTestTask.java:139)
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.executeRecursively(NodeTestTask.java:138)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.execute(NodeTestTask.java:95)
        at java.base/java.util.ArrayList.forEach(ArrayList.java:1596)
        at org.junit.platform.engine.support.hierarchical.SameThreadHierarchicalTestExecutorService.invokeAll(SameThreadHierarchicalTestExecutorService.java:41)        
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$6(NodeTestTask.java:155)
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$8(NodeTestTask.java:141)
        at org.junit.platform.engine.support.hierarchical.Node.around(Node.java:137)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$9(NodeTestTask.java:139)
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.executeRecursively(NodeTestTask.java:138)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.execute(NodeTestTask.java:95)
        at java.base/java.util.ArrayList.forEach(ArrayList.java:1596)
        at org.junit.platform.engine.support.hierarchical.SameThreadHierarchicalTestExecutorService.invokeAll(SameThreadHierarchicalTestExecutorService.java:41)        
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$6(NodeTestTask.java:155)
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$8(NodeTestTask.java:141)
        at org.junit.platform.engine.support.hierarchical.Node.around(Node.java:137)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$9(NodeTestTask.java:139)
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.executeRecursively(NodeTestTask.java:138)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.execute(NodeTestTask.java:95)
        at org.junit.platform.engine.support.hierarchical.SameThreadHierarchicalTestExecutorService.submit(SameThreadHierarchicalTestExecutorService.java:35)
        at org.junit.platform.engine.support.hierarchical.HierarchicalTestExecutor.execute(HierarchicalTestExecutor.java:57)
        at org.junit.platform.engine.support.hierarchical.HierarchicalTestEngine.execute(HierarchicalTestEngine.java:54)
        at org.junit.platform.launcher.core.EngineExecutionOrchestrator.execute(EngineExecutionOrchestrator.java:147)
        at org.junit.platform.launcher.core.EngineExecutionOrchestrator.execute(EngineExecutionOrchestrator.java:127)
        at org.junit.platform.launcher.core.EngineExecutionOrchestrator.execute(EngineExecutionOrchestrator.java:90)
        at org.junit.platform.launcher.core.EngineExecutionOrchestrator.lambda$execute$0(EngineExecutionOrchestrator.java:55)
        at org.junit.platform.launcher.core.EngineExecutionOrchestrator.withInterceptedStreams(EngineExecutionOrchestrator.java:102)
        at org.junit.platform.launcher.core.EngineExecutionOrchestrator.execute(EngineExecutionOrchestrator.java:54)
        at org.junit.platform.launcher.core.DefaultLauncher.execute(DefaultLauncher.java:114)
        at org.junit.platform.launcher.core.DefaultLauncher.execute(DefaultLauncher.java:86)
        at org.junit.platform.launcher.core.DefaultLauncherSession$DelegatingLauncher.execute(DefaultLauncherSession.java:86)
        at org.apache.maven.surefire.junitplatform.LazyLauncher.execute(LazyLauncher.java:56)
        at org.apache.maven.surefire.junitplatform.JUnitPlatformProvider.execute(JUnitPlatformProvider.java:184)
        at org.apache.maven.surefire.junitplatform.JUnitPlatformProvider.invokeAllTests(JUnitPlatformProvider.java:148)
        at org.apache.maven.surefire.junitplatform.JUnitPlatformProvider.invoke(JUnitPlatformProvider.java:122)
        at org.apache.maven.surefire.booter.ForkedBooter.runSuitesInProcess(ForkedBooter.java:385)
        at org.apache.maven.surefire.booter.ForkedBooter.execute(ForkedBooter.java:162)
        at org.apache.maven.surefire.booter.ForkedBooter.run(ForkedBooter.java:507) 
        at org.apache.maven.surefire.booter.ForkedBooter.main(ForkedBooter.java:495)
Caused by: org.mockito.exceptions.base.MockitoException: Could not modify all classes [interface org.springframework.data.jpa.repository.JpaRepository, interface org.springframework.data.repository.Repository, interface org.springframework.data.repository.query.QueryByExampleExecutor, interface org.springframework.data.repository.PagingAndSortingRepository, interface org.springframework.data.repository.CrudRepository, interface com.biblio.repository.AdherentRepository]
        at net.bytebuddy.TypeCache.findOrInsert(TypeCache.java:168)
        at net.bytebuddy.TypeCache$WithInlineExpunction.findOrInsert(TypeCache.java:399)
        at net.bytebuddy.TypeCache.findOrInsert(TypeCache.java:190)
        at net.bytebuddy.TypeCache$WithInlineExpunction.findOrInsert(TypeCache.java:410)
        ... 74 more
Caused by: java.lang.IllegalStateException:
Byte Buddy could not instrument all classes within the mock's type hierarchy        

This problem should never occur for javac-compiled classes. This problem has been observed for classes that are:
 - Compiled by older versions of scalac
 - Classes that are part of the Android distribution
        at org.mockito.internal.creation.bytebuddy.InlineBytecodeGenerator.triggerRetransformation(InlineBytecodeGenerator.java:285)
        at org.mockito.internal.creation.bytebuddy.InlineBytecodeGenerator.mockClass(InlineBytecodeGenerator.java:218)
        at org.mockito.internal.creation.bytebuddy.TypeCachingBytecodeGenerator.lambda$mockClass$0(TypeCachingBytecodeGenerator.java:78)
        at net.bytebuddy.TypeCache.findOrInsert(TypeCache.java:168)
        at net.bytebuddy.TypeCache$WithInlineExpunction.findOrInsert(TypeCache.java:399)
        at net.bytebuddy.TypeCache.findOrInsert(TypeCache.java:190)
        at net.bytebuddy.TypeCache$WithInlineExpunction.findOrInsert(TypeCache.java:410)
        at org.mockito.internal.creation.bytebuddy.TypeCachingBytecodeGenerator.mockClass(TypeCachingBytecodeGenerator.java:75)
        at org.mockito.internal.creation.bytebuddy.InlineDelegateByteBuddyMockMaker.createMockType(InlineDelegateByteBuddyMockMaker.java:414)
        at org.mockito.internal.creation.bytebuddy.InlineDelegateByteBuddyMockMaker.doCreateMock(InlineDelegateByteBuddyMockMaker.java:373)
        at org.mockito.internal.creation.bytebuddy.InlineDelegateByteBuddyMockMaker.createMock(InlineDelegateByteBuddyMockMaker.java:352)
        at org.mockito.internal.creation.bytebuddy.InlineByteBuddyMockMaker.createMock(InlineByteBuddyMockMaker.java:56)
        at org.mockito.internal.util.MockUtil.createMock(MockUtil.java:99)
        at org.mockito.internal.MockitoCore.mock(MockitoCore.java:84)
        at org.mockito.Mockito.mock(Mockito.java:2104)
        at org.mockito.internal.configuration.MockAnnotationProcessor.processAnnotationForMock(MockAnnotationProcessor.java:79)
        at org.mockito.internal.configuration.MockAnnotationProcessor.process(MockAnnotationProcessor.java:28)
        at org.mockito.internal.configuration.MockAnnotationProcessor.process(MockAnnotationProcessor.java:25)
        at org.mockito.internal.configuration.IndependentAnnotationEngine.createMockFor(IndependentAnnotationEngine.java:44)
        at org.mockito.internal.configuration.IndependentAnnotationEngine.process(IndependentAnnotationEngine.java:72)
        at org.mockito.internal.configuration.InjectingAnnotationEngine.processIndependentAnnotations(InjectingAnnotationEngine.java:62)
        at org.mockito.internal.configuration.InjectingAnnotationEngine.process(InjectingAnnotationEngine.java:47)
        at org.mockito.MockitoAnnotations.openMocks(MockitoAnnotations.java:81)     
        ... 74 more
Caused by: java.lang.IllegalArgumentException: Java 21 (65) is not supported by the current version of Byte Buddy which officially supports Java 20 (64) - update Byte Buddy or set net.bytebuddy.experimental as a VM property
        at net.bytebuddy.utility.OpenedClassReader.of(OpenedClassReader.java:96)    
        at net.bytebuddy.dynamic.scaffold.TypeWriter$Default$ForInlining.create(TypeWriter.java:4011)
        at net.bytebuddy.dynamic.scaffold.TypeWriter$Default.make(TypeWriter.java:2224)
        at net.bytebuddy.dynamic.DynamicType$Builder$AbstractBase$UsingTypeWriter.make(DynamicType.java:4050)
        at net.bytebuddy.dynamic.DynamicType$Builder$AbstractBase.make(DynamicType.java:3734)
        at org.mockito.internal.creation.bytebuddy.InlineBytecodeGenerator.transform(InlineBytecodeGenerator.java:402)
        at java.instrument/java.lang.instrument.ClassFileTransformer.transform(ClassFileTransformer.java:244)
        at java.instrument/sun.instrument.TransformerManager.transform(TransformerManager.java:188)
        at java.instrument/sun.instrument.InstrumentationImpl.transform(InstrumentationImpl.java:610)
        at java.instrument/sun.instrument.InstrumentationImpl.retransformClasses0(Native Method)
        at java.instrument/sun.instrument.InstrumentationImpl.retransformClasses(InstrumentationImpl.java:225)
        at org.mockito.internal.creation.bytebuddy.InlineBytecodeGenerator.triggerRetransformation(InlineBytecodeGenerator.java:281)
        ... 96 more

[ERROR] com.biblio.service.PretServiceTest.testPreterExemplaireAdherentNonExistant -- Time elapsed: 0.058 s <<< ERROR!
org.mockito.exceptions.base.MockitoException:

Mockito cannot mock this class: interface com.biblio.repository.AdherentRepository. 

If you're not sure why you're getting this error, please open an issue on GitHub.   


Java               : 21
JVM vendor name    : Eclipse Adoptium
JVM vendor version : 21.0.7+6-LTS
JVM name           : OpenJDK 64-Bit Server VM
JVM version        : 21.0.7+6-LTS
JVM info           : mixed mode, sharing
OS name            : Windows 11
OS version         : 10.0


You are seeing this disclaimer because Mockito is configured to create inlined mocks.
You can learn about inline mocks and their limitations under item #39 of the Mockito class javadoc.

Underlying exception : org.mockito.exceptions.base.MockitoException: Could not modify all classes [interface org.springframework.data.jpa.repository.JpaRepository, interface org.springframework.data.repository.Repository, interface org.springframework.data.repository.query.QueryByExampleExecutor, interface org.springframework.data.repository.PagingAndSortingRepository, interface org.springframework.data.repository.CrudRepository, interface com.biblio.repository.AdherentRepository]
        at com.biblio.service.PretServiceTest.setUp(PretServiceTest.java:56)        
        at java.base/jdk.internal.reflect.DirectMethodHandleAccessor.invoke(DirectMethodHandleAccessor.java:103)
        at java.base/java.lang.reflect.Method.invoke(Method.java:580)
        at org.junit.platform.commons.util.ReflectionUtils.invokeMethod(ReflectionUtils.java:725)
        at org.junit.jupiter.engine.execution.MethodInvocation.proceed(MethodInvocation.java:60)
        at org.junit.jupiter.engine.execution.InvocationInterceptorChain$ValidatingInvocation.proceed(InvocationInterceptorChain.java:131)
        at org.junit.jupiter.engine.extension.TimeoutExtension.intercept(TimeoutExtension.java:149)
        at org.junit.jupiter.engine.extension.TimeoutExtension.interceptLifecycleMethod(TimeoutExtension.java:126)
        at org.junit.jupiter.engine.extension.TimeoutExtension.interceptBeforeEachMethod(TimeoutExtension.java:76)
        at org.junit.jupiter.engine.execution.ExecutableInvoker$ReflectiveInterceptorCall.lambda$ofVoidMethod$0(ExecutableInvoker.java:115)
        at org.junit.jupiter.engine.execution.ExecutableInvoker.lambda$invoke$0(ExecutableInvoker.java:105)
        at org.junit.jupiter.engine.execution.InvocationInterceptorChain$InterceptedInvocation.proceed(InvocationInterceptorChain.java:106)
        at org.junit.jupiter.engine.execution.InvocationInterceptorChain.proceed(InvocationInterceptorChain.java:64)
        at org.junit.jupiter.engine.execution.InvocationInterceptorChain.chainAndInvoke(InvocationInterceptorChain.java:45)
        at org.junit.jupiter.engine.execution.InvocationInterceptorChain.invoke(InvocationInterceptorChain.java:37)
        at org.junit.jupiter.engine.execution.ExecutableInvoker.invoke(ExecutableInvoker.java:104)
        at org.junit.jupiter.engine.execution.ExecutableInvoker.invoke(ExecutableInvoker.java:98)
        at org.junit.jupiter.engine.descriptor.ClassBasedTestDescriptor.invokeMethodInExtensionContext(ClassBasedTestDescriptor.java:506)
        at org.junit.jupiter.engine.descriptor.ClassBasedTestDescriptor.lambda$synthesizeBeforeEachMethodAdapter$21(ClassBasedTestDescriptor.java:491)
        at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.lambda$invokeBeforeEachMethods$3(TestMethodTestDescriptor.java:171)
        at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.lambda$invokeBeforeMethodsOrCallbacksUntilExceptionOccurs$6(TestMethodTestDescriptor.java:199)  
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.invokeBeforeMethodsOrCallbacksUntilExceptionOccurs(TestMethodTestDescriptor.java:199)
        at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.invokeBeforeEachMethods(TestMethodTestDescriptor.java:168)
        at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.execute(TestMethodTestDescriptor.java:131)
        at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.execute(TestMethodTestDescriptor.java:66)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$6(NodeTestTask.java:151)
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$8(NodeTestTask.java:141)
        at org.junit.platform.engine.support.hierarchical.Node.around(Node.java:137)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$9(NodeTestTask.java:139)
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.executeRecursively(NodeTestTask.java:138)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.execute(NodeTestTask.java:95)
        at java.base/java.util.ArrayList.forEach(ArrayList.java:1596)
        at org.junit.platform.engine.support.hierarchical.SameThreadHierarchicalTestExecutorService.invokeAll(SameThreadHierarchicalTestExecutorService.java:41)        
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$6(NodeTestTask.java:155)
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$8(NodeTestTask.java:141)
        at org.junit.platform.engine.support.hierarchical.Node.around(Node.java:137)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$9(NodeTestTask.java:139)
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.executeRecursively(NodeTestTask.java:138)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.execute(NodeTestTask.java:95)
        at java.base/java.util.ArrayList.forEach(ArrayList.java:1596)
        at org.junit.platform.engine.support.hierarchical.SameThreadHierarchicalTestExecutorService.invokeAll(SameThreadHierarchicalTestExecutorService.java:41)        
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$6(NodeTestTask.java:155)
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$8(NodeTestTask.java:141)
        at org.junit.platform.engine.support.hierarchical.Node.around(Node.java:137)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$9(NodeTestTask.java:139)
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.executeRecursively(NodeTestTask.java:138)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.execute(NodeTestTask.java:95)
        at org.junit.platform.engine.support.hierarchical.SameThreadHierarchicalTestExecutorService.submit(SameThreadHierarchicalTestExecutorService.java:35)
        at org.junit.platform.engine.support.hierarchical.HierarchicalTestExecutor.execute(HierarchicalTestExecutor.java:57)
        at org.junit.platform.engine.support.hierarchical.HierarchicalTestEngine.execute(HierarchicalTestEngine.java:54)
        at org.junit.platform.launcher.core.EngineExecutionOrchestrator.execute(EngineExecutionOrchestrator.java:147)
        at org.junit.platform.launcher.core.EngineExecutionOrchestrator.execute(EngineExecutionOrchestrator.java:127)
        at org.junit.platform.launcher.core.EngineExecutionOrchestrator.execute(EngineExecutionOrchestrator.java:90)
        at org.junit.platform.launcher.core.EngineExecutionOrchestrator.lambda$execute$0(EngineExecutionOrchestrator.java:55)
        at org.junit.platform.launcher.core.EngineExecutionOrchestrator.withInterceptedStreams(EngineExecutionOrchestrator.java:102)
        at org.junit.platform.launcher.core.EngineExecutionOrchestrator.execute(EngineExecutionOrchestrator.java:54)
        at org.junit.platform.launcher.core.DefaultLauncher.execute(DefaultLauncher.java:114)
        at org.junit.platform.launcher.core.DefaultLauncher.execute(DefaultLauncher.java:86)
        at org.junit.platform.launcher.core.DefaultLauncherSession$DelegatingLauncher.execute(DefaultLauncherSession.java:86)
        at org.apache.maven.surefire.junitplatform.LazyLauncher.execute(LazyLauncher.java:56)
        at org.apache.maven.surefire.junitplatform.JUnitPlatformProvider.execute(JUnitPlatformProvider.java:184)
        at org.apache.maven.surefire.junitplatform.JUnitPlatformProvider.invokeAllTests(JUnitPlatformProvider.java:148)
        at org.apache.maven.surefire.junitplatform.JUnitPlatformProvider.invoke(JUnitPlatformProvider.java:122)
        at org.apache.maven.surefire.booter.ForkedBooter.runSuitesInProcess(ForkedBooter.java:385)
        at org.apache.maven.surefire.booter.ForkedBooter.execute(ForkedBooter.java:162)
        at org.apache.maven.surefire.booter.ForkedBooter.run(ForkedBooter.java:507) 
        at org.apache.maven.surefire.booter.ForkedBooter.main(ForkedBooter.java:495)
Caused by: org.mockito.exceptions.base.MockitoException: Could not modify all classes [interface org.springframework.data.jpa.repository.JpaRepository, interface org.springframework.data.repository.Repository, interface org.springframework.data.repository.query.QueryByExampleExecutor, interface org.springframework.data.repository.PagingAndSortingRepository, interface org.springframework.data.repository.CrudRepository, interface com.biblio.repository.AdherentRepository]
        at net.bytebuddy.TypeCache.findOrInsert(TypeCache.java:168)
        at net.bytebuddy.TypeCache$WithInlineExpunction.findOrInsert(TypeCache.java:399)
        at net.bytebuddy.TypeCache.findOrInsert(TypeCache.java:190)
        at net.bytebuddy.TypeCache$WithInlineExpunction.findOrInsert(TypeCache.java:410)
        ... 74 more
Caused by: java.lang.IllegalStateException:
Byte Buddy could not instrument all classes within the mock's type hierarchy        

This problem should never occur for javac-compiled classes. This problem has been observed for classes that are:
 - Compiled by older versions of scalac
 - Classes that are part of the Android distribution
        at org.mockito.internal.creation.bytebuddy.InlineBytecodeGenerator.triggerRetransformation(InlineBytecodeGenerator.java:285)
        at org.mockito.internal.creation.bytebuddy.InlineBytecodeGenerator.mockClass(InlineBytecodeGenerator.java:218)
        at org.mockito.internal.creation.bytebuddy.TypeCachingBytecodeGenerator.lambda$mockClass$0(TypeCachingBytecodeGenerator.java:78)
        at net.bytebuddy.TypeCache.findOrInsert(TypeCache.java:168)
        at net.bytebuddy.TypeCache$WithInlineExpunction.findOrInsert(TypeCache.java:399)
        at net.bytebuddy.TypeCache.findOrInsert(TypeCache.java:190)
        at net.bytebuddy.TypeCache$WithInlineExpunction.findOrInsert(TypeCache.java:410)
        at org.mockito.internal.creation.bytebuddy.TypeCachingBytecodeGenerator.mockClass(TypeCachingBytecodeGenerator.java:75)
        at org.mockito.internal.creation.bytebuddy.InlineDelegateByteBuddyMockMaker.createMockType(InlineDelegateByteBuddyMockMaker.java:414)
        at org.mockito.internal.creation.bytebuddy.InlineDelegateByteBuddyMockMaker.doCreateMock(InlineDelegateByteBuddyMockMaker.java:373)
        at org.mockito.internal.creation.bytebuddy.InlineDelegateByteBuddyMockMaker.createMock(InlineDelegateByteBuddyMockMaker.java:352)
        at org.mockito.internal.creation.bytebuddy.InlineByteBuddyMockMaker.createMock(InlineByteBuddyMockMaker.java:56)
        at org.mockito.internal.util.MockUtil.createMock(MockUtil.java:99)
        at org.mockito.internal.MockitoCore.mock(MockitoCore.java:84)
        at org.mockito.Mockito.mock(Mockito.java:2104)
        at org.mockito.internal.configuration.MockAnnotationProcessor.processAnnotationForMock(MockAnnotationProcessor.java:79)
        at org.mockito.internal.configuration.MockAnnotationProcessor.process(MockAnnotationProcessor.java:28)
        at org.mockito.internal.configuration.MockAnnotationProcessor.process(MockAnnotationProcessor.java:25)
        at org.mockito.internal.configuration.IndependentAnnotationEngine.createMockFor(IndependentAnnotationEngine.java:44)
        at org.mockito.internal.configuration.IndependentAnnotationEngine.process(IndependentAnnotationEngine.java:72)
        at org.mockito.internal.configuration.InjectingAnnotationEngine.processIndependentAnnotations(InjectingAnnotationEngine.java:62)
        at org.mockito.internal.configuration.InjectingAnnotationEngine.process(InjectingAnnotationEngine.java:47)
        at org.mockito.MockitoAnnotations.openMocks(MockitoAnnotations.java:81)     
        ... 74 more
Caused by: java.lang.IllegalArgumentException: Java 21 (65) is not supported by the current version of Byte Buddy which officially supports Java 20 (64) - update Byte Buddy or set net.bytebuddy.experimental as a VM property
        at net.bytebuddy.utility.OpenedClassReader.of(OpenedClassReader.java:96)    
        at net.bytebuddy.dynamic.scaffold.TypeWriter$Default$ForInlining.create(TypeWriter.java:4011)
        at net.bytebuddy.dynamic.scaffold.TypeWriter$Default.make(TypeWriter.java:2224)
        at net.bytebuddy.dynamic.DynamicType$Builder$AbstractBase$UsingTypeWriter.make(DynamicType.java:4050)
        at net.bytebuddy.dynamic.DynamicType$Builder$AbstractBase.make(DynamicType.java:3734)
        at org.mockito.internal.creation.bytebuddy.InlineBytecodeGenerator.transform(InlineBytecodeGenerator.java:402)
        at java.instrument/java.lang.instrument.ClassFileTransformer.transform(ClassFileTransformer.java:244)
        at java.instrument/sun.instrument.TransformerManager.transform(TransformerManager.java:188)
        at java.instrument/sun.instrument.InstrumentationImpl.transform(InstrumentationImpl.java:610)
        at java.instrument/sun.instrument.InstrumentationImpl.retransformClasses0(Native Method)
        at java.instrument/sun.instrument.InstrumentationImpl.retransformClasses(InstrumentationImpl.java:225)
        at org.mockito.internal.creation.bytebuddy.InlineBytecodeGenerator.triggerRetransformation(InlineBytecodeGenerator.java:281)
        ... 96 more

[INFO] 
[INFO] Results:
[INFO]
[ERROR] Errors: 
[ERROR]   PretServiceTest.setUp:56 Mockito 
Mockito cannot mock this class: interface com.biblio.repository.AdherentRepository. 

If you're not sure why you're getting this error, please open an issue on GitHub.   


Java               : 21
JVM vendor name    : Eclipse Adoptium
JVM vendor version : 21.0.7+6-LTS
JVM name           : OpenJDK 64-Bit Server VM
JVM version        : 21.0.7+6-LTS
JVM info           : mixed mode, sharing
OS name            : Windows 11
OS version         : 10.0


You are seeing this disclaimer because Mockito is configured to create inlined mocks.
You can learn about inline mocks and their limitations under item #39 of the Mockito class javadoc.

Underlying exception : org.mockito.exceptions.base.MockitoException: Could not modify all classes [interface org.springframework.data.jpa.repository.JpaRepository, interface org.springframework.data.repository.Repository, interface org.springframework.data.repository.query.QueryByExampleExecutor, interface org.springframework.data.repository.PagingAndSortingRepository, interface org.springframework.data.repository.CrudRepository, interface com.biblio.repository.AdherentRepository]
[ERROR]   PretServiceTest.setUp:56 Mockito 
Mockito cannot mock this class: interface com.biblio.repository.AdherentRepository. 

If you're not sure why you're getting this error, please open an issue on GitHub.   


Java               : 21
JVM vendor name    : Eclipse Adoptium
JVM vendor version : 21.0.7+6-LTS
JVM name           : OpenJDK 64-Bit Server VM
JVM version        : 21.0.7+6-LTS
JVM info           : mixed mode, sharing
OS name            : Windows 11
OS version         : 10.0


You are seeing this disclaimer because Mockito is configured to create inlined mocks.
You can learn about inline mocks and their limitations under item #39 of the Mockito class javadoc.

Underlying exception : org.mockito.exceptions.base.MockitoException: Could not modify all classes [interface org.springframework.data.jpa.repository.JpaRepository, interface org.springframework.data.repository.Repository, interface org.springframework.data.repository.query.QueryByExampleExecutor, interface org.springframework.data.repository.PagingAndSortingRepository, interface org.springframework.data.repository.CrudRepository, interface com.biblio.repository.AdherentRepository]
[ERROR]   PretServiceTest.setUp:56 Mockito 
Mockito cannot mock this class: interface com.biblio.repository.AdherentRepository. 

If you're not sure why you're getting this error, please open an issue on GitHub.   


Java               : 21
JVM vendor name    : Eclipse Adoptium
JVM vendor version : 21.0.7+6-LTS
JVM name           : OpenJDK 64-Bit Server VM
JVM version        : 21.0.7+6-LTS
JVM info           : mixed mode, sharing
OS name            : Windows 11
OS version         : 10.0


You are seeing this disclaimer because Mockito is configured to create inlined mocks.
You can learn about inline mocks and their limitations under item #39 of the Mockito class javadoc.

Underlying exception : org.mockito.exceptions.base.MockitoException: Could not modify all classes [interface org.springframework.data.jpa.repository.JpaRepository, interface org.springframework.data.repository.Repository, interface org.springframework.data.repository.query.QueryByExampleExecutor, interface org.springframework.data.repository.PagingAndSortingRepository, interface org.springframework.data.repository.CrudRepository, interface com.biblio.repository.AdherentRepository]
[ERROR]   PretServiceTest.setUp:56 Mockito 
Mockito cannot mock this class: interface com.biblio.repository.AdherentRepository. 

If you're not sure why you're getting this error, please open an issue on GitHub.   


Java               : 21
JVM vendor name    : Eclipse Adoptium
JVM vendor version : 21.0.7+6-LTS
JVM name           : OpenJDK 64-Bit Server VM
JVM version        : 21.0.7+6-LTS
JVM info           : mixed mode, sharing
OS name            : Windows 11
OS version         : 10.0


You are seeing this disclaimer because Mockito is configured to create inlined mocks.
You can learn about inline mocks and their limitations under item #39 of the Mockito class javadoc.

Underlying exception : org.mockito.exceptions.base.MockitoException: Could not modify all classes [interface org.springframework.data.jpa.repository.JpaRepository, interface org.springframework.data.repository.Repository, interface org.springframework.data.repository.query.QueryByExampleExecutor, interface org.springframework.data.repository.PagingAndSortingRepository, interface org.springframework.data.repository.CrudRepository, interface com.biblio.repository.AdherentRepository]
[ERROR]   PretServiceTest.setUp:56 Mockito 
Mockito cannot mock this class: interface com.biblio.repository.AdherentRepository. 

If you're not sure why you're getting this error, please open an issue on GitHub.   


Java               : 21
JVM vendor name    : Eclipse Adoptium
JVM vendor version : 21.0.7+6-LTS
JVM name           : OpenJDK 64-Bit Server VM
JVM version        : 21.0.7+6-LTS
JVM info           : mixed mode, sharing
OS name            : Windows 11
OS version         : 10.0


You are seeing this disclaimer because Mockito is configured to create inlined mocks.
You can learn about inline mocks and their limitations under item #39 of the Mockito class javadoc.

Underlying exception : org.mockito.exceptions.base.MockitoException: Could not modify all classes [interface org.springframework.data.jpa.repository.JpaRepository, interface org.springframework.data.repository.Repository, interface org.springframework.data.repository.query.QueryByExampleExecutor, interface org.springframework.data.repository.PagingAndSortingRepository, interface org.springframework.data.repository.CrudRepository, interface com.biblio.repository.AdherentRepository]
[ERROR]   PretServiceTest.setUp:56 Mockito 
Mockito cannot mock this class: interface com.biblio.repository.AdherentRepository. 

If you're not sure why you're getting this error, please open an issue on GitHub.   


Java               : 21
JVM vendor name    : Eclipse Adoptium
JVM vendor version : 21.0.7+6-LTS
JVM name           : OpenJDK 64-Bit Server VM
JVM version        : 21.0.7+6-LTS
JVM info           : mixed mode, sharing
OS name            : Windows 11
OS version         : 10.0


You are seeing this disclaimer because Mockito is configured to create inlined mocks.
You can learn about inline mocks and their limitations under item #39 of the Mockito class javadoc.

Underlying exception : org.mockito.exceptions.base.MockitoException: Could not modify all classes [interface org.springframework.data.jpa.repository.JpaRepository, interface org.springframework.data.repository.Repository, interface org.springframework.data.repository.query.QueryByExampleExecutor, interface org.springframework.data.repository.PagingAndSortingRepository, interface org.springframework.data.repository.CrudRepository, interface com.biblio.repository.AdherentRepository]
[INFO]
[ERROR] Tests run: 6, Failures: 0, Errors: 6, Skipped: 0
[INFO]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD FAILURE
[INFO] ------------------------------------------------------------------------     
[INFO] Total time:  11.673 s
[INFO] Finished at: 2025-07-12T14:53:15+03:00
[INFO] ------------------------------------------------------------------------     
[ERROR] Failed to execute goal org.apache.maven.plugins:maven-surefire-plugin:3.2.5:test (default-test) on project bibli:
[ERROR]
[ERROR] Please refer to C:\Users\ORNELLA\Documents\S4\Naina\Bibliotheques\projet_final\projet-web-dynamique-S4\bibli\target\surefire-reports for the individual test results.
[ERROR] Please refer to dump files (if any exist) [date].dump, [date]-jvmRun[N].dump and [date].dumpstream.
[ERROR] -> [Help 1]
[ERROR]
[ERROR] To see the full stack trace of the errors, re-run Maven with the -e switch. 
[ERROR] Re-run Maven using the -X switch to enable full debug logging.
[ERROR]
[ERROR] For more information about the errors and possible solutions, please read the following articles:
[ERROR] [Help 1] http://cwiki.apache.org/confluence/display/MAVEN/MojoFailureException

suivi des etapes de resolution des problèmes :
j'ai changer de repertoire vers celui du projet avec cette commande :
cd C:\Users\ORNELLA\Documents\S4\Naina\Bibliotheques\projet_final\projet-web-dynamique-S4\bibli
et j'ai reussi

j'ai verifier que le fichier pom.xml est bien présent dans ce repertoire avec la commande dir et j'ai obtenu :
12/07/2025  14:53    <DIR>          .
12/07/2025  08:40    <DIR>          ..
12/07/2025  09:12             5 103 pom.xml
12/07/2025  08:40    <DIR>          src
12/07/2025  14:53    <DIR>          target
               1 fichier(s)            5 103 octets
               4 Rép(s)  106 388 234 240 octets libres

execution de cette commande correctement (sans le point à la fin) :
mvn clean install -U
et j'ai obtenu :
at org.mockito.internal.util.MockUtil.createMock(MockUtil.java:99)
        at org.mockito.internal.MockitoCore.mock(MockitoCore.java:84)
        at org.mockito.Mockito.mock(Mockito.java:2104)
        at org.mockito.internal.configuration.MockAnnotationProcessor.processAnnotationForMock(MockAnnotationProcessor.java:79)
        at org.mockito.internal.configuration.MockAnnotationProcessor.process(MockAnnotationProcessor.java:28)
        at org.mockito.internal.configuration.MockAnnotationProcessor.process(MockAnnotationProcessor.java:25)
        at org.mockito.internal.configuration.IndependentAnnotationEngine.createMockFor(IndependentAnnotationEngine.java:44)
        at org.mockito.internal.configuration.IndependentAnnotationEngine.process(IndependentAnnotationEngine.java:72)
        at org.mockito.internal.configuration.InjectingAnnotationEngine.processIndependentAnnotations(InjectingAnnotationEngine.java:62)
        at org.mockito.internal.configuration.InjectingAnnotationEngine.process(InjectingAnnotationEngine.java:47)
        at org.mockito.MockitoAnnotations.openMocks(MockitoAnnotations.java:81)     
        ... 74 more
Caused by: java.lang.IllegalArgumentException: Java 21 (65) is not supported by the current version of Byte Buddy which officially supports Java 20 (64) - update Byte Buddy or set net.bytebuddy.experimental as a VM property
        at net.bytebuddy.utility.OpenedClassReader.of(OpenedClassReader.java:96)    
        at net.bytebuddy.dynamic.scaffold.TypeWriter$Default$ForInlining.create(TypeWriter.java:4011)
        at net.bytebuddy.dynamic.scaffold.TypeWriter$Default.make(TypeWriter.java:2224)
        at net.bytebuddy.dynamic.DynamicType$Builder$AbstractBase$UsingTypeWriter.make(DynamicType.java:4050)
        at net.bytebuddy.dynamic.DynamicType$Builder$AbstractBase.make(DynamicType.java:3734)
        at org.mockito.internal.creation.bytebuddy.InlineBytecodeGenerator.transform(InlineBytecodeGenerator.java:402)
        at java.instrument/java.lang.instrument.ClassFileTransformer.transform(ClassFileTransformer.java:244)
        at java.instrument/sun.instrument.TransformerManager.transform(TransformerManager.java:188)
        at java.instrument/sun.instrument.InstrumentationImpl.transform(InstrumentationImpl.java:610)
        at java.instrument/sun.instrument.InstrumentationImpl.retransformClasses0(Native Method)
        at java.instrument/sun.instrument.InstrumentationImpl.retransformClasses(InstrumentationImpl.java:225)
        at org.mockito.internal.creation.bytebuddy.InlineBytecodeGenerator.triggerRetransformation(InlineBytecodeGenerator.java:281)
        ... 96 more

[ERROR] com.biblio.service.PretServiceTest.testPreterExemplaireSuccess -- Time elapsed: 0.054 s <<< ERROR!
org.mockito.exceptions.base.MockitoException:

Mockito cannot mock this class: interface com.biblio.repository.AdherentRepository. 

If you're not sure why you're getting this error, please open an issue on GitHub.   


Java               : 21
JVM vendor name    : Eclipse Adoptium
JVM vendor version : 21.0.7+6-LTS
JVM name           : OpenJDK 64-Bit Server VM
JVM version        : 21.0.7+6-LTS
JVM info           : mixed mode, sharing
OS name            : Windows 11
OS version         : 10.0


You are seeing this disclaimer because Mockito is configured to create inlined mocks.
You can learn about inline mocks and their limitations under item #39 of the Mockito class javadoc.

Underlying exception : org.mockito.exceptions.base.MockitoException: Could not modify all classes [interface org.springframework.data.jpa.repository.JpaRepository, interface org.springframework.data.repository.Repository, interface org.springframework.data.repository.query.QueryByExampleExecutor, interface org.springframework.data.repository.PagingAndSortingRepository, interface org.springframework.data.repository.CrudRepository, interface com.biblio.repository.AdherentRepository]
        at com.biblio.service.PretServiceTest.setUp(PretServiceTest.java:56)        
        at java.base/jdk.internal.reflect.DirectMethodHandleAccessor.invoke(DirectMethodHandleAccessor.java:103)
        at java.base/java.lang.reflect.Method.invoke(Method.java:580)
        at org.junit.platform.commons.util.ReflectionUtils.invokeMethod(ReflectionUtils.java:725)
        at org.junit.jupiter.engine.execution.MethodInvocation.proceed(MethodInvocation.java:60)
        at org.junit.jupiter.engine.execution.InvocationInterceptorChain$ValidatingInvocation.proceed(InvocationInterceptorChain.java:131)
        at org.junit.jupiter.engine.extension.TimeoutExtension.intercept(TimeoutExtension.java:149)
        at org.junit.jupiter.engine.extension.TimeoutExtension.interceptLifecycleMethod(TimeoutExtension.java:126)
        at org.junit.jupiter.engine.extension.TimeoutExtension.interceptBeforeEachMethod(TimeoutExtension.java:76)
        at org.junit.jupiter.engine.execution.ExecutableInvoker$ReflectiveInterceptorCall.lambda$ofVoidMethod$0(ExecutableInvoker.java:115)
        at org.junit.jupiter.engine.execution.ExecutableInvoker.lambda$invoke$0(ExecutableInvoker.java:105)
        at org.junit.jupiter.engine.execution.InvocationInterceptorChain$InterceptedInvocation.proceed(InvocationInterceptorChain.java:106)
        at org.junit.jupiter.engine.execution.InvocationInterceptorChain.proceed(InvocationInterceptorChain.java:64)
        at org.junit.jupiter.engine.execution.InvocationInterceptorChain.chainAndInvoke(InvocationInterceptorChain.java:45)
        at org.junit.jupiter.engine.execution.InvocationInterceptorChain.invoke(InvocationInterceptorChain.java:37)
        at org.junit.jupiter.engine.execution.ExecutableInvoker.invoke(ExecutableInvoker.java:104)
        at org.junit.jupiter.engine.execution.ExecutableInvoker.invoke(ExecutableInvoker.java:98)
        at org.junit.jupiter.engine.descriptor.ClassBasedTestDescriptor.invokeMethodInExtensionContext(ClassBasedTestDescriptor.java:506)
        at org.junit.jupiter.engine.descriptor.ClassBasedTestDescriptor.lambda$synthesizeBeforeEachMethodAdapter$21(ClassBasedTestDescriptor.java:491)
        at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.lambda$invokeBeforeEachMethods$3(TestMethodTestDescriptor.java:171)
        at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.lambda$invokeBeforeMethodsOrCallbacksUntilExceptionOccurs$6(TestMethodTestDescriptor.java:199)  
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.invokeBeforeMethodsOrCallbacksUntilExceptionOccurs(TestMethodTestDescriptor.java:199)
        at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.invokeBeforeEachMethods(TestMethodTestDescriptor.java:168)
        at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.execute(TestMethodTestDescriptor.java:131)
        at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.execute(TestMethodTestDescriptor.java:66)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$6(NodeTestTask.java:151)
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$8(NodeTestTask.java:141)
        at org.junit.platform.engine.support.hierarchical.Node.around(Node.java:137)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$9(NodeTestTask.java:139)
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.executeRecursively(NodeTestTask.java:138)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.execute(NodeTestTask.java:95)
        at java.base/java.util.ArrayList.forEach(ArrayList.java:1596)
        at org.junit.platform.engine.support.hierarchical.SameThreadHierarchicalTestExecutorService.invokeAll(SameThreadHierarchicalTestExecutorService.java:41)        
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$6(NodeTestTask.java:155)
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$8(NodeTestTask.java:141)
        at org.junit.platform.engine.support.hierarchical.Node.around(Node.java:137)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$9(NodeTestTask.java:139)
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.executeRecursively(NodeTestTask.java:138)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.execute(NodeTestTask.java:95)
        at java.base/java.util.ArrayList.forEach(ArrayList.java:1596)
        at org.junit.platform.engine.support.hierarchical.SameThreadHierarchicalTestExecutorService.invokeAll(SameThreadHierarchicalTestExecutorService.java:41)        
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$6(NodeTestTask.java:155)
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$8(NodeTestTask.java:141)
        at org.junit.platform.engine.support.hierarchical.Node.around(Node.java:137)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$9(NodeTestTask.java:139)
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.executeRecursively(NodeTestTask.java:138)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.execute(NodeTestTask.java:95)
        at org.junit.platform.engine.support.hierarchical.SameThreadHierarchicalTestExecutorService.submit(SameThreadHierarchicalTestExecutorService.java:35)
        at org.junit.platform.engine.support.hierarchical.HierarchicalTestExecutor.execute(HierarchicalTestExecutor.java:57)
        at org.junit.platform.engine.support.hierarchical.HierarchicalTestEngine.execute(HierarchicalTestEngine.java:54)
        at org.junit.platform.launcher.core.EngineExecutionOrchestrator.execute(EngineExecutionOrchestrator.java:147)
        at org.junit.platform.launcher.core.EngineExecutionOrchestrator.execute(EngineExecutionOrchestrator.java:127)
        at org.junit.platform.launcher.core.EngineExecutionOrchestrator.execute(EngineExecutionOrchestrator.java:90)
        at org.junit.platform.launcher.core.EngineExecutionOrchestrator.lambda$execute$0(EngineExecutionOrchestrator.java:55)
        at org.junit.platform.launcher.core.EngineExecutionOrchestrator.withInterceptedStreams(EngineExecutionOrchestrator.java:102)
        at org.junit.platform.launcher.core.EngineExecutionOrchestrator.execute(EngineExecutionOrchestrator.java:54)
        at org.junit.platform.launcher.core.DefaultLauncher.execute(DefaultLauncher.java:114)
        at org.junit.platform.launcher.core.DefaultLauncher.execute(DefaultLauncher.java:86)
        at org.junit.platform.launcher.core.DefaultLauncherSession$DelegatingLauncher.execute(DefaultLauncherSession.java:86)
        at org.apache.maven.surefire.junitplatform.LazyLauncher.execute(LazyLauncher.java:56)
        at org.apache.maven.surefire.junitplatform.JUnitPlatformProvider.execute(JUnitPlatformProvider.java:184)
        at org.apache.maven.surefire.junitplatform.JUnitPlatformProvider.invokeAllTests(JUnitPlatformProvider.java:148)
        at org.apache.maven.surefire.junitplatform.JUnitPlatformProvider.invoke(JUnitPlatformProvider.java:122)
        at org.apache.maven.surefire.booter.ForkedBooter.runSuitesInProcess(ForkedBooter.java:385)
        at org.apache.maven.surefire.booter.ForkedBooter.execute(ForkedBooter.java:162)
        at org.apache.maven.surefire.booter.ForkedBooter.run(ForkedBooter.java:507) 
        at org.apache.maven.surefire.booter.ForkedBooter.main(ForkedBooter.java:495)
Caused by: org.mockito.exceptions.base.MockitoException: Could not modify all classes [interface org.springframework.data.jpa.repository.JpaRepository, interface org.springframework.data.repository.Repository, interface org.springframework.data.repository.query.QueryByExampleExecutor, interface org.springframework.data.repository.PagingAndSortingRepository, interface org.springframework.data.repository.CrudRepository, interface com.biblio.repository.AdherentRepository]
        at net.bytebuddy.TypeCache.findOrInsert(TypeCache.java:168)
        at net.bytebuddy.TypeCache$WithInlineExpunction.findOrInsert(TypeCache.java:399)
        at net.bytebuddy.TypeCache.findOrInsert(TypeCache.java:190)
        at net.bytebuddy.TypeCache$WithInlineExpunction.findOrInsert(TypeCache.java:410)
        ... 74 more
Caused by: java.lang.IllegalStateException:
Byte Buddy could not instrument all classes within the mock's type hierarchy        

This problem should never occur for javac-compiled classes. This problem has been observed for classes that are:
 - Compiled by older versions of scalac
 - Classes that are part of the Android distribution
        at org.mockito.internal.creation.bytebuddy.InlineBytecodeGenerator.triggerRetransformation(InlineBytecodeGenerator.java:285)
        at org.mockito.internal.creation.bytebuddy.InlineBytecodeGenerator.mockClass(InlineBytecodeGenerator.java:218)
        at org.mockito.internal.creation.bytebuddy.TypeCachingBytecodeGenerator.lambda$mockClass$0(TypeCachingBytecodeGenerator.java:78)
        at net.bytebuddy.TypeCache.findOrInsert(TypeCache.java:168)
        at net.bytebuddy.TypeCache$WithInlineExpunction.findOrInsert(TypeCache.java:399)
        at net.bytebuddy.TypeCache.findOrInsert(TypeCache.java:190)
        at net.bytebuddy.TypeCache$WithInlineExpunction.findOrInsert(TypeCache.java:410)
        at org.mockito.internal.creation.bytebuddy.TypeCachingBytecodeGenerator.mockClass(TypeCachingBytecodeGenerator.java:75)
        at org.mockito.internal.creation.bytebuddy.InlineDelegateByteBuddyMockMaker.createMockType(InlineDelegateByteBuddyMockMaker.java:414)
        at org.mockito.internal.creation.bytebuddy.InlineDelegateByteBuddyMockMaker.doCreateMock(InlineDelegateByteBuddyMockMaker.java:373)
        at org.mockito.internal.creation.bytebuddy.InlineDelegateByteBuddyMockMaker.createMock(InlineDelegateByteBuddyMockMaker.java:352)
        at org.mockito.internal.creation.bytebuddy.InlineByteBuddyMockMaker.createMock(InlineByteBuddyMockMaker.java:56)
        at org.mockito.internal.util.MockUtil.createMock(MockUtil.java:99)
        at org.mockito.internal.MockitoCore.mock(MockitoCore.java:84)
        at org.mockito.Mockito.mock(Mockito.java:2104)
        at org.mockito.internal.configuration.MockAnnotationProcessor.processAnnotationForMock(MockAnnotationProcessor.java:79)
        at org.mockito.internal.configuration.MockAnnotationProcessor.process(MockAnnotationProcessor.java:28)
        at org.mockito.internal.configuration.MockAnnotationProcessor.process(MockAnnotationProcessor.java:25)
        at org.mockito.internal.configuration.IndependentAnnotationEngine.createMockFor(IndependentAnnotationEngine.java:44)
        at org.mockito.internal.configuration.IndependentAnnotationEngine.process(IndependentAnnotationEngine.java:72)
        at org.mockito.internal.configuration.InjectingAnnotationEngine.processIndependentAnnotations(InjectingAnnotationEngine.java:62)
        at org.mockito.internal.configuration.InjectingAnnotationEngine.process(InjectingAnnotationEngine.java:47)
        at org.mockito.MockitoAnnotations.openMocks(MockitoAnnotations.java:81)     
        ... 74 more
Caused by: java.lang.IllegalArgumentException: Java 21 (65) is not supported by the current version of Byte Buddy which officially supports Java 20 (64) - update Byte Buddy or set net.bytebuddy.experimental as a VM property
        at net.bytebuddy.utility.OpenedClassReader.of(OpenedClassReader.java:96)    
        at net.bytebuddy.dynamic.scaffold.TypeWriter$Default$ForInlining.create(TypeWriter.java:4011)
        at net.bytebuddy.dynamic.scaffold.TypeWriter$Default.make(TypeWriter.java:2224)
        at net.bytebuddy.dynamic.DynamicType$Builder$AbstractBase$UsingTypeWriter.make(DynamicType.java:4050)
        at net.bytebuddy.dynamic.DynamicType$Builder$AbstractBase.make(DynamicType.java:3734)
        at org.mockito.internal.creation.bytebuddy.InlineBytecodeGenerator.transform(InlineBytecodeGenerator.java:402)
        at java.instrument/java.lang.instrument.ClassFileTransformer.transform(ClassFileTransformer.java:244)
        at java.instrument/sun.instrument.TransformerManager.transform(TransformerManager.java:188)
        at java.instrument/sun.instrument.InstrumentationImpl.transform(InstrumentationImpl.java:610)
        at java.instrument/sun.instrument.InstrumentationImpl.retransformClasses0(Native Method)
        at java.instrument/sun.instrument.InstrumentationImpl.retransformClasses(InstrumentationImpl.java:225)
        at org.mockito.internal.creation.bytebuddy.InlineBytecodeGenerator.triggerRetransformation(InlineBytecodeGenerator.java:281)
        ... 96 more

[ERROR] com.biblio.service.PretServiceTest.testRetournerExemplaireSuccess -- Time elapsed: 0.045 s <<< ERROR!
org.mockito.exceptions.base.MockitoException:

Mockito cannot mock this class: interface com.biblio.repository.AdherentRepository. 

If you're not sure why you're getting this error, please open an issue on GitHub.   


Java               : 21
JVM vendor name    : Eclipse Adoptium
JVM vendor version : 21.0.7+6-LTS
JVM name           : OpenJDK 64-Bit Server VM
JVM version        : 21.0.7+6-LTS
JVM info           : mixed mode, sharing
OS name            : Windows 11
OS version         : 10.0


You are seeing this disclaimer because Mockito is configured to create inlined mocks.
You can learn about inline mocks and their limitations under item #39 of the Mockito class javadoc.

Underlying exception : org.mockito.exceptions.base.MockitoException: Could not modify all classes [interface org.springframework.data.jpa.repository.JpaRepository, interface org.springframework.data.repository.Repository, interface org.springframework.data.repository.query.QueryByExampleExecutor, interface org.springframework.data.repository.PagingAndSortingRepository, interface org.springframework.data.repository.CrudRepository, interface com.biblio.repository.AdherentRepository]
        at com.biblio.service.PretServiceTest.setUp(PretServiceTest.java:56)        
        at java.base/jdk.internal.reflect.DirectMethodHandleAccessor.invoke(DirectMethodHandleAccessor.java:103)
        at java.base/java.lang.reflect.Method.invoke(Method.java:580)
        at org.junit.platform.commons.util.ReflectionUtils.invokeMethod(ReflectionUtils.java:725)
        at org.junit.jupiter.engine.execution.MethodInvocation.proceed(MethodInvocation.java:60)
        at org.junit.jupiter.engine.execution.InvocationInterceptorChain$ValidatingInvocation.proceed(InvocationInterceptorChain.java:131)
        at org.junit.jupiter.engine.extension.TimeoutExtension.intercept(TimeoutExtension.java:149)
        at org.junit.jupiter.engine.extension.TimeoutExtension.interceptLifecycleMethod(TimeoutExtension.java:126)
        at org.junit.jupiter.engine.extension.TimeoutExtension.interceptBeforeEachMethod(TimeoutExtension.java:76)
        at org.junit.jupiter.engine.execution.ExecutableInvoker$ReflectiveInterceptorCall.lambda$ofVoidMethod$0(ExecutableInvoker.java:115)
        at org.junit.jupiter.engine.execution.ExecutableInvoker.lambda$invoke$0(ExecutableInvoker.java:105)
        at org.junit.jupiter.engine.execution.InvocationInterceptorChain$InterceptedInvocation.proceed(InvocationInterceptorChain.java:106)
        at org.junit.jupiter.engine.execution.InvocationInterceptorChain.proceed(InvocationInterceptorChain.java:64)
        at org.junit.jupiter.engine.execution.InvocationInterceptorChain.chainAndInvoke(InvocationInterceptorChain.java:45)
        at org.junit.jupiter.engine.execution.InvocationInterceptorChain.invoke(InvocationInterceptorChain.java:37)
        at org.junit.jupiter.engine.execution.ExecutableInvoker.invoke(ExecutableInvoker.java:104)
        at org.junit.jupiter.engine.execution.ExecutableInvoker.invoke(ExecutableInvoker.java:98)
        at org.junit.jupiter.engine.descriptor.ClassBasedTestDescriptor.invokeMethodInExtensionContext(ClassBasedTestDescriptor.java:506)
        at org.junit.jupiter.engine.descriptor.ClassBasedTestDescriptor.lambda$synthesizeBeforeEachMethodAdapter$21(ClassBasedTestDescriptor.java:491)
        at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.lambda$invokeBeforeEachMethods$3(TestMethodTestDescriptor.java:171)
        at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.lambda$invokeBeforeMethodsOrCallbacksUntilExceptionOccurs$6(TestMethodTestDescriptor.java:199)  
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.invokeBeforeMethodsOrCallbacksUntilExceptionOccurs(TestMethodTestDescriptor.java:199)
        at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.invokeBeforeEachMethods(TestMethodTestDescriptor.java:168)
        at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.execute(TestMethodTestDescriptor.java:131)
        at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.execute(TestMethodTestDescriptor.java:66)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$6(NodeTestTask.java:151)
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$8(NodeTestTask.java:141)
        at org.junit.platform.engine.support.hierarchical.Node.around(Node.java:137)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$9(NodeTestTask.java:139)
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.executeRecursively(NodeTestTask.java:138)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.execute(NodeTestTask.java:95)
        at java.base/java.util.ArrayList.forEach(ArrayList.java:1596)
        at org.junit.platform.engine.support.hierarchical.SameThreadHierarchicalTestExecutorService.invokeAll(SameThreadHierarchicalTestExecutorService.java:41)        
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$6(NodeTestTask.java:155)
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$8(NodeTestTask.java:141)
        at org.junit.platform.engine.support.hierarchical.Node.around(Node.java:137)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$9(NodeTestTask.java:139)
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.executeRecursively(NodeTestTask.java:138)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.execute(NodeTestTask.java:95)
        at java.base/java.util.ArrayList.forEach(ArrayList.java:1596)
        at org.junit.platform.engine.support.hierarchical.SameThreadHierarchicalTestExecutorService.invokeAll(SameThreadHierarchicalTestExecutorService.java:41)        
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$6(NodeTestTask.java:155)
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$8(NodeTestTask.java:141)
        at org.junit.platform.engine.support.hierarchical.Node.around(Node.java:137)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$9(NodeTestTask.java:139)
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.executeRecursively(NodeTestTask.java:138)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.execute(NodeTestTask.java:95)
        at org.junit.platform.engine.support.hierarchical.SameThreadHierarchicalTestExecutorService.submit(SameThreadHierarchicalTestExecutorService.java:35)
        at org.junit.platform.engine.support.hierarchical.HierarchicalTestExecutor.execute(HierarchicalTestExecutor.java:57)
        at org.junit.platform.engine.support.hierarchical.HierarchicalTestEngine.execute(HierarchicalTestEngine.java:54)
        at org.junit.platform.launcher.core.EngineExecutionOrchestrator.execute(EngineExecutionOrchestrator.java:147)
        at org.junit.platform.launcher.core.EngineExecutionOrchestrator.execute(EngineExecutionOrchestrator.java:127)
        at org.junit.platform.launcher.core.EngineExecutionOrchestrator.execute(EngineExecutionOrchestrator.java:90)
        at org.junit.platform.launcher.core.EngineExecutionOrchestrator.lambda$execute$0(EngineExecutionOrchestrator.java:55)
        at org.junit.platform.launcher.core.EngineExecutionOrchestrator.withInterceptedStreams(EngineExecutionOrchestrator.java:102)
        at org.junit.platform.launcher.core.EngineExecutionOrchestrator.execute(EngineExecutionOrchestrator.java:54)
        at org.junit.platform.launcher.core.DefaultLauncher.execute(DefaultLauncher.java:114)
        at org.junit.platform.launcher.core.DefaultLauncher.execute(DefaultLauncher.java:86)
        at org.junit.platform.launcher.core.DefaultLauncherSession$DelegatingLauncher.execute(DefaultLauncherSession.java:86)
        at org.apache.maven.surefire.junitplatform.LazyLauncher.execute(LazyLauncher.java:56)
        at org.apache.maven.surefire.junitplatform.JUnitPlatformProvider.execute(JUnitPlatformProvider.java:184)
        at org.apache.maven.surefire.junitplatform.JUnitPlatformProvider.invokeAllTests(JUnitPlatformProvider.java:148)
        at org.apache.maven.surefire.junitplatform.JUnitPlatformProvider.invoke(JUnitPlatformProvider.java:122)
        at org.apache.maven.surefire.booter.ForkedBooter.runSuitesInProcess(ForkedBooter.java:385)
        at org.apache.maven.surefire.booter.ForkedBooter.execute(ForkedBooter.java:162)
        at org.apache.maven.surefire.booter.ForkedBooter.run(ForkedBooter.java:507) 
        at org.apache.maven.surefire.booter.ForkedBooter.main(ForkedBooter.java:495)
Caused by: org.mockito.exceptions.base.MockitoException: Could not modify all classes [interface org.springframework.data.jpa.repository.JpaRepository, interface org.springframework.data.repository.Repository, interface org.springframework.data.repository.query.QueryByExampleExecutor, interface org.springframework.data.repository.PagingAndSortingRepository, interface org.springframework.data.repository.CrudRepository, interface com.biblio.repository.AdherentRepository]
        at net.bytebuddy.TypeCache.findOrInsert(TypeCache.java:168)
        at net.bytebuddy.TypeCache$WithInlineExpunction.findOrInsert(TypeCache.java:399)
        at net.bytebuddy.TypeCache.findOrInsert(TypeCache.java:190)
        at net.bytebuddy.TypeCache$WithInlineExpunction.findOrInsert(TypeCache.java:410)
        ... 74 more
Caused by: java.lang.IllegalStateException:
Byte Buddy could not instrument all classes within the mock's type hierarchy        

This problem should never occur for javac-compiled classes. This problem has been observed for classes that are:
 - Compiled by older versions of scalac
 - Classes that are part of the Android distribution
        at org.mockito.internal.creation.bytebuddy.InlineBytecodeGenerator.triggerRetransformation(InlineBytecodeGenerator.java:285)
        at org.mockito.internal.creation.bytebuddy.InlineBytecodeGenerator.mockClass(InlineBytecodeGenerator.java:218)
        at org.mockito.internal.creation.bytebuddy.TypeCachingBytecodeGenerator.lambda$mockClass$0(TypeCachingBytecodeGenerator.java:78)
        at net.bytebuddy.TypeCache.findOrInsert(TypeCache.java:168)
        at net.bytebuddy.TypeCache$WithInlineExpunction.findOrInsert(TypeCache.java:399)
        at net.bytebuddy.TypeCache.findOrInsert(TypeCache.java:190)
        at net.bytebuddy.TypeCache$WithInlineExpunction.findOrInsert(TypeCache.java:410)
        at org.mockito.internal.creation.bytebuddy.TypeCachingBytecodeGenerator.mockClass(TypeCachingBytecodeGenerator.java:75)
        at org.mockito.internal.creation.bytebuddy.InlineDelegateByteBuddyMockMaker.createMockType(InlineDelegateByteBuddyMockMaker.java:414)
        at org.mockito.internal.creation.bytebuddy.InlineDelegateByteBuddyMockMaker.doCreateMock(InlineDelegateByteBuddyMockMaker.java:373)
        at org.mockito.internal.creation.bytebuddy.InlineDelegateByteBuddyMockMaker.createMock(InlineDelegateByteBuddyMockMaker.java:352)
        at org.mockito.internal.creation.bytebuddy.InlineByteBuddyMockMaker.createMock(InlineByteBuddyMockMaker.java:56)
        at org.mockito.internal.util.MockUtil.createMock(MockUtil.java:99)
        at org.mockito.internal.MockitoCore.mock(MockitoCore.java:84)
        at org.mockito.Mockito.mock(Mockito.java:2104)
        at org.mockito.internal.configuration.MockAnnotationProcessor.processAnnotationForMock(MockAnnotationProcessor.java:79)
        at org.mockito.internal.configuration.MockAnnotationProcessor.process(MockAnnotationProcessor.java:28)
        at org.mockito.internal.configuration.MockAnnotationProcessor.process(MockAnnotationProcessor.java:25)
        at org.mockito.internal.configuration.IndependentAnnotationEngine.createMockFor(IndependentAnnotationEngine.java:44)
        at org.mockito.internal.configuration.IndependentAnnotationEngine.process(IndependentAnnotationEngine.java:72)
        at org.mockito.internal.configuration.InjectingAnnotationEngine.processIndependentAnnotations(InjectingAnnotationEngine.java:62)
        at org.mockito.internal.configuration.InjectingAnnotationEngine.process(InjectingAnnotationEngine.java:47)
        at org.mockito.MockitoAnnotations.openMocks(MockitoAnnotations.java:81)     
        ... 74 more
Caused by: java.lang.IllegalArgumentException: Java 21 (65) is not supported by the current version of Byte Buddy which officially supports Java 20 (64) - update Byte Buddy or set net.bytebuddy.experimental as a VM property
        at net.bytebuddy.utility.OpenedClassReader.of(OpenedClassReader.java:96)    
        at net.bytebuddy.dynamic.scaffold.TypeWriter$Default$ForInlining.create(TypeWriter.java:4011)
        at net.bytebuddy.dynamic.scaffold.TypeWriter$Default.make(TypeWriter.java:2224)
        at net.bytebuddy.dynamic.DynamicType$Builder$AbstractBase$UsingTypeWriter.make(DynamicType.java:4050)
        at net.bytebuddy.dynamic.DynamicType$Builder$AbstractBase.make(DynamicType.java:3734)
        at org.mockito.internal.creation.bytebuddy.InlineBytecodeGenerator.transform(InlineBytecodeGenerator.java:402)
        at java.instrument/java.lang.instrument.ClassFileTransformer.transform(ClassFileTransformer.java:244)
        at java.instrument/sun.instrument.TransformerManager.transform(TransformerManager.java:188)
        at java.instrument/sun.instrument.InstrumentationImpl.transform(InstrumentationImpl.java:610)
        at java.instrument/sun.instrument.InstrumentationImpl.retransformClasses0(Native Method)
        at java.instrument/sun.instrument.InstrumentationImpl.retransformClasses(InstrumentationImpl.java:225)
        at org.mockito.internal.creation.bytebuddy.InlineBytecodeGenerator.triggerRetransformation(InlineBytecodeGenerator.java:281)
        ... 96 more

[ERROR] com.biblio.service.PretServiceTest.testPreterExemplaireAdherentNonExistant -- Time elapsed: 0.050 s <<< ERROR!
org.mockito.exceptions.base.MockitoException:

Mockito cannot mock this class: interface com.biblio.repository.AdherentRepository. 

If you're not sure why you're getting this error, please open an issue on GitHub.   


Java               : 21
JVM vendor name    : Eclipse Adoptium
JVM vendor version : 21.0.7+6-LTS
JVM name           : OpenJDK 64-Bit Server VM
JVM version        : 21.0.7+6-LTS
JVM info           : mixed mode, sharing
OS name            : Windows 11
OS version         : 10.0


You are seeing this disclaimer because Mockito is configured to create inlined mocks.
You can learn about inline mocks and their limitations under item #39 of the Mockito class javadoc.

Underlying exception : org.mockito.exceptions.base.MockitoException: Could not modify all classes [interface org.springframework.data.jpa.repository.JpaRepository, interface org.springframework.data.repository.Repository, interface org.springframework.data.repository.query.QueryByExampleExecutor, interface org.springframework.data.repository.PagingAndSortingRepository, interface org.springframework.data.repository.CrudRepository, interface com.biblio.repository.AdherentRepository]
        at com.biblio.service.PretServiceTest.setUp(PretServiceTest.java:56)        
        at java.base/jdk.internal.reflect.DirectMethodHandleAccessor.invoke(DirectMethodHandleAccessor.java:103)
        at java.base/java.lang.reflect.Method.invoke(Method.java:580)
        at org.junit.platform.commons.util.ReflectionUtils.invokeMethod(ReflectionUtils.java:725)
        at org.junit.jupiter.engine.execution.MethodInvocation.proceed(MethodInvocation.java:60)
        at org.junit.jupiter.engine.execution.InvocationInterceptorChain$ValidatingInvocation.proceed(InvocationInterceptorChain.java:131)
        at org.junit.jupiter.engine.extension.TimeoutExtension.intercept(TimeoutExtension.java:149)
        at org.junit.jupiter.engine.extension.TimeoutExtension.interceptLifecycleMethod(TimeoutExtension.java:126)
        at org.junit.jupiter.engine.extension.TimeoutExtension.interceptBeforeEachMethod(TimeoutExtension.java:76)
        at org.junit.jupiter.engine.execution.ExecutableInvoker$ReflectiveInterceptorCall.lambda$ofVoidMethod$0(ExecutableInvoker.java:115)
        at org.junit.jupiter.engine.execution.ExecutableInvoker.lambda$invoke$0(ExecutableInvoker.java:105)
        at org.junit.jupiter.engine.execution.InvocationInterceptorChain$InterceptedInvocation.proceed(InvocationInterceptorChain.java:106)
        at org.junit.jupiter.engine.execution.InvocationInterceptorChain.proceed(InvocationInterceptorChain.java:64)
        at org.junit.jupiter.engine.execution.InvocationInterceptorChain.chainAndInvoke(InvocationInterceptorChain.java:45)
        at org.junit.jupiter.engine.execution.InvocationInterceptorChain.invoke(InvocationInterceptorChain.java:37)
        at org.junit.jupiter.engine.execution.ExecutableInvoker.invoke(ExecutableInvoker.java:104)
        at org.junit.jupiter.engine.execution.ExecutableInvoker.invoke(ExecutableInvoker.java:98)
        at org.junit.jupiter.engine.descriptor.ClassBasedTestDescriptor.invokeMethodInExtensionContext(ClassBasedTestDescriptor.java:506)
        at org.junit.jupiter.engine.descriptor.ClassBasedTestDescriptor.lambda$synthesizeBeforeEachMethodAdapter$21(ClassBasedTestDescriptor.java:491)
        at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.lambda$invokeBeforeEachMethods$3(TestMethodTestDescriptor.java:171)
        at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.lambda$invokeBeforeMethodsOrCallbacksUntilExceptionOccurs$6(TestMethodTestDescriptor.java:199)  
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.invokeBeforeMethodsOrCallbacksUntilExceptionOccurs(TestMethodTestDescriptor.java:199)
        at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.invokeBeforeEachMethods(TestMethodTestDescriptor.java:168)
        at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.execute(TestMethodTestDescriptor.java:131)
        at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.execute(TestMethodTestDescriptor.java:66)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$6(NodeTestTask.java:151)
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$8(NodeTestTask.java:141)
        at org.junit.platform.engine.support.hierarchical.Node.around(Node.java:137)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$9(NodeTestTask.java:139)
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.executeRecursively(NodeTestTask.java:138)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.execute(NodeTestTask.java:95)
        at java.base/java.util.ArrayList.forEach(ArrayList.java:1596)
        at org.junit.platform.engine.support.hierarchical.SameThreadHierarchicalTestExecutorService.invokeAll(SameThreadHierarchicalTestExecutorService.java:41)        
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$6(NodeTestTask.java:155)
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$8(NodeTestTask.java:141)
        at org.junit.platform.engine.support.hierarchical.Node.around(Node.java:137)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$9(NodeTestTask.java:139)
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.executeRecursively(NodeTestTask.java:138)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.execute(NodeTestTask.java:95)
        at java.base/java.util.ArrayList.forEach(ArrayList.java:1596)
        at org.junit.platform.engine.support.hierarchical.SameThreadHierarchicalTestExecutorService.invokeAll(SameThreadHierarchicalTestExecutorService.java:41)        
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$6(NodeTestTask.java:155)
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$8(NodeTestTask.java:141)
        at org.junit.platform.engine.support.hierarchical.Node.around(Node.java:137)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$9(NodeTestTask.java:139)
        at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.executeRecursively(NodeTestTask.java:138)
        at org.junit.platform.engine.support.hierarchical.NodeTestTask.execute(NodeTestTask.java:95)
        at org.junit.platform.engine.support.hierarchical.SameThreadHierarchicalTestExecutorService.submit(SameThreadHierarchicalTestExecutorService.java:35)
        at org.junit.platform.engine.support.hierarchical.HierarchicalTestExecutor.execute(HierarchicalTestExecutor.java:57)
        at org.junit.platform.engine.support.hierarchical.HierarchicalTestEngine.execute(HierarchicalTestEngine.java:54)
        at org.junit.platform.launcher.core.EngineExecutionOrchestrator.execute(EngineExecutionOrchestrator.java:147)
        at org.junit.platform.launcher.core.EngineExecutionOrchestrator.execute(EngineExecutionOrchestrator.java:127)
        at org.junit.platform.launcher.core.EngineExecutionOrchestrator.execute(EngineExecutionOrchestrator.java:90)
        at org.junit.platform.launcher.core.EngineExecutionOrchestrator.lambda$execute$0(EngineExecutionOrchestrator.java:55)
        at org.junit.platform.launcher.core.EngineExecutionOrchestrator.withInterceptedStreams(EngineExecutionOrchestrator.java:102)
        at org.junit.platform.launcher.core.EngineExecutionOrchestrator.execute(EngineExecutionOrchestrator.java:54)
        at org.junit.platform.launcher.core.DefaultLauncher.execute(DefaultLauncher.java:114)
        at org.junit.platform.launcher.core.DefaultLauncher.execute(DefaultLauncher.java:86)
        at org.junit.platform.launcher.core.DefaultLauncherSession$DelegatingLauncher.execute(DefaultLauncherSession.java:86)
        at org.apache.maven.surefire.junitplatform.LazyLauncher.execute(LazyLauncher.java:56)
        at org.apache.maven.surefire.junitplatform.JUnitPlatformProvider.execute(JUnitPlatformProvider.java:184)
        at org.apache.maven.surefire.junitplatform.JUnitPlatformProvider.invokeAllTests(JUnitPlatformProvider.java:148)
        at org.apache.maven.surefire.junitplatform.JUnitPlatformProvider.invoke(JUnitPlatformProvider.java:122)
        at org.apache.maven.surefire.booter.ForkedBooter.runSuitesInProcess(ForkedBooter.java:385)
        at org.apache.maven.surefire.booter.ForkedBooter.execute(ForkedBooter.java:162)
        at org.apache.maven.surefire.booter.ForkedBooter.run(ForkedBooter.java:507) 
        at org.apache.maven.surefire.booter.ForkedBooter.main(ForkedBooter.java:495)
Caused by: org.mockito.exceptions.base.MockitoException: Could not modify all classes [interface org.springframework.data.jpa.repository.JpaRepository, interface org.springframework.data.repository.Repository, interface org.springframework.data.repository.query.QueryByExampleExecutor, interface org.springframework.data.repository.PagingAndSortingRepository, interface org.springframework.data.repository.CrudRepository, interface com.biblio.repository.AdherentRepository]
        at net.bytebuddy.TypeCache.findOrInsert(TypeCache.java:168)
        at net.bytebuddy.TypeCache$WithInlineExpunction.findOrInsert(TypeCache.java:399)
        at net.bytebuddy.TypeCache.findOrInsert(TypeCache.java:190)
        at net.bytebuddy.TypeCache$WithInlineExpunction.findOrInsert(TypeCache.java:410)
        ... 74 more
Caused by: java.lang.IllegalStateException:
Byte Buddy could not instrument all classes within the mock's type hierarchy        

This problem should never occur for javac-compiled classes. This problem has been observed for classes that are:
 - Compiled by older versions of scalac
 - Classes that are part of the Android distribution
        at org.mockito.internal.creation.bytebuddy.InlineBytecodeGenerator.triggerRetransformation(InlineBytecodeGenerator.java:285)
        at org.mockito.internal.creation.bytebuddy.InlineBytecodeGenerator.mockClass(InlineBytecodeGenerator.java:218)
        at org.mockito.internal.creation.bytebuddy.TypeCachingBytecodeGenerator.lambda$mockClass$0(TypeCachingBytecodeGenerator.java:78)
        at net.bytebuddy.TypeCache.findOrInsert(TypeCache.java:168)
        at net.bytebuddy.TypeCache$WithInlineExpunction.findOrInsert(TypeCache.java:399)
        at net.bytebuddy.TypeCache.findOrInsert(TypeCache.java:190)
        at net.bytebuddy.TypeCache$WithInlineExpunction.findOrInsert(TypeCache.java:410)
        at org.mockito.internal.creation.bytebuddy.TypeCachingBytecodeGenerator.mockClass(TypeCachingBytecodeGenerator.java:75)
        at org.mockito.internal.creation.bytebuddy.InlineDelegateByteBuddyMockMaker.createMockType(InlineDelegateByteBuddyMockMaker.java:414)
        at org.mockito.internal.creation.bytebuddy.InlineDelegateByteBuddyMockMaker.doCreateMock(InlineDelegateByteBuddyMockMaker.java:373)
        at org.mockito.internal.creation.bytebuddy.InlineDelegateByteBuddyMockMaker.createMock(InlineDelegateByteBuddyMockMaker.java:352)
        at org.mockito.internal.creation.bytebuddy.InlineByteBuddyMockMaker.createMock(InlineByteBuddyMockMaker.java:56)
        at org.mockito.internal.util.MockUtil.createMock(MockUtil.java:99)
        at org.mockito.internal.MockitoCore.mock(MockitoCore.java:84)
        at org.mockito.Mockito.mock(Mockito.java:2104)
        at org.mockito.internal.configuration.MockAnnotationProcessor.processAnnotationForMock(MockAnnotationProcessor.java:79)
        at org.mockito.internal.configuration.MockAnnotationProcessor.process(MockAnnotationProcessor.java:28)
        at org.mockito.internal.configuration.MockAnnotationProcessor.process(MockAnnotationProcessor.java:25)
        at org.mockito.internal.configuration.IndependentAnnotationEngine.createMockFor(IndependentAnnotationEngine.java:44)
        at org.mockito.internal.configuration.IndependentAnnotationEngine.process(IndependentAnnotationEngine.java:72)
        at org.mockito.internal.configuration.InjectingAnnotationEngine.processIndependentAnnotations(InjectingAnnotationEngine.java:62)
        at org.mockito.internal.configuration.InjectingAnnotationEngine.process(InjectingAnnotationEngine.java:47)
        at org.mockito.MockitoAnnotations.openMocks(MockitoAnnotations.java:81)     
        ... 74 more
Caused by: java.lang.IllegalArgumentException: Java 21 (65) is not supported by the current version of Byte Buddy which officially supports Java 20 (64) - update Byte Buddy or set net.bytebuddy.experimental as a VM property
        at net.bytebuddy.utility.OpenedClassReader.of(OpenedClassReader.java:96)    
        at net.bytebuddy.dynamic.scaffold.TypeWriter$Default$ForInlining.create(TypeWriter.java:4011)
        at net.bytebuddy.dynamic.scaffold.TypeWriter$Default.make(TypeWriter.java:2224)
        at net.bytebuddy.dynamic.DynamicType$Builder$AbstractBase$UsingTypeWriter.make(DynamicType.java:4050)
        at net.bytebuddy.dynamic.DynamicType$Builder$AbstractBase.make(DynamicType.java:3734)
        at org.mockito.internal.creation.bytebuddy.InlineBytecodeGenerator.transform(InlineBytecodeGenerator.java:402)
        at java.instrument/java.lang.instrument.ClassFileTransformer.transform(ClassFileTransformer.java:244)
        at java.instrument/sun.instrument.TransformerManager.transform(TransformerManager.java:188)
        at java.instrument/sun.instrument.InstrumentationImpl.transform(InstrumentationImpl.java:610)
        at java.instrument/sun.instrument.InstrumentationImpl.retransformClasses0(Native Method)
        at java.instrument/sun.instrument.InstrumentationImpl.retransformClasses(InstrumentationImpl.java:225)
        at org.mockito.internal.creation.bytebuddy.InlineBytecodeGenerator.triggerRetransformation(InlineBytecodeGenerator.java:281)
        ... 96 more

[INFO] 
[INFO] Results:
[INFO]
[ERROR] Errors: 
[ERROR]   PretServiceTest.setUp:56 Mockito 
Mockito cannot mock this class: interface com.biblio.repository.AdherentRepository. 

If you're not sure why you're getting this error, please open an issue on GitHub.   


Java               : 21
JVM vendor name    : Eclipse Adoptium
JVM vendor version : 21.0.7+6-LTS
JVM name           : OpenJDK 64-Bit Server VM
JVM version        : 21.0.7+6-LTS
JVM info           : mixed mode, sharing
OS name            : Windows 11
OS version         : 10.0


You are seeing this disclaimer because Mockito is configured to create inlined mocks.
You can learn about inline mocks and their limitations under item #39 of the Mockito class javadoc.

Underlying exception : org.mockito.exceptions.base.MockitoException: Could not modify all classes [interface org.springframework.data.jpa.repository.JpaRepository, interface org.springframework.data.repository.Repository, interface org.springframework.data.repository.query.QueryByExampleExecutor, interface org.springframework.data.repository.PagingAndSortingRepository, interface org.springframework.data.repository.CrudRepository, interface com.biblio.repository.AdherentRepository]
[ERROR]   PretServiceTest.setUp:56 Mockito 
Mockito cannot mock this class: interface com.biblio.repository.AdherentRepository. 

If you're not sure why you're getting this error, please open an issue on GitHub.   


Java               : 21
JVM vendor name    : Eclipse Adoptium
JVM vendor version : 21.0.7+6-LTS
JVM name           : OpenJDK 64-Bit Server VM
JVM version        : 21.0.7+6-LTS
JVM info           : mixed mode, sharing
OS name            : Windows 11
OS version         : 10.0


You are seeing this disclaimer because Mockito is configured to create inlined mocks.
You can learn about inline mocks and their limitations under item #39 of the Mockito class javadoc.

Underlying exception : org.mockito.exceptions.base.MockitoException: Could not modify all classes [interface org.springframework.data.jpa.repository.JpaRepository, interface org.springframework.data.repository.Repository, interface org.springframework.data.repository.query.QueryByExampleExecutor, interface org.springframework.data.repository.PagingAndSortingRepository, interface org.springframework.data.repository.CrudRepository, interface com.biblio.repository.AdherentRepository]
[ERROR]   PretServiceTest.setUp:56 Mockito 
Mockito cannot mock this class: interface com.biblio.repository.AdherentRepository. 

If you're not sure why you're getting this error, please open an issue on GitHub.   


Java               : 21
JVM vendor name    : Eclipse Adoptium
JVM vendor version : 21.0.7+6-LTS
JVM name           : OpenJDK 64-Bit Server VM
JVM version        : 21.0.7+6-LTS
JVM info           : mixed mode, sharing
OS name            : Windows 11
OS version         : 10.0


You are seeing this disclaimer because Mockito is configured to create inlined mocks.
You can learn about inline mocks and their limitations under item #39 of the Mockito class javadoc.

Underlying exception : org.mockito.exceptions.base.MockitoException: Could not modify all classes [interface org.springframework.data.jpa.repository.JpaRepository, interface org.springframework.data.repository.Repository, interface org.springframework.data.repository.query.QueryByExampleExecutor, interface org.springframework.data.repository.PagingAndSortingRepository, interface org.springframework.data.repository.CrudRepository, interface com.biblio.repository.AdherentRepository]
[ERROR]   PretServiceTest.setUp:56 Mockito 
Mockito cannot mock this class: interface com.biblio.repository.AdherentRepository. 

If you're not sure why you're getting this error, please open an issue on GitHub.   


Java               : 21
JVM vendor name    : Eclipse Adoptium
JVM vendor version : 21.0.7+6-LTS
JVM name           : OpenJDK 64-Bit Server VM
JVM version        : 21.0.7+6-LTS
JVM info           : mixed mode, sharing
OS name            : Windows 11
OS version         : 10.0


You are seeing this disclaimer because Mockito is configured to create inlined mocks.
You can learn about inline mocks and their limitations under item #39 of the Mockito class javadoc.

Underlying exception : org.mockito.exceptions.base.MockitoException: Could not modify all classes [interface org.springframework.data.jpa.repository.JpaRepository, interface org.springframework.data.repository.Repository, interface org.springframework.data.repository.query.QueryByExampleExecutor, interface org.springframework.data.repository.PagingAndSortingRepository, interface org.springframework.data.repository.CrudRepository, interface com.biblio.repository.AdherentRepository]
[ERROR]   PretServiceTest.setUp:56 Mockito 
Mockito cannot mock this class: interface com.biblio.repository.AdherentRepository. 

If you're not sure why you're getting this error, please open an issue on GitHub.   


Java               : 21
JVM vendor name    : Eclipse Adoptium
JVM vendor version : 21.0.7+6-LTS
JVM name           : OpenJDK 64-Bit Server VM
JVM version        : 21.0.7+6-LTS
JVM info           : mixed mode, sharing
OS name            : Windows 11
OS version         : 10.0


You are seeing this disclaimer because Mockito is configured to create inlined mocks.
You can learn about inline mocks and their limitations under item #39 of the Mockito class javadoc.

Underlying exception : org.mockito.exceptions.base.MockitoException: Could not modify all classes [interface org.springframework.data.jpa.repository.JpaRepository, interface org.springframework.data.repository.Repository, interface org.springframework.data.repository.query.QueryByExampleExecutor, interface org.springframework.data.repository.PagingAndSortingRepository, interface org.springframework.data.repository.CrudRepository, interface com.biblio.repository.AdherentRepository]
[ERROR]   PretServiceTest.setUp:56 Mockito 
Mockito cannot mock this class: interface com.biblio.repository.AdherentRepository. 

If you're not sure why you're getting this error, please open an issue on GitHub.   


Java               : 21
JVM vendor name    : Eclipse Adoptium
JVM vendor version : 21.0.7+6-LTS
JVM name           : OpenJDK 64-Bit Server VM
JVM version        : 21.0.7+6-LTS
JVM info           : mixed mode, sharing
OS name            : Windows 11
OS version         : 10.0


You are seeing this disclaimer because Mockito is configured to create inlined mocks.
You can learn about inline mocks and their limitations under item #39 of the Mockito class javadoc.

Underlying exception : org.mockito.exceptions.base.MockitoException: Could not modify all classes [interface org.springframework.data.jpa.repository.JpaRepository, interface org.springframework.data.repository.Repository, interface org.springframework.data.repository.query.QueryByExampleExecutor, interface org.springframework.data.repository.PagingAndSortingRepository, interface org.springframework.data.repository.CrudRepository, interface com.biblio.repository.AdherentRepository]
[INFO]
[ERROR] Tests run: 6, Failures: 0, Errors: 6, Skipped: 0
[INFO]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD FAILURE
[INFO] ------------------------------------------------------------------------     
[INFO] Total time:  11.345 s
[INFO] Finished at: 2025-07-12T15:21:09+03:00
[INFO] ------------------------------------------------------------------------     
[ERROR] Failed to execute goal org.apache.maven.plugins:maven-surefire-plugin:3.2.5:test (default-test) on project bibli:
[ERROR]
[ERROR] Please refer to C:\Users\ORNELLA\Documents\S4\Naina\Bibliotheques\projet_final\projet-web-dynamique-S4\bibli\target\surefire-reports for the individual test results.
[ERROR] Please refer to dump files (if any exist) [date].dump, [date]-jvmRun[N].dump and [date].dumpstream.
[ERROR] -> [Help 1]
[ERROR]
[ERROR] To see the full stack trace of the errors, re-run Maven with the -e switch. 
[ERROR] Re-run Maven using the -X switch to enable full debug logging.
[ERROR]
[ERROR] For more information about the errors and possible solutions, please read the following articles:
[ERROR] [Help 1] http://cwiki.apache.org/confluence/display/MAVEN/MojoFailureException

quand j'ai verifier quel JDK Maven utilisait réellement avec la commande mvn -version, voici ce que j'ai obtenu :
>mvn -version
Picked up JAVA_TOOL_OPTIONS: -Dstdout.encoding=UTF-8 -Dstderr.encoding=UTF-8
Apache Maven 3.9.10 (5f519b97e944483d878815739f519b2eade0a91d)
Maven home: C:\Users\ORNELLA\AppData\Roaming\Code\User\globalStorage\pleiades.java-extension-pack-jdk\maven\latest
Java version: 21.0.7, vendor: Eclipse Adoptium, runtime: C:\Users\ORNELLA\AppData\Roaming\Code\User\globalStorage\pleiades.java-extension-pack-jdk\java\21
Default locale: fr_FR, platform encoding: UTF-8
OS name: "windows 11", version: "10.0", arch: "amd64", family: "windows"

et quand je fais cette commande dir C:\Program Files\Java pour rechercher d'autres installations de Java sur mon systeme, j'obtiens :
dir C:\Program Files\Java
Le fichier spécifié est introuvable.

j'ai fais ceci pour m'assurer que JAVA_HOME ne soit defini uniquement que pour Java 17 :
set JAVA_HOME=C:\Program Files\Java\jdk-17

et apres j'ai fermé mon vscode puis l'ait reouvert pour appliquer les changements :
mvn -version
mais j'ai obtenu :
Picked up JAVA_TOOL_OPTIONS: -Dstdout.encoding=UTF-8 -Dstderr.encoding=UTF-8
Apache Maven 3.9.10 (5f519b97e944483d878815739f519b2eade0a91d)
Maven home: C:\Users\ORNELLA\AppData\Roaming\Code\User\globalStorage\pleiades.java-extension-pack-jdk\maven\latest
Java version: 21.0.7, vendor: Eclipse Adoptium, runtime: C:\Users\ORNELLA\AppData\Roaming\Code\User\globalStorage\pleiades.java-extension-pack-jdk\java\21
Default locale: fr_FR, platform encoding: UTF-8
OS name: "windows 11", version: "10.0", arch: "amd64", family: "windows"

j'ai deja synchroniser VS Code avec le Projet Maven en assurant que les extensions nécessaires sont déja installées dans mon vscode


voici PretService au complet pour que vous puissiez y apporter les modifications necessaire genre utiliser Mockito et tout... :
package com.biblio.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import org.mockito.MockitoAnnotations;

import com.biblio.exception.PretException;
import com.biblio.model.Abonnement;
import com.biblio.model.Adherent;
import com.biblio.model.Exemplaire;
import com.biblio.model.Livre;
import com.biblio.model.Pret;
import com.biblio.model.Profil;
import com.biblio.repository.AbonnementRepository;
import com.biblio.repository.AdherentRepository;
import com.biblio.repository.ExemplaireRepository;
import com.biblio.repository.JourFerieRepository;
import com.biblio.repository.PretRepository;

public class PretServiceTest {

    @Mock
    private AdherentRepository adherentRepository;

    @Mock
    private ExemplaireRepository exemplaireRepository;

    @Mock
    private PretRepository pretRepository;

    @Mock
    private AbonnementRepository abonnementRepository;

    @Mock
    private JourFerieRepository jourFerieRepository;

    @InjectMocks
    private PretService pretService;

    @BeforeEach
    public void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    public void testPreterExemplaireSuccess() {
        Adherent adherent = new Adherent();
        adherent.setIdAdherent(1);
        adherent.setStatut(Adherent.StatutAdherent.ACTIF);
        adherent.setDateNaissance(LocalDate.of(2000, 1, 1));
        Profil profil = new Profil();
        profil.setQuotaPret(3);
        profil.setDureePret(7);
        profil.setTypeProfil(Profil.TypeProfil.ETUDIANT);
        adherent.setProfil(profil);
        adherent.setQuotaRestant(3);

        Exemplaire exemplaire = new Exemplaire();
        exemplaire.setIdExemplaire(1);
        exemplaire.setStatut(Exemplaire.StatutExemplaire.DISPONIBLE);
        Livre livre = new Livre();
        livre.setRestrictionAge(0);
        livre.setProfesseurSeulement(false);
        exemplaire.setLivre(livre);

        Abonnement abonnement = new Abonnement();
        abonnement.setStatut(Abonnement.StatutAbonnement.ACTIVE);
        abonnement.setDateDebut(LocalDate.now().minusDays(10));
        abonnement.setDateFin(LocalDate.now().plusDays(10));

        when(adherentRepository.findById(eq(1))).thenReturn(Optional.of(adherent));
        when(exemplaireRepository.findById(eq(1))).thenReturn(Optional.of(exemplaire));
        when(abonnementRepository.findActiveAbonnementByAdherent(eq(1), any(LocalDate.class))).thenReturn(abonnement);
        when(pretRepository.countActivePretsByAdherent(eq(1))).thenReturn(0L);
        when(jourFerieRepository.findByDateFerieBetween(any(LocalDate.class), any(LocalDate.class))).thenReturn(Collections.emptyList());
        when(pretRepository.save(any(Pret.class))).thenAnswer(invocation -> {
            Pret pret = invocation.getArgument(0);
            pret.setIdPret(1);
            return pret;
        });

        Pret pret = pretService.preterExemplaire(1, 1, "DOMICILE");

        verify(pretRepository, times(1)).save(any(Pret.class));
        verify(exemplaireRepository, times(1)).save(exemplaire);
        verify(adherentRepository, times(1)).save(adherent);
        assertEquals(Exemplaire.StatutExemplaire.EN_PRET, exemplaire.getStatut());
        assertEquals(2, adherent.getQuotaRestant());
        assertEquals(1, pret.getIdPret());
    }

    @Test
    public void testPreterExemplaireAdherentNonExistant() {
        when(adherentRepository.findById(eq(1))).thenReturn(Optional.empty());
        PretException exception = assertThrows(PretException.class,
                () -> pretService.preterExemplaire(1, 1, "DOMICILE"));
        assertEquals("L'adhérent n'existe pas.", exception.getMessage());
    }

    @Test
    public void testPreterExemplaireQuotaDepasse() {
        Adherent adherent = new Adherent();
        adherent.setIdAdherent(1);
        adherent.setStatut(Adherent.StatutAdherent.ACTIF);
        adherent.setDateNaissance(LocalDate.of(2000, 1, 1));
        Profil profil = new Profil();
        profil.setQuotaPret(3);
        profil.setDureePret(7);
        profil.setTypeProfil(Profil.TypeProfil.ETUDIANT);
        adherent.setProfil(profil);
        adherent.setQuotaRestant(0);

        Abonnement abonnement = new Abonnement();
        abonnement.setStatut(Abonnement.StatutAbonnement.ACTIVE);
        abonnement.setDateDebut(LocalDate.now().minusDays(10));
        abonnement.setDateFin(LocalDate.now().plusDays(10));

        Exemplaire exemplaire = new Exemplaire();
        exemplaire.setIdExemplaire(1);
        exemplaire.setStatut(Exemplaire.StatutExemplaire.DISPONIBLE);
        Livre livre = new Livre();
        livre.setRestrictionAge(0);
        livre.setProfesseurSeulement(false);
        exemplaire.setLivre(livre);

        when(adherentRepository.findById(eq(1))).thenReturn(Optional.of(adherent));
        when(abonnementRepository.findActiveAbonnementByAdherent(eq(1), any(LocalDate.class))).thenReturn(abonnement);
        when(exemplaireRepository.findById(eq(1))).thenReturn(Optional.of(exemplaire));
        when(pretRepository.countActivePretsByAdherent(eq(1))).thenReturn(3L);

        PretException exception = assertThrows(PretException.class,
                () -> pretService.preterExemplaire(1, 1, "DOMICILE"));
        assertEquals("L'adhérent a atteint son quota de prêts.", exception.getMessage());
    }

    @Test
    public void testRetournerExemplaireSuccess() {
        Adherent adherent = new Adherent();
        adherent.setIdAdherent(1);
        adherent.setQuotaRestant(2);
        Profil profil = new Profil();
        profil.setQuotaPret(3);
        adherent.setProfil(profil);

        Exemplaire exemplaire = new Exemplaire();
        exemplaire.setIdExemplaire(1);
        exemplaire.setStatut(Exemplaire.StatutExemplaire.EN_PRET);

        Pret pret = new Pret();
        pret.setIdPret(1);
        pret.setAdherent(adherent);
        pret.setExemplaire(exemplaire);
        pret.setDateRetourEffective(null);

        when(pretRepository.findById(eq(1))).thenReturn(Optional.of(pret));

        pretService.retournerExemplaire(1);

        verify(pretRepository, times(1)).save(pret);
        verify(exemplaireRepository, times(1)).save(exemplaire);
        verify(adherentRepository, times(1)).save(adherent);
        assertEquals(Exemplaire.StatutExemplaire.DISPONIBLE, exemplaire.getStatut());
        assertEquals(3, adherent.getQuotaRestant());
        assertEquals(LocalDateTime.now().getDayOfYear(), pret.getDateRetourEffective().getDayOfYear());
    }

    @Test
    public void testRetournerExemplairePretNonExistant() {
        when(pretRepository.findById(eq(1))).thenReturn(Optional.empty());
        PretException exception = assertThrows(PretException.class,
                () -> pretService.retournerExemplaire(1));
        assertEquals("Le prêt n'existe pas.", exception.getMessage());
    }

    @Test
    public void testRetournerExemplaireDejaRetourne() {
        Adherent adherent = new Adherent();
        adherent.setIdAdherent(1);
        adherent.setQuotaRestant(2);

        Exemplaire exemplaire = new Exemplaire();
        exemplaire.setIdExemplaire(1);
        exemplaire.setStatut(Exemplaire.StatutExemplaire.DISPONIBLE);

        Pret pret = new Pret();
        pret.setIdPret(1);
        pret.setAdherent(adherent);
        pret.setExemplaire(exemplaire);
        pret.setDateRetourEffective(LocalDateTime.now());

        when(pretRepository.findById(eq(1))).thenReturn(Optional.of(pret));

        PretException exception = assertThrows(PretException.class,
                () -> pretService.retournerExemplaire(1));
        assertEquals("Le prêt a déjà été retourné.", exception.getMessage());
    }
}

le test n'a pas echouer avec mvn clean install -U mais plutot quand je l'ai lancer avec mvn spring-boot:run, j'ai obtenu ces erreurs :
>mvn spring-boot:run
Picked up JAVA_TOOL_OPTIONS: -Dstdout.encoding=UTF-8 -Dstderr.encoding=UTF-8
[INFO] Scanning for projects...
[INFO] 
[INFO] --------------------------< com.biblio:bibli >--------------------------
[INFO] Building gestion-bibliotheque 0.0.1-SNAPSHOT
[INFO]   from pom.xml
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] 
[INFO] >>> spring-boot:2.7.18:run (default-cli) > test-compile @ bibli >>>
[INFO] 
[INFO] --- resources:3.2.0:resources (default-resources) @ bibli ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Using 'UTF-8' encoding to copy filtered properties files.
[INFO] Copying 1 resource
[INFO] Copying 2 resources
[INFO]
[INFO] --- compiler:3.13.0:compile (default-compile) @ bibli ---
[INFO] Nothing to compile - all classes are up to date.
[INFO]
[INFO] --- resources:3.2.0:testResources (default-testResources) @ bibli ---        
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Using 'UTF-8' encoding to copy filtered properties files.
[INFO] skip non existing resourceDirectory C:\Users\ORNELLA\Documents\S4\Naina\Bibliotheques\projet_final\projet-web-dynamique-S4\bibli\src\test\resources
[INFO]
[INFO] --- compiler:3.13.0:testCompile (default-testCompile) @ bibli ---
[INFO] Nothing to compile - all classes are up to date.
[INFO]
[INFO] <<< spring-boot:2.7.18:run (default-cli) < test-compile @ bibli <<<
[INFO]
[INFO]
[INFO] --- spring-boot:2.7.18:run (default-cli) @ bibli ---
[INFO] Attaching agents: []
Picked up JAVA_TOOL_OPTIONS: -Dstdout.encoding=UTF-8 -Dstderr.encoding=UTF-8

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::               (v2.7.18)

2025-07-13 12:33:05.329  INFO 19660 --- [           main] com.biblio.Application                   : Starting Application using Java 21.0.7 on Nella with PID 19660 (C:\Users\ORNELLA\Documents\S4\Naina\Bibliotheques\projet_final\projet-web-dynamique-S4\bibli\target\classes started by ORNELLA in C:\Users\ORNELLA\Documents\S4\Naina\Bibliotheques\projet_final\projet-web-dynamique-S4\bibli)
2025-07-13 12:33:05.333  INFO 19660 --- [           main] com.biblio.Application                   : No active profile set, falling back to 1 default profile: "default"
2025-07-13 12:33:06.338  INFO 19660 --- [           main] .s.d.r.c.RepositoryConfigurationDelegate : Bootstrapping Spring Data JPA repositories in DEFAULT mode.        
2025-07-13 12:33:06.463  INFO 19660 --- [           main] .s.d.r.c.RepositoryConfigurationDelegate : Finished Spring Data repository scanning in 109 ms. Found 7 JPA repository interfaces.
2025-07-13 12:33:07.522  INFO 19660 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat initialized with port(s): 8081 (http)
2025-07-13 12:33:07.545  INFO 19660 --- [           main] o.apache.catalina.core.StandardService   : Starting service [Tomcat]
2025-07-13 12:33:07.546  INFO 19660 --- [           main] org.apache.catalina.core.StandardEngine  : Starting Servlet engine: [Apache Tomcat/9.0.83]
2025-07-13 12:33:08.044  INFO 19660 --- [           main] org.apache.jasper.servlet.TldScanner     : At least one JAR was scanned for TLDs yet contained no TLDs. Enable debug logging for this logger for a complete list of JARs that were scanned but no TLDs were found in them. Skipping unneeded JARs during scanning can improve startup time and JSP compilation time.
2025-07-13 12:33:08.061  INFO 19660 --- [           main] o.a.c.c.C.[Tomcat].[localhost].[/]       : Initializing Spring embedded WebApplicationContext
2025-07-13 12:33:08.062  INFO 19660 --- [           main] w.s.c.ServletWebServerApplicationContext : Root WebApplicationContext: initialization completed in 2640 ms    
2025-07-13 12:33:08.352  INFO 19660 --- [           main] o.hibernate.jpa.internal.util.LogHelper  : HHH000204: Processing PersistenceUnitInfo [name: default]
2025-07-13 12:33:08.440  INFO 19660 --- [           main] org.hibernate.Version                    : HHH000412: Hibernate ORM core version 5.6.15.Final
2025-07-13 12:33:08.446  WARN 19660 --- [           main] ConfigServletWebServerApplicationContext : Exception encountered during context initialization - cancelling refresh attempt: org.springframework.beans.factory.BeanCreationException: Error creating bean with name 'entityManagerFactory' defined in class path resource [org/springframework/boot/autoconfigure/orm/jpa/HibernateJpaConfiguration.class]: Invocation of init method failed; nested exception is java.lang.NoClassDefFoundError: net/bytebuddy/NamingStrategy$SuffixingRandom$BaseNameResolver
2025-07-13 12:33:08.450  INFO 19660 --- [           main] o.apache.catalina.core.StandardService   : Stopping service [Tomcat]
2025-07-13 12:33:08.467  INFO 19660 --- [           main] ConditionEvaluationReportLoggingListener :

Error starting ApplicationContext. To display the conditions report re-run your application with 'debug' enabled.
2025-07-13 12:33:08.507 ERROR 19660 --- [           main] o.s.boot.SpringApplication               : Application run failed

org.springframework.beans.factory.BeanCreationException: Error creating bean with name 'entityManagerFactory' defined in class path resource [org/springframework/boot/autoconfigure/orm/jpa/HibernateJpaConfiguration.class]: Invocation of init method failed; nested exception is java.lang.NoClassDefFoundError: net/bytebuddy/NamingStrategy$SuffixingRandom$BaseNameResolver
        at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.initializeBean(AbstractAutowireCapableBeanFactory.java:1804) ~[spring-beans-5.3.31.jar:5.3.31]
        at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.doCreateBean(AbstractAutowireCapableBeanFactory.java:620) ~[spring-beans-5.3.31.jar:5.3.31]
        at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.createBean(AbstractAutowireCapableBeanFactory.java:542) ~[spring-beans-5.3.31.jar:5.3.31]
        at org.springframework.beans.factory.support.AbstractBeanFactory.lambda$doGetBean$0(AbstractBeanFactory.java:335) ~[spring-beans-5.3.31.jar:5.3.31]
        at org.springframework.beans.factory.support.DefaultSingletonBeanRegistry.getSingleton(DefaultSingletonBeanRegistry.java:234) ~[spring-beans-5.3.31.jar:5.3.31] 
        at org.springframework.beans.factory.support.AbstractBeanFactory.doGetBean(AbstractBeanFactory.java:333) ~[spring-beans-5.3.31.jar:5.3.31]
        at org.springframework.beans.factory.support.AbstractBeanFactory.getBean(AbstractBeanFactory.java:208) ~[spring-beans-5.3.31.jar:5.3.31]
        at org.springframework.context.support.AbstractApplicationContext.getBean(AbstractApplicationContext.java:1168) ~[spring-context-5.3.31.jar:5.3.31]
        at org.springframework.context.support.AbstractApplicationContext.finishBeanFactoryInitialization(AbstractApplicationContext.java:919) ~[spring-context-5.3.31.jar:5.3.31]
        at org.springframework.context.support.AbstractApplicationContext.refresh(AbstractApplicationContext.java:591) ~[spring-context-5.3.31.jar:5.3.31]
        at org.springframework.boot.web.servlet.context.ServletWebServerApplicationContext.refresh(ServletWebServerApplicationContext.java:147) ~[spring-boot-2.7.18.jar:2.7.18]
        at org.springframework.boot.SpringApplication.refresh(SpringApplication.java:732) ~[spring-boot-2.7.18.jar:2.7.18]
        at org.springframework.boot.SpringApplication.refreshContext(SpringApplication.java:409) ~[spring-boot-2.7.18.jar:2.7.18]
        at org.springframework.boot.SpringApplication.run(SpringApplication.java:308) ~[spring-boot-2.7.18.jar:2.7.18]
        at org.springframework.boot.SpringApplication.run(SpringApplication.java:1300) ~[spring-boot-2.7.18.jar:2.7.18]
        at org.springframework.boot.SpringApplication.run(SpringApplication.java:1289) ~[spring-boot-2.7.18.jar:2.7.18]
        at com.biblio.Application.main(Application.java:11) ~[classes/:na]
Caused by: java.lang.NoClassDefFoundError: net/bytebuddy/NamingStrategy$SuffixingRandom$BaseNameResolver
        at org.hibernate.cfg.Environment.buildBytecodeProvider(Environment.java:345) ~[hibernate-core-5.6.15.Final.jar:5.6.15.Final]
        at org.hibernate.cfg.Environment.buildBytecodeProvider(Environment.java:337) ~[hibernate-core-5.6.15.Final.jar:5.6.15.Final]
        at org.hibernate.cfg.Environment.<clinit>(Environment.java:230) ~[hibernate-core-5.6.15.Final.jar:5.6.15.Final]
        at org.hibernate.jpa.boot.internal.EntityManagerFactoryBuilderImpl$MergedSettings.<init>(EntityManagerFactoryBuilderImpl.java:1616) ~[hibernate-core-5.6.15.Final.jar:5.6.15.Final]
        at org.hibernate.jpa.boot.internal.EntityManagerFactoryBuilderImpl$MergedSettings.<init>(EntityManagerFactoryBuilderImpl.java:1606) ~[hibernate-core-5.6.15.Final.jar:5.6.15.Final]
        at org.hibernate.jpa.boot.internal.EntityManagerFactoryBuilderImpl.mergeSettings(EntityManagerFactoryBuilderImpl.java:505) ~[hibernate-core-5.6.15.Final.jar:5.6.15.Final]
        at org.hibernate.jpa.boot.internal.EntityManagerFactoryBuilderImpl.<init>(EntityManagerFactoryBuilderImpl.java:231) ~[hibernate-core-5.6.15.Final.jar:5.6.15.Final]
        at org.hibernate.jpa.boot.internal.EntityManagerFactoryBuilderImpl.<init>(EntityManagerFactoryBuilderImpl.java:182) ~[hibernate-core-5.6.15.Final.jar:5.6.15.Final]
        at org.springframework.orm.jpa.vendor.SpringHibernateJpaPersistenceProvider.createContainerEntityManagerFactory(SpringHibernateJpaPersistenceProvider.java:52) ~[spring-orm-5.3.31.jar:5.3.31]
        at org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean.createNativeEntityManagerFactory(LocalContainerEntityManagerFactoryBean.java:365) ~[spring-orm-5.3.31.jar:5.3.31]
        at org.springframework.orm.jpa.AbstractEntityManagerFactoryBean.buildNativeEntityManagerFactory(AbstractEntityManagerFactoryBean.java:409) ~[spring-orm-5.3.31.jar:5.3.31]
        at org.springframework.orm.jpa.AbstractEntityManagerFactoryBean.afterPropertiesSet(AbstractEntityManagerFactoryBean.java:396) ~[spring-orm-5.3.31.jar:5.3.31]   
        at org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean.afterPropertiesSet(LocalContainerEntityManagerFactoryBean.java:341) ~[spring-orm-5.3.31.jar:5.3.31]
        at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.invokeInitMethods(AbstractAutowireCapableBeanFactory.java:1863) ~[spring-beans-5.3.31.jar:5.3.31]
        at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.initializeBean(AbstractAutowireCapableBeanFactory.java:1800) ~[spring-beans-5.3.31.jar:5.3.31]
        ... 16 common frames omitted
Caused by: java.lang.ClassNotFoundException: net.bytebuddy.NamingStrategy$SuffixingRandom$BaseNameResolver
        at java.base/jdk.internal.loader.BuiltinClassLoader.loadClass(BuiltinClassLoader.java:641) ~[na:na]
        at java.base/jdk.internal.loader.ClassLoaders$AppClassLoader.loadClass(ClassLoaders.java:188) ~[na:na]
        at java.base/java.lang.ClassLoader.loadClass(ClassLoader.java:526) ~[na:na] 
        ... 31 common frames omitted

[INFO] ------------------------------------------------------------------------
[INFO] BUILD FAILURE
[INFO] ------------------------------------------------------------------------     
[INFO] Total time:  8.419 s
[INFO] Finished at: 2025-07-13T12:33:08+03:00
[INFO] ------------------------------------------------------------------------     
[ERROR] Failed to execute goal org.springframework.boot:spring-boot-maven-plugin:2.7.18:run (default-cli) on project bibli: Application finished with exit code: 1 -> [Help 1]
[ERROR]
[ERROR] To see the full stack trace of the errors, re-run Maven with the -e switch. 
[ERROR] Re-run Maven using the -X switch to enable full debug logging.
[ERROR]
[ERROR] For more information about the errors and possible solutions, please read the following articles:
[ERROR] [Help 1] http://cwiki.apache.org/confluence/display/MAVEN/MojoExecutionException


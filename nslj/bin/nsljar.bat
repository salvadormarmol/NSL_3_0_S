@echo off
jar -cvf nsl.jar -C nslj/src/main NslMain.class 
jar -uvf nsl.jar -C nslj/src/main NslApplet.class 
jar -uvf nsl.jar nslj\src\cmd\*.class
jar -uvf nsl.jar nslj\src\display\*.class
jar -uvf nsl.jar nslj\src\display\images\*.gif
jar -uvf nsl.jar nslj\src\exceptions\*.class
jar -uvf nsl.jar nslj\src\lang\*.class
jar -uvf nsl.jar nslj\src\math\*.class
jar -uvf nsl.jar nslj\src\system\*.class
jar -uvf nsl.jar nslj\src\nsls\struct\*.class
@echo on

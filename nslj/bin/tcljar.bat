@echo off
jar -cvf tcljava.jar tcl\lang\*.class
jar -uvf tcljava.jar tcl\lang\library\java\*.tcl
jar -uvf tcljava.jar tcl\lang\reflect\*.class
@echo on
@echo off
jar -cvf jacl.jar com\oroinc\text\regex\*.class
jar -uvf jacl.jar tcl\lang\*.class
jar -uvf jacl.jar tcl\lang\library\*
jar -uvf jacl.jar tcl\regex\*.class
@echo on
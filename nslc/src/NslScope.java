
/* SCCS  %W--- %G% -- %U% */

// Copyright: Copyright (c) 1997-2002 University of Southern California Brain Project.
// Copyright: This software may be freely copied provided the toplevel
// Copyright: COPYRIGHT file is included with each such copy.
// Copyright: Email nsl@java.usc.edu.

// Author: Salvador Marmol

//
// NslScope.java
//
//////////////////////////////////////////////////////////////////////

import java.util.*;
import java.io.*;
import java.lang.*;

public class NslScope {

    private String packageName;
    private String className;
    private String superClassName;
    private String classKind;
    private String fileName;
    private String fullFileName;

    private Vector importList;
    private Vector classes;
  
    private int    currentTempNumber;
    private Vector tempVarList;

    private Vector currentVarScope;
    private Vector classVarScope;
    private Vector classMethodScope;

    private Vector interfaceList;
    private Vector subInterfaceList;
    private Vector subClassList;

    private Stack varScope;

    private ASTFormalParameters classFormals;
    private ASTArguments        classArguments;

    private NslScope superClassScope;
    private NslScope containerScope;

    private ASTCompilationUnit ast;

    private static boolean verbose = false;

    private boolean generateCode = false;

    private boolean staticScope = false;

    public NslScope() {

	packageName    = null;		    
	className      = null;		    
	superClassName = null;		    

	classFormals   = null;
        classArguments = null;

	importList     = new Vector(2,2);   
	classes        = new Vector(1,1);

	classVarScope  = currentVarScope = new Vector(); 

	varScope       = new Stack();

        classMethodScope  = new Vector();

	currentTempNumber = 0;
	tempVarList       = new Vector();

	subClassList      = new Vector();
	interfaceList     = new Vector();
	subInterfaceList  = new Vector();

	containerScope    = superClassScope   = null;

	importList.addElement("nslj.src.system");
	importList.addElement("nslj.src.cmd");
	importList.addElement("nslj.src.lang");
	importList.addElement("nslj.src.math");
	importList.addElement("nslj.src.display");

    }

    public NslScope(NslScope superClassScope) {
	this();
        this.superClassScope = superClassScope;
    }

    public void setSuperClassScope(NslScope scope) {
	superClassScope = scope;
    }

    public NslScope getSuperClassScope() {
	return superClassScope;
    }

    public void setContainerScope(NslScope scope) {
	containerScope = scope;
    }

    public NslScope getContainerScope() {
	return containerScope;
    }

    public boolean shouldGenerateCode() {
      return generateCode;
    }

    public void setGenerateCode(boolean value) {
      generateCode = value;
    }

    public void setAST(ASTCompilationUnit ast) {
	this.ast = ast;
    }

    public ASTCompilationUnit getAST() {
	return ast;
    }

    public void setFileName(String name) {
	fileName = name;
    }

    public String getFileName() {
	return fileName;
    }

    public void setFullFileName(String name) {
	fullFileName = name;
    }

    public String getFullFileName() {
	return fullFileName;
    }

    public void setPackage(String name) {
	packageName = name;
    }

    public String getPackage() {
	return packageName;
    }

    public void setClassName(String name) {
	className = name;
    }

    public String getClassName() {
	return className;
    }

    public void setClassKind(String name) {
	classKind = name;
    }

    public String getClassKind() {
	return classKind;
    }

    public void setSuperClassName(String name) {
	superClassName = name;
    }

    public String getSuperClassName() {
	return superClassName;
    }

    public Vector getImportList() {
	return importList;
    }

    public Vector getSubClassList() {
	return subClassList;
    }

    public Vector getInterfaceList() {
	return interfaceList;
    }

    public Vector getSubInterfaceList() {
	return subInterfaceList;
    }

    public void addImportPackage(String importPackage) {
    
	if (verbose) {
	    System.err.println("NslScope [Verbose]: Adding module ["+importPackage+"] to the module import list");
	}
	
	importList.addElement(importPackage);	
    }

    public void setStaticScope(boolean value) {
	staticScope = value;
    }

    public boolean isStaticScope() {
	return staticScope;
    }

    public Vector getClassMethodScope() {
	return classMethodScope;
    }

    public void addMethod(NslMethod method) {
	classMethodScope.addElement(method);
    }

    public void addSubClass(NslScope scope) {
	subClassList.addElement(scope);
    }

    public void addInterface(NslScope scope) {
	interfaceList.addElement(scope);
    }

    public void addSubInterface(NslScope scope) {
	subInterfaceList.addElement(scope);
    }

    public NslScope resolveClass(String type) {

	NslScope scopeTmp;
	String typeName;

	Enumeration enum = subClassList.elements();
	while (enum.hasMoreElements()) {
	    scopeTmp  = (NslScope)enum.nextElement();
	    typeName = scopeTmp.getClassName();
	    if (typeName.endsWith(type)) {
	        return scopeTmp;
	    }
	}

	// Not found in current scope, ask if it is an interface type.

	if (superClassScope!=null) {
	    return superClassScope.resolveClass(type);
	}

	// Not found in current scope, ask if it is a global type.

	return NslCompiler.getNslScope(type);
    }

    public NslScope resolveInterface(String type) {

	NslScope scopeTmp;
	String typeName;

	Enumeration enum = subInterfaceList.elements();
	while (enum.hasMoreElements()) {
	    scopeTmp  = (NslScope)enum.nextElement();
	    typeName = scopeTmp.getClassName();
	    if (typeName.endsWith(type)) {
	        return scopeTmp;
	    }
	}

	// Not found in current scope, ask if it is an interface type.

	if (superClassScope!=null) {
	    return superClassScope.resolveInterface(type);
	}

	// Not found in current scope, ask if it is a global type.

	return NslCompiler.getNslScope(type);
    }

    public NslMethod resolveMethod(String name) {

	Enumeration enum = classMethodScope.elements();

	NslMethod methodTmp;
	String methodName;

	while (enum.hasMoreElements()) {
	    methodTmp  = (NslMethod)enum.nextElement();
	    methodName = methodTmp.getName();
	    if (methodName.equals(name)) {
	        return methodTmp;
	    }
	}

	// look in the parent if I'm a nested class
	if (containerScope!=null) {
	    methodTmp = containerScope.resolveMethod(name);
	    if (methodTmp!=null) {
	        return methodTmp;
	    }
	}

	// look in super class if it exists
	if (superClassScope!=null) {
	    return superClassScope.resolveMethod(name);
	}

        return null;
    }

    public boolean isTypeEqual(String type1, String type2) {
	if (type1.equals(type2)) {
	     return true;
	} else if (type2.equals("int") && type1.equals("float") ||
	    type2.equals("int") && type1.equals("double") ||
	    type2.equals("float") && type1.equals("double")) {
            return true;
	}

	return false;
    }

    public NslMethod resolveMethod(String name, String[] args) {

        if (args==null) {
	   return null;
        }

	Enumeration enum = classMethodScope.elements();

	NslMethod methodTmp;
	String methodName;
        String[] formalTypes;

        String[] tempArgs   = new String[args.length];
        String[] suffixArgs = new String[args.length];
	String[] tempFormals;

        for (int i=0; i<args.length; i++) {
	    args[i]=NslCompiler.getTypeName(args[i]);
	    tempArgs[i]=args[i];
	    suffixArgs[i]="";
	    if (tempArgs[i]!=null && tempArgs[i].indexOf("[")>=0) {
		tempArgs[i]   = args[i].substring(0,args[i].indexOf("["));
		suffixArgs[i] = args[i].substring(args[i].indexOf("["));
	    }
        }
	NslScope typeScope;
        String superName, tempType;
        boolean found;
	int count;

	while (enum.hasMoreElements()) {
	    methodTmp  = (NslMethod)enum.nextElement();
	    methodName = methodTmp.getName();

	    if (methodName.equals(name)) {

		//Found the method

		formalTypes = methodTmp.getFormalTypes();
		if (formalTypes.length == args.length) {

		   // same number of arguments

		   tempFormals = new String[formalTypes.length];

		   for (int i=0; i<formalTypes.length; i++) {
		      formalTypes[i]=NslCompiler.getTypeName(formalTypes[i]);
		      tempFormals[i]= formalTypes[i];
		      if (tempFormals[i]!=null && tempFormals[i].indexOf("[")>=0) {
			tempFormals[i] = tempFormals[i].substring(0,tempFormals[i].indexOf("["));
		      }
                   }

		   count=0;
		   for (int i=0; i<args.length; i++) {

			if (!isTypeEqual(formalTypes[i],args[i])) {

 		            // check if it inherits from them
	                    if (!isPrimitive(tempFormals[i]) && !isPrimitive(tempArgs[i])) {
				found = false;
				tempType = tempArgs[i];
		                while (!found && tempType!=null && ((typeScope = NslCompiler.getNslScope(tempType))!=null)) {
			            superName = NslCompiler.getTypeName(typeScope.getSuperClassName());
			            if (superName!=null && formalTypes[i].equals(superName+suffixArgs[i])) {
        	                       found = true;
		 	            }
				    tempType=superName;
		                }
				//equal = equal && found;
				if (found) {
				  count++;
				}
      		            }
		
                        } else {
			   count++;
			}                    
                   }
		   if (count==args.length) {
	             return methodTmp;
                   }
                } 
	    }
	}

	// look in the parent if I'm a nested class
	if (containerScope!=null) {
	    methodTmp = containerScope.resolveMethod(name, args);
	    if (methodTmp!=null) {
	        return methodTmp;
	    }
	}

	// look in super class if it exists
	if (superClassScope!=null) {
	    return superClassScope.resolveMethod(name, args);
	}

        return null;
    }

    public boolean addLocalVar(NslVariable variable) {
	NslVariable var = resolveLocalVar(variable.getName());
	if (var==null) {
	    currentVarScope.addElement(variable);
	    return true;
        } 
        return false;	    
    }

    public Vector getClassVarScope() {
	return classVarScope;
    }

    public Vector getCurrentVarScope() {
	return currentVarScope;
    }

    public void pushScope() {
	if (currentVarScope!=null) {
	    varScope.push(currentVarScope);
        }
	currentVarScope = new Vector(10,10);
    }

    public void popScope() {
	try {
	    currentVarScope.removeAllElements();
	    currentVarScope = (Vector) varScope.pop();
	}  catch(EmptyStackException stackException) {
	    NslCompiler.printError("NslScope", "Compiler bug. Empty variable scope and at popScope()");
	    //throw stackException;
        }
    }

    public NslVariable resolveLocalVar(String name) {
	Enumeration enum = currentVarScope.elements();
	NslVariable fieldTmp;

	// scan the current scope
	while (enum.hasMoreElements()) {
	    fieldTmp = (NslVariable)enum.nextElement();
	    if (fieldTmp.isVariable(name)) {
 	        return fieldTmp;
	    }
	}

	return null;
    }

    public NslVariable resolveVar(String name) {
	Stack tmpStack;
	Vector scope;

	Enumeration enum = currentVarScope.elements();
	NslVariable fieldTmp;

	// scan the current scope
	while (enum.hasMoreElements()) {
	    fieldTmp = (NslVariable)enum.nextElement();
	    if (fieldTmp.isVariable(name)) {
 	        return fieldTmp;
	    }
	}
    
	// scan outer scope
	tmpStack = new Stack();

	while (!varScope.empty()) {
	    enum = ((Vector)varScope.peek()).elements();

	    while (enum.hasMoreElements()) {
		fieldTmp = (NslVariable)enum.nextElement();
		if (fieldTmp.isVariable(name)) {
		    restoreScope(tmpStack);
		    return fieldTmp;
	        }
	    }

	    // not found in this scope
	    tmpStack.push(varScope.pop());
	}

	// not found in any scope
	restoreScope(tmpStack);

	// look in the parent if I'm a nested class
	if (containerScope!=null) {
	    fieldTmp = containerScope.resolveVar(name);
	    if (fieldTmp!=null) {
	        return fieldTmp;
	    }
	}

	// look in super class if it exists
	if (superClassScope!=null) {
	    return superClassScope.resolveVar(name);
	}

	return null;
    }

    private void restoreScope(Stack tmp) {
	try {
	    while(!tmp.empty()) {
		varScope.push(tmp.pop());
	    }
	} catch (EmptyStackException stackException) {
	    NslCompiler.printError("NslScope",  "Compiler bug. Error reconstructing scope.");
	    throw stackException;
        }
    }

    public String getTempName(String type) {
	String tempName = "__temp"+currentTempNumber;
        String modifier = (staticScope?"static ":"");
	NslVariable variable = new NslVariable(modifier + type, tempName);
	tempVarList.addElement(variable);
	currentTempNumber++;
	return tempName;
    }

    public void addTempVar(NslVariable variable) {
	tempVarList.addElement(variable);
    }

    public Vector getTempVarList() {
	return tempVarList;
    }

    public void setClassFormals(ASTFormalParameters formals) {
	classFormals = formals;
    }

    public ASTFormalParameters getClassFormals() {
	return classFormals;
    }

    public void setClassArguments(ASTArguments formals) {
	classArguments = formals;
    }

    public ASTArguments getClassArguments() {
	return classArguments;
    }

    public boolean isNumeric(String type) {
        if (type!=null && type.indexOf("int")>=0 || type.indexOf("float")>=0 || type.indexOf("double")>=0) {
	    return true;
        }
	return false;
    }

    public boolean isArray(String type) {
//      if (type!=null && isNumeric(type) && type.indexOf("[")>=0) {
      if (type!=null && type.indexOf("[")>=0) {
	return true;
      }
      return false;
    }

    public int getDim(String type) {
      int dim;
      if (isNslType(type)) {
        dim = getNslTypeDim(type);
      } else if (isArray(type)) {
        dim = getArrayDim(type);
      } else {
        dim = 0;
      }
      return dim;
    }

    public int getArrayDim(String type) {
      int dim = ((type.lastIndexOf("[") - type.indexOf("["))/2)+1;
      return dim;
    }

    public int getNslTypeDim(String name) {
        int dim = -1;
	try {
	    dim = (new Integer(name.substring(name.length()-1))).intValue();
	} catch (Exception ex) {}
	return dim;
    }

    public String getNslTypeWithoutPort(String name) {
      if (isNslInPort(name)) {
	int start = name.indexOf("Din");
	return name.substring(0,start) + name.substring(start+3);
      } else if (isNslOutPort(name)) {
	int start = name.indexOf("Dout");
	return name.substring(0,start) + name.substring(start+4);
      }
      return name;  
    }

    public boolean isString(String name) {
        return name.indexOf("String")>=0;
    }

    public boolean isNslOutPort(String name) {
        return name.indexOf("Dout")>=0;
    }

    public boolean isNslInPort(String name) {
        return name.indexOf("Din")>=0;
    }

    public boolean isNslPort(String name) {
        return (name.indexOf("Din")>=0 || name.indexOf("Dout")>=0);
    }

    public boolean isNslNumeric(String name) {
        return (name.indexOf("Int")>=0 || name.indexOf("Float")>=0 || name.indexOf("Double")>=0);
    }

    public boolean isPrimitive(String type) {
	if (type.equals("boolean") || type.equals("char") || type.equals("byte") ||
	    type.equals("short")   || type.equals("int")  || type.equals("long") ||
	    type.equals("float")   || type.equals("double")) {
	   return true;
        }
        return false;
    }

    public boolean isNslType(String name) {        

        if (name.length()<3 || !name.substring(0,3).equals("Nsl")) {
	    return false;
        }

	int next = 3;
        if (name.indexOf("Din")>=0) {
	    next += 3;
        } else if (name.indexOf("Dout")>=0) {
	    next += 4;
        }

        int dim = -1;

	if (name.indexOf("Float")==next) {
	    try {
	        dim = (new Integer(name.substring(next+5))).intValue();
	    } catch (Exception ex) {
		return false;
	    }
        } else if (name.indexOf("Double")==next) {
	    try {
	        dim = (new Integer(name.substring(next+6))).intValue();
	    } catch (Exception ex) {
		return false;
	    }
        } else if (name.indexOf("Int")==next) {
	    try {
	        dim = (new Integer(name.substring(next+3))).intValue();
	    } catch (Exception ex) {
		return false;
	    }
	} else if (name.indexOf("Boolean")==next) {
	    try {
	        dim = (new Integer(name.substring(next+7))).intValue();
	    } catch (Exception ex) {
		return false;
	    }
        } else if (name.indexOf("String")==next) {
	    try {
	        dim = (new Integer(name.substring(next+6))).intValue();
	    } catch (Exception ex) {
		return false;
	    }
        } else {
	    return false;
	}

        if (dim>=0 && dim<=4) {
	    return true;
        }

        return false;

    }

}
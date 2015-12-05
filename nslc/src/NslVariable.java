
/* SCCS  %W--- %G% -- %U% */

// Copyright: Copyright (c) 1997-2002 University of Southern California Brain Project.
// Copyright: This software may be freely copied provided the toplevel
// Copyright: COPYRIGHT file is included with each such copy.
// Copyright: Email nsl@java.usc.edu.

// Author: Salvador Marmol

//
// NslVariable.java
//
//////////////////////////////////////////////////////////////////////

public class NslVariable {

  boolean publicField    = false,
	  privateField   = true,
	  protectedField = false;

  String name;
  String qualifiers;
  String type;

  SimpleNode info;

  boolean nslType = false;
  boolean nslArrayType = false;

  public NslVariable(String type, String name) {
    this.type = type;
    this.name = name;
  }

  public NslVariable(String qualifiers, String type, String name) {
    this(type, name);
    this.qualifiers = qualifiers;
  }

  public NslVariable(String qualifiers, String type, String name, SimpleNode info) {
    this(qualifiers, type, name);
    this.info = info;
  }

  public void setPublic(boolean value) {
    publicField    = value;
    privateField   = !value;
    protectedField = !value;
  }

  public void setPrivate(boolean value) {
    publicField    = !value;
    privateField   = value;
    protectedField = !value;
  }

  public void setProtected(boolean value) {
    publicField    = !value;
    privateField   = !value;
    protectedField = value;
  }

  public boolean isPublic() {
    return publicField;
  }

  public boolean isPrivate() {
    return privateField;
  }

  public boolean isProtected() {
    return protectedField;
  }
 
  public boolean isVariable(String variable) {
    return name.equals(variable);
  }

  public boolean isNslType() {
    return nslType;
  }

  public boolean isNslArrayType() {
    return nslArrayType;
  }

  public String getQualifiers() { 
    return qualifiers;
  }

  public String getName() { 
    return name;
  }

  public String getType() { 
    return type;
  }

  public String getArguments() { 
    String arguments=null;
    if (info instanceof ASTNslVariableDeclarator) {
      arguments = ((ASTNslVariableDeclarator)info).getArguments();
    } else if (info instanceof ASTNslArrayDeclarator) {
      arguments = ((ASTNslArrayDeclarator)info).getArrayArguments();
    }
    return arguments;
  }

  public String getInitializers() {
    String initializers=null;
    if (info instanceof ASTNslVariableDeclarator) {
      initializers = ((ASTNslVariableDeclarator)info).getVariableInitializer();
    }
    return initializers;
  }

  public void setQualifiers(String qualifiers) {
    this.qualifiers = qualifiers;
  }

  public void setName(String names) {
    this.name = name;
  }

  public void setType(String type) {
    this.type = type;
  }

  public void setNslType(boolean value) {
    nslType = value;
  }

  public void setNslArrayType(boolean value) {
    nslArrayType = value;
  }
}
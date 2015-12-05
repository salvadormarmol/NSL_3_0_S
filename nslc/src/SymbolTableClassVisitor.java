
/* SCCS  %W--- %G% -- %U% */

// Copyright: Copyright (c) 1997-2002 University of Southern California Brain Project.
// Copyright: This software may be freely copied provided the toplevel
// Copyright: COPYRIGHT file is included with each such copy.
// Copyright: Email nsl@java.usc.edu.

// Author: Salvador Marmol

//
// SymbolTableVisitor.java
//
//////////////////////////////////////////////////////////////////////

public class SymbolTableClassVisitor extends SymbolTable {

  public SymbolTableClassVisitor(NslScope scope)  {
    super(scope);
  }

  public Object visit(ASTNestedClassDeclaration node, Object data)
  {
    return data;
  }

  public Object visit(ASTNslNestedClassDeclaration node, Object data)
  {
    return data;
  }

  public Object visit(ASTNslImportDeclaration node, Object data)
  {
    node.updateScope(scope);
    return super.visit(node, data);
  }

  public Object visit(ASTImportDeclaration node, Object data)
  {
    node.updateScope(scope);
    return super.visit(node, data);
  }

  public Object visit(ASTNslClassDeclaration node, Object data)
  {
    node.updateScope(scope);  
    return super.visit(node, data);
  }

  public Object visit(ASTNslFieldDeclaration node, Object data)
  {
    node.updateScope(scope);  
    return super.visit(node, data);
  }

  public Object visit(ASTFieldDeclaration node, Object data)
  {
    node.updateScope(scope);  
    return super.visit(node, data);
  }

  public Object visit(ASTMethodDeclaration node, Object data)
  {
    scope.pushScope();
    node.updateScope(scope);
    Object temp = super.visit(node, data);
    scope.popScope();
    return temp;
  }
}
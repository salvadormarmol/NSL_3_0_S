
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

public class SymbolTableVisitor extends SymbolTable {

  public SymbolTableVisitor(NslScope scope)  {
    super(scope);
  }

  public Object visit(ASTNestedClassDeclaration node, Object data)
  {
    node.updateScope(scope);  
    return data;
  }

  public Object visit(ASTNslNestedClassDeclaration node, Object data)
  {
    node.updateScope(scope);  
    return data;
  }

  public Object visit(ASTNslLocalVariableDeclaration node, Object data)
  {
    node.updateScope(scope);  
    return super.visit(node, data);
  }

  public Object visit(ASTLocalVariableDeclaration node, Object data)
  {
    node.updateScope(scope);  
    return super.visit(node, data);
  }

  public Object visit(ASTName node, Object data)
  {
    node.updateScope(scope);  
    return super.visit(node, data);
  }

  public Object visit(ASTMethodDeclarator node, Object data)
  {
    node.updateScope(scope);  
    return super.visit(node, data);
  }

  public Object visit(ASTCastExpression node, Object data)
  {
    node.updateScope(scope);  
    return super.visit(node, data);
  }

  public Object visit(ASTBlock node, Object data)
  {
    scope.pushScope();
    Object temp = super.visit(node, data);
    scope.popScope();
    return temp;
  }

  public Object visit(ASTForStatement node, Object data)
  {
    scope.pushScope();
    Object temp = super.visit(node, data);
    scope.popScope();
    return temp;
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
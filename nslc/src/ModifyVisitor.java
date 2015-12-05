
/* SCCS  %W--- %G% -- %U% */

// Copyright: Copyright (c) 1997-2002 University of Southern California Brain Project.
// Copyright: This software may be freely copied provided the toplevel
// Copyright: COPYRIGHT file is included with each such copy.
// Copyright: Email nsl@java.usc.edu.

// Author: Salvador Marmol

import java.io.PrintStream;

public class ModifyVisitor extends UnparseVisitor
{

  public ModifyVisitor() { }

  public Object visit(ASTMethodDeclaration node, Object data)
  {
    NslScope scope = (NslScope)data;
    if (node.getQualifiers().indexOf("static")>=0) {
       scope.setStaticScope(true);
    }
    Object temp = super.visit(node, data);
    scope.setStaticScope(false);
    return temp;
  }

  public Object visit(ASTNslImportDeclaration node, Object data)
  {
    super.visit(node, data);
    return node.toJava((NslScope)data);
  }

  public Object visit(ASTNslClassDeclaration node, Object data)
  {
    super.visit(node, data);
    return node.toJava((NslScope)data);
  }

  public Object visit(ASTNslNestedClassDeclaration node, Object data)
  {
    super.visit(node, node.getLocalScope());
    return node.toJava((NslScope)data);
  }


  public Object visit(ASTNslFieldDeclaration node, Object data)
  {
    super.visit(node, data);
    return node.toJava((NslScope)data);
  }

  public Object visit(ASTNslLocalVariableDeclaration node, Object data)
  {
    super.visit(node, data);
    return node.toJava((NslScope)data);
  }

  public Object visit(ASTPrimaryExpression node, Object data)
  {
    super.visit(node, data);
    return node.toJava((NslScope)data);
  }

  public Object visit(ASTExpression node, Object data)
  {
    super.visit(node, data);
    return node.toJava((NslScope)data);
  }

  public Object visit(ASTUnaryExpression node, Object data)
  {
    super.visit(node, data);
    return node.toJava((NslScope)data);
  }

  public Object visit(ASTUnaryExpressionNotPlusMinus node, Object data)
  {
    super.visit(node, data);
    return node.toJava((NslScope)data);
  }

  public Object visit(ASTMultiplicativeExpression node, Object data)
  {
    super.visit(node, data);
    return node.toJava((NslScope)data);
  }

  public Object visit(ASTAdditiveExpression node, Object data)
  {
    super.visit(node, data);
    return node.toJava((NslScope)data);
  }

  public Object visit(ASTExclusiveOrExpression node, Object data)
  {
    super.visit(node, data);
    return node.toJava((NslScope)data);
  }

  public Object visit(ASTEqualityExpression node, Object data)
  {
    super.visit(node, data);
    return node.toJava((NslScope)data);
  }

  public Object visit(ASTConditionalAndExpression node, Object data)
  {
    super.visit(node, data);
    return node.toJava((NslScope)data);
  }

  public Object visit(ASTConditionalOrExpression node, Object data)
  {
    super.visit(node, data);
    return node.toJava((NslScope)data);
  }

  public Object visit(ASTRelationalExpression node, Object data)
  {
    super.visit(node, data);
    return node.toJava((NslScope)data);
  }

  public Object visit(ASTStatementExpression node, Object data)
  {
    super.visit(node, data);
    return node.toJava((NslScope)data);
  }

  public Object visit(ASTCastExpression node, Object data)
  {
    super.visit(node, data);
    return node.toJava((NslScope)data);
  }

}


/* SCCS  %W--- %G% -- %U% */

// Copyright: Copyright (c) 1997-2002 University of Southern California Brain Project.
// Copyright: This software may be freely copied provided the toplevel
// Copyright: COPYRIGHT file is included with each such copy.
// Copyright: Email nsl@java.usc.edu.

// Author: Salvador Marmol

public class ComputeTypeVisitor extends UnparseVisitor
{

  public ComputeTypeVisitor() { }


  public Object visit(ASTPrimaryExpression node, Object data)
  {
    super.visit(node, data);
    return node.computeType((NslScope)data);
  }

  public Object visit(ASTMultiplicativeExpression node, Object data)
  {
    super.visit(node, data);
    return node.computeType((NslScope)data);
  }

  public Object visit(ASTAdditiveExpression node, Object data)
  {
    super.visit(node, data);
    return node.computeType((NslScope)data);
  }

  public Object visit(ASTExclusiveOrExpression node, Object data)
  {
    super.visit(node, data);
    return node.computeType((NslScope)data);
  }

  public Object visit(ASTEqualityExpression node, Object data)
  {
    super.visit(node, data);
    return node.computeType((NslScope)data);
  }

  public Object visit(ASTConditionalAndExpression node, Object data)
  {
    super.visit(node, data);
    return node.computeType((NslScope)data);
  }

  public Object visit(ASTConditionalOrExpression node, Object data)
  {
    super.visit(node, data);
    return node.computeType((NslScope)data);
  }

  public Object visit(ASTRelationalExpression node, Object data)
  {
    super.visit(node, data);
    return node.computeType((NslScope)data);
  }


}

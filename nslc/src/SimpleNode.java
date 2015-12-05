
/* SCCS  %W--- %G% -- %U% */

// Copyright: Copyright (c) 1997-2002 University of Southern California Brain Project.
// Copyright: This software may be freely copied provided the toplevel
// Copyright: COPYRIGHT file is included with each such copy.
// Copyright: Email nsl@java.usc.edu.

// Author: Salvador Marmol

import java.io.*;

public class SimpleNode implements Node {
  protected Node parent;
  protected Node[] children;
  protected int id;
  protected NslParser parser;

  protected Token first, last;

  protected String simpleNodeType="null";

  protected String eol = System.getProperty("line.separator", "\n"); 


//  protected boolean nslExpression = false;

  public SimpleNode(int i) {
    id = i;
  }

  public SimpleNode(NslParser p, int i) {
    this(i);
    parser = p;
  }

  public static Node jjtCreate(NslParser p, int id) {
    return new SimpleNode(p, id);
  }

  public void jjtOpen() {
    first = parser.getToken(1);	// new
  }

  public void jjtClose() {
    last = parser.getToken(0);	// new
  }

  public Token getFirstToken() { return first; } // new
  public Token getLastToken() { return last; }   // new

  public String getNodeType() { return simpleNodeType; } // new
  public void setNodeType(String type) { simpleNodeType=type; } // new

  public boolean isNodeOfType(String type) { return simpleNodeType.equals(type); } // new

  public void jjtSetParent(Node n) { parent = n; }
  public Node jjtGetParent() { return parent; }

  public void jjtAddChild(Node n, int i) {
    if (children == null) {
      children = new Node[i + 1];
    } else if (i >= children.length) {
      Node c[] = new Node[i + 1];
      System.arraycopy(children, 0, c, 0, children.length);
      children = c;
    }
    children[i] = n;
  }

  public Node jjtGetChild(int i) {
    return children[i];
  }

  public int jjtGetNumChildren() {
    return (children == null) ? 0 : children.length;
  }

  /** Accept the visitor. **/
  public Object jjtAccept(NslParserVisitor visitor, Object data) {
    return visitor.visit(this, data);
  }

  /** Accept the visitor. **/
  public Object acceptChildren(NslParserVisitor visitor, Object data) {
    if (children != null) {
      for (int i = 0; i < children.length; ++i) {
        children[i].jjtAccept(visitor, data);
      }
    }
    return data;
  }

  /** For transformations */

  public void clean(Token t, Token end) {
     while (t != end) {
	t = t.next;
	t.image="";
     }
  }

  public String getIndentation(Token t) {
    /** Attempt to make the new code match the indentation of the
        node. */
    StringBuffer pre = new StringBuffer("");
    for (int i = 1; i < t.beginColumn; ++i) {
      pre.append(" ");
    }
 
    return pre.toString();
  }

  /* You can override these two methods in subclasses of SimpleNode to
     customize the way the node appears when the tree is dumped.  If
     your output uses more than one line you should override
     toString(String), otherwise overriding toString() is probably all
     you need to do. */

  public String toString() { return NslParserTreeConstants.jjtNodeName[id]; }
  public String toString(String prefix) { return prefix + toString(); }

  public String toXMLOpen()  { return  "<" + toString() + ">"; }
  public String toXMLClose() { return  "</" + toString() + ">"; }

  public String toXMLComment()  { 
    String temp, comment;
    temp =  "<Comment>";     
    comment = "";
    Token tt = first.specialToken;
    if (tt != null) {
      while (tt.specialToken != null) tt = tt.specialToken;
        while (tt != null) {
          comment += tt.image;
          tt = tt.next;
        }
    }
    temp += comment;
    temp += "</Comment>"; 

    return temp;
  }

  public String toXMLComment(String prefix)  { return prefix + toXMLComment(); }
  public String toXMLOpen(String prefix) { return prefix + toXMLOpen(); }
  public String toXMLClose(String prefix) { return prefix + toXMLClose(); }

  /* Override this method if you want to customize how the node dumps
     out its children. */

  public void dump(String prefix) {
    System.out.println(toString(prefix));
    if (children != null) {
      for (int i = 0; i < children.length; ++i) {
	SimpleNode n = (SimpleNode)children[i];
	if (n != null) {
	  n.dump(prefix + " ");
	}
      }
    }
  }

  public void dumpXML(String prefix, PrintStream out) {
    String xml = toXMLOpen(prefix);
    if (xml!=null) {
      out.println(xml);
    }
    if (children != null) {
      for (int i = 0; i < children.length; ++i) {
	SimpleNode n = (SimpleNode)children[i];
	if (n != null) {
	  n.dumpXML(prefix + " ", out);
	}
      }
    }
    xml = toXMLClose(prefix);
    if (xml!=null) {
      out.println(xml);
    }
  }
}

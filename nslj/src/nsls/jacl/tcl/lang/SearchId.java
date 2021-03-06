/*
 * SearchId.java
 *
 * Copyright (c) 1997 Sun Microsystems, Inc.
 *
 * See the file "license.terms" for information on usage and
 * redistribution of this file, and for a DISCLAIMER OF ALL
 * WARRANTIES.
 * 
 * RCS: @(#) $Id: SearchId.java,v 1.1.1.1 1998/10/14 21:09:20 cvsadmin Exp $
 *
 */

package tcl.lang;

import java.util.*;

/**
 * SearchId is used only by the ArrayVar class.  When searchstart is
 * called on an Tcl array, a SearchId is created that contains the
 * Enumerated list of all the array keys; a String that uniquely
 * identifies the searchId for the Tcl array, and an index that is
 * used when to generate other unique strings.
 */
class SearchId {

   /**
    * An Enumeration that stores the list of keys for
    * the ArrayVar.
    */
    private Enumeration enum;
  
   /**
    * The unique searchId string
    */
    private String str;

   /**
    * Unique index used for generating unique searchId strings
    */
    private int index;

   /**
    * A SearchId is only created from an ArrayVar object.  The ArrayVar 
    * constructs a new SearchId object by passing it's current keys 
    * stored as an enumeration, a unique string that ArrayVar creates, 
    * and an index value used for future SearchId objects.
    *
    * @param e initial Enumeration
    * @param s String as the unique identifier for the searchId
    * @param e index value for this object
    */
    SearchId(Enumeration e, String s, int i) {
        enum  = e;      
	str   = s;
	index = i;
    }

   /**
    * Return the str that is the unique identifier of the SearchId
    */
    public String toString() {
	return str;
    }

   /**
    * Return the Enumeration for the SearchId object.  This is 
    * used in the ArrayCmd class for the anymore, donesearch, 
    * and nextelement functions.
    *
    * @param none
    * @return The Enumeration for the SearchId object
    */
    Enumeration getEnum() {
 	return enum;
    }

   /**
    * Return the integer value of the index.  Used in ArrayVar to
    * generate the next unique SearchId string.
    *
    * @param none
    * @returnh  The integer value of the index
    */
    int getIndex() { 
        return index;
    }

   /**
    * Tests for equality based on the value of str
    * @param none
    * @return boolean based on the equality of the string
    */
    boolean equals(String s) {
        return str.equals(s);
    }
}

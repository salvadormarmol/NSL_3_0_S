<xsl:stylesheet version = '1.0'
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--

Copyright (c) 2002 University of Southern California Brain Project.

Author:      Juan Salvador Marmol Yahya
Description: The NSL xml viewer

-->

    <xsl:output method="html"/>

    <xsl:template match="/">
        <HTML>
            <HEAD>
                <TITLE>NSLM Viewer</TITLE>
            </HEAD>
            <BODY>
                <xsl:apply-templates select="/CompilationUnit"/>
            </BODY>
        </HTML>
    </xsl:template>

    <xsl:template match="/CompilationUnit">
        <xsl:apply-templates select="./PackageDeclaration"/>
        <xsl:apply-templates select="./ImportDeclaration"/>
        <xsl:apply-templates select="./NslImportDeclaration"/>
        <xsl:apply-templates select="./NslClassDeclaration"/>
    </xsl:template>

    <xsl:template match="/CompilationUnit/PackageDeclaration">
	<xsl:text>package </xsl:text>
        <xsl:value-of select="."/> 
        <xsl:text>;</xsl:text><BR/>
    </xsl:template>

    <xsl:template match="/CompilationUnit/ImportDeclaration">
	<xsl:text>import </xsl:text>
        <xsl:value-of select="."/> 
        <xsl:text>;</xsl:text><BR/>
    </xsl:template>

    <xsl:template match="/CompilationUnit/NslImportDeclaration">
	<xsl:text>nslImport </xsl:text>
        <xsl:value-of select="."/> 
        <xsl:text>;</xsl:text><BR/>
    </xsl:template>

    <xsl:template match="/CompilationUnit/NslClassDeclaration">
	<xsl:value-of select="@kind"/>
	<xsl:text> </xsl:text>
	<xsl:value-of select="@name"/>
	<xsl:apply-templates select="FormalParameters"/>
	<xsl:apply-templates select="./Name"/>
	<xsl:apply-templates select="Arguments"/>
	<xsl:apply-templates select="./ClassBody"/>
    </xsl:template>

    <xsl:template match="FormalParameters">
	<xsl:text>(</xsl:text>
	<xsl:for-each select="./FormalParameter">
	    <xsl:if test="position() &gt; 1">
		<xsl:text>, </xsl:text>
	    </xsl:if>
	    <xsl:value-of select="./Type"/>
	    <xsl:value-of select="./VariableDeclaratorId"/>
	</xsl:for-each>
	<xsl:text>) </xsl:text>
    </xsl:template>

    <xsl:template match="NslClassDeclaration/Name">
	<xsl:text>extends </xsl:text>
	<xsl:value-of select="."/>
	<xsl:text> </xsl:text>
    </xsl:template>

    <xsl:template match="NslClassDeclaration/ClassBody">
	<xsl:text> {</xsl:text><BR/>
	<xsl:apply-templates select="ClassBodyDeclaration"/>
	<xsl:text>}</xsl:text><BR/>
    </xsl:template>

    <xsl:template match="ClassBodyDeclaration">
        <xsl:call-template name="Indentation"/>
	<xsl:apply-templates select="./Initializer"/>
	<xsl:apply-templates select="./NslNestedClassDeclaration"/>
	<xsl:apply-templates select="./NestedClassDeclaration"/>
	<xsl:apply-templates select="./FieldDeclaration"/>
	<xsl:apply-templates select="./NslFieldDeclaration"/>
	<xsl:apply-templates select="./MethodDeclaration"/>
	<xsl:apply-templates select="./ConstructorDeclaration"/>
    </xsl:template>

    <xsl:template match="ClassBodyDeclaration/Initializer">
	<xsl:apply-templates select="Block"/>
    </xsl:template>

    <xsl:template match="ClassBodyDeclaration/FieldDeclaration">
	<xsl:value-of select="@modifiers"/>
	<xsl:text> </xsl:text>
	<xsl:value-of select="./Type"/>
	<xsl:text> </xsl:text>
	<xsl:for-each select="./VariableDeclarator">	   
	    <xsl:if test="position() &gt; 1">
		<xsl:text>, </xsl:text>
	    </xsl:if>
	    <xsl:value-of select="./VariableDeclaratorId"/>
	    <xsl:apply-templates select="VariableInitializer"/>
	</xsl:for-each>
	<xsl:text>;</xsl:text><BR/>
    </xsl:template>

    <xsl:template match="ClassBodyDeclaration/MethodDeclaration">
	<xsl:value-of select="@modifiers"/>
	<xsl:text> </xsl:text>
	<xsl:value-of select="./ResultType"/>
	<xsl:text> </xsl:text>
        <xsl:apply-templates select="MethodDeclarator"/>
        <xsl:apply-templates select="Block"/><BR/>
    </xsl:template>

    <xsl:template match="MethodDeclaration/MethodDeclarator">
	<xsl:value-of select="@name"/>
	<xsl:text> </xsl:text>
	<xsl:text> </xsl:text>
        <xsl:apply-templates select="FormalParameters"/>
    </xsl:template>

    <xsl:template match="ClassBodyDeclaration/NslFieldDeclaration">
	<xsl:text> </xsl:text>
	<xsl:value-of select="@modifiers"/>
	<xsl:if test="name(child::*[1])='PrimitiveType'">
	     <xsl:value-of select="child::*[1]"/>
	     <xsl:for-each select="./NslArrayDeclarator">
	         <xsl:if test="position() &gt; 1">
		    <xsl:text>, </xsl:text>
	         </xsl:if>
		 <xsl:apply-templates select="."/>
  	     </xsl:for-each>
	</xsl:if>
	<xsl:if test="name(child::*[1])='Name'">
	     <xsl:value-of select="child::*[1]"/>
	     <xsl:for-each select="./NslVariableDeclarator">
	         <xsl:if test="position() &gt; 1">
		    <xsl:text>, </xsl:text>
	         </xsl:if>
		 <xsl:apply-templates select="."/>
  	     </xsl:for-each>
	</xsl:if>
	<xsl:text>;</xsl:text><BR/>
    </xsl:template>

    <xsl:template match="Block">
	<xsl:text> {</xsl:text><BR/>
	<xsl:apply-templates select="BlockStatement"/>
        <xsl:call-template name="Indentation"/>
	<xsl:text>}</xsl:text>
    </xsl:template>


    <xsl:template match="Statement">
        <xsl:for-each select="child::*">
	    <xsl:choose>
	        <xsl:when test="name(.)='LabeledStatement'">
	  	    <xsl:apply-templates select="."/><BR/>
	        </xsl:when>
	        <xsl:when test="name(.)='Block'">
	  	    <xsl:apply-templates select="."/><BR/>
	        </xsl:when>
	        <xsl:when test="name(.)='EmptyStatement'">
	  	    <xsl:apply-templates select="."/><BR/>
	        </xsl:when>
	        <xsl:when test="name(.)='StatementExpression'">
	  	    <xsl:apply-templates select="."/><xsl:text>;</xsl:text><BR/>
	        </xsl:when>
	        <xsl:when test="name(.)='SwitchStatement'">
	  	    <xsl:apply-templates select="."/><BR/>
	        </xsl:when>
	        <xsl:when test="name(.)='IfStatement'">
	  	    <xsl:apply-templates select="."/>
	        </xsl:when>
	        <xsl:when test="name(.)='WhileStatement'">
	  	    <xsl:apply-templates select="."/>
	        </xsl:when>
	        <xsl:when test="name(.)='DoStatement'">
	  	    <xsl:apply-templates select="."/>
	        </xsl:when>
	        <xsl:when test="name(.)='ForStatement'">
	  	    <xsl:apply-templates select="."/>
	        </xsl:when>
	        <xsl:when test="name(.)='BreakStatement'">
	  	    <xsl:apply-templates select="."/><BR/>
	        </xsl:when>
	        <xsl:when test="name(.)='ContinueStatement'">
	  	    <xsl:apply-templates select="."/><BR/>
	        </xsl:when>
	        <xsl:when test="name(.)='ReturnStatement'">
	  	    <xsl:apply-templates select="."/><BR/>
	        </xsl:when>
	        <xsl:when test="name(.)='ThrowStatement'">
	  	    <xsl:apply-templates select="."/><BR/>
	        </xsl:when>
	        <xsl:when test="name(.)='SynchronizedStatement'">
	  	    <xsl:apply-templates select="."/><BR/>
	        </xsl:when>
	        <xsl:when test="name(.)='TryStatement'">
	  	    <xsl:apply-templates select="."/>
	        </xsl:when>
	        <xsl:when test="name(.)='AssertStatement'">
	  	    <xsl:apply-templates select="."/><BR/>
	        </xsl:when>
	    </xsl:choose>
	</xsl:for-each>
    </xsl:template>

    <xsl:template match="BlockStatement">
        <xsl:call-template name="Indentation"/>
        <xsl:for-each select="child::*">
	    <xsl:choose>
	        <xsl:when test="name(.)='NslLocalVariableDeclaration'">
	  	    <xsl:apply-templates select="."/><xsl:text>;</xsl:text><BR/>
	        </xsl:when>
	        <xsl:when test="name(.)='LocalVariableDeclaration'">
	  	    <xsl:apply-templates select="."/><xsl:text>;</xsl:text><BR/>
	        </xsl:when>
	        <xsl:when test="name(.)='Statement'">
	  	    <xsl:apply-templates select="."/>
	        </xsl:when>
	    </xsl:choose>
	</xsl:for-each>
    </xsl:template>

    <xsl:template match="SwitchStatement">
	<xsl:text>switch </xsl:text>
        <xsl:for-each select="child::*">
	    <xsl:choose>
	        <xsl:when test="name(.)='Expression'">
		    <xsl:text>(</xsl:text>
		    <xsl:call-template name="Expression"/>
		    <xsl:text>) {</xsl:text><BR/>	    
	        </xsl:when>
	        <xsl:when test="name(.)='SwitchLabel'">
	  	    <xsl:apply-templates select="."/>
	        </xsl:when>
	        <xsl:when test="name(.)='BlockStatement'">
	  	    <xsl:apply-templates select="."/>
	        </xsl:when>
	    </xsl:choose>
	</xsl:for-each>
       	<xsl:call-template name="Indentation"/>
        <xsl:text>}</xsl:text>
    </xsl:template>


    <xsl:template match="SwitchLabel">
        <xsl:call-template name="Indentation"/>
        <xsl:choose>
	    <xsl:when test="count(./Expression)=1">
	        <xsl:text>case </xsl:text>
		<xsl:for-each select="child::*">
		    <xsl:call-template name="Expression"/>
		</xsl:for-each>
		<xsl:text>:</xsl:text><BR/>
	    </xsl:when>
	    <xsl:otherwise>
	        <xsl:text>default:</xsl:text><BR/>
	    </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="IfStatement">
	<xsl:text>if </xsl:text>
        <xsl:for-each select="child::*">
	    <xsl:choose>
	        <xsl:when test="name(.)='Expression'">
		    <xsl:text>(</xsl:text>
		    <xsl:call-template name="Expression"/>
		    <xsl:text>) </xsl:text>	    
	        </xsl:when>
	        <xsl:when test="name(.)='Statement'">
		    <xsl:if test="position() &gt; 2">
        		<xsl:call-template name="Indentation"/>
		        <xsl:text>else </xsl:text>
	            </xsl:if>
	  	    <xsl:apply-templates select="."/>
	        </xsl:when>
	    </xsl:choose>
	</xsl:for-each>
    </xsl:template>

    <xsl:template match="WhileStatement">
	<xsl:text>while </xsl:text>
        <xsl:for-each select="child::*">
	    <xsl:choose>
	        <xsl:when test="name(.)='Expression'">
		    <xsl:text>(</xsl:text>
		    <xsl:call-template name="Expression"/>
		    <xsl:text>) </xsl:text>	    
	        </xsl:when>
	        <xsl:when test="name(.)='Statement'">
	  	    <xsl:apply-templates select="."/>
	        </xsl:when>
	    </xsl:choose>
	</xsl:for-each>
    </xsl:template>

    <xsl:template match="DoStatement">
	<xsl:text>do </xsl:text>
        <xsl:for-each select="child::*">
	    <xsl:choose>
	        <xsl:when test="name(.)='Expression'">
		    <xsl:text>while (</xsl:text>
		    <xsl:call-template name="Expression"/>
		    <xsl:text>);</xsl:text>
	        </xsl:when>
	        <xsl:when test="name(.)='Statement'">
	  	    <xsl:apply-templates select="."/>
	        </xsl:when>
	    </xsl:choose>
	</xsl:for-each>
    </xsl:template>

    <xsl:template match="BreakStatement">
	<xsl:text>break;</xsl:text>
    </xsl:template>

    <xsl:template match="ContinueStatement">
	<xsl:text>continue;</xsl:text>
    </xsl:template>

    <xsl:template match="ReturnStatement">
	<xsl:text>return </xsl:text>
        <xsl:for-each select="child::*">
	    <xsl:choose>
	        <xsl:when test="name(.)='Expression'">
		    <xsl:call-template name="Expression"/>
	        </xsl:when>
	    </xsl:choose>
	</xsl:for-each>
	<xsl:text>;</xsl:text>
    </xsl:template>

    <xsl:template match="ThrowStatement">
	<xsl:text>throw </xsl:text>
        <xsl:for-each select="child::*">
	    <xsl:choose>
	        <xsl:when test="name(.)='Expression'">
		    <xsl:call-template name="Expression"/>
	        </xsl:when>
	    </xsl:choose>
	</xsl:for-each>
	<xsl:text>;</xsl:text>
    </xsl:template>

    <xsl:template match="SynchronizedStatement">
	<xsl:text>synchronized </xsl:text>
        <xsl:for-each select="child::*">
	    <xsl:choose>
	        <xsl:when test="name(.)='Expression'">
		    <xsl:text>(</xsl:text>
		    <xsl:call-template name="Expression"/>
		    <xsl:text>)</xsl:text>
	        </xsl:when>
	        <xsl:when test="name(.)='Block'">
		    <xsl:apply-templates select="."/>
	        </xsl:when>
	    </xsl:choose>
	</xsl:for-each>
    </xsl:template>

    <xsl:template match="TryStatement">
	<xsl:text>try </xsl:text>
        <xsl:for-each select="child::*">
	    <xsl:choose>
	        <xsl:when test="position()=last()">
	            <xsl:choose>
		        <xsl:when test="../@hasFinally='true'">
		            <xsl:text>finally </xsl:text>
			    <xsl:apply-templates select="."/>
	                </xsl:when>
		        <xsl:otherwise>
			    <xsl:apply-templates select="."/>
		        </xsl:otherwise>
	            </xsl:choose>
	        </xsl:when>
	        <xsl:when test="name(.)='Block'">
		    <xsl:apply-templates select="."/>
	        </xsl:when>
	        <xsl:when test="name(.)='FormalParameter'">
		    <xsl:text>catch (</xsl:text>
		    <xsl:apply-templates select="."/>
		    <xsl:text>)</xsl:text>
	        </xsl:when>
	    </xsl:choose>
	</xsl:for-each>
    </xsl:template>

    <xsl:template match="AssertStatement">
	<xsl:text>assert </xsl:text>
        <xsl:for-each select="child::*">
	    <xsl:choose>
	        <xsl:when test="name(.)='Expression'">
		    <xsl:if test="position() &gt; 2">
		        <xsl:text> : </xsl:text>
	            </xsl:if>
		    <xsl:call-template name="Expression"/>
		    <xsl:text>)</xsl:text>
	        </xsl:when>
	    </xsl:choose>
	</xsl:for-each>
	<xsl:text>;</xsl:text>
    </xsl:template>

    <xsl:template match="ForStatement">
	<xsl:text>for </xsl:text>
	<xsl:text>(</xsl:text>
	<xsl:for-each select="child::*">
	    <xsl:if test="name(.)='ForInit'">
		<xsl:apply-templates select="."/>
	    </xsl:if>
	</xsl:for-each>
	<xsl:text>; </xsl:text>
	<xsl:for-each select="child::*">
	    <xsl:if test="name(.)='Expression'">
		<xsl:call-template name="Expression"/>
	    </xsl:if>
	</xsl:for-each>
	<xsl:text>; </xsl:text>
	<xsl:for-each select="child::*">
	    <xsl:if test="name(.)='ForUpdate'">
		<xsl:apply-templates select="."/>
	    </xsl:if>
	</xsl:for-each>
	<xsl:text>)</xsl:text>
	<xsl:for-each select="child::*">
	    <xsl:if test="name(.)='Statement'">
		<xsl:apply-templates select="."/>
	    </xsl:if>
	</xsl:for-each>
    </xsl:template>

    <xsl:template match="ForInit">
	<xsl:for-each select="child::*">
	    <xsl:if test="name(.)='LocalVariableDeclaration'">
		<xsl:apply-templates select="."/>
	    </xsl:if>
	    <xsl:if test="name(.)='StatementExpressionList'">
		<xsl:apply-templates select="."/>
	    </xsl:if>
	</xsl:for-each>
    </xsl:template>

    <xsl:template match="ForUpdate">
	<xsl:apply-templates select="StatementExpressionList"/>
    </xsl:template>

    <xsl:template match="StatementExpressionList">
	<xsl:for-each select="child::*">
	    <xsl:if test="name(.)='StatementExpression'">
	       <xsl:if test="position()=1">
	       	    <xsl:apply-templates select="."/>
	       </xsl:if>
	    </xsl:if>
	    <xsl:if test="position() &gt; 1">
		<xsl:text>, </xsl:text>
		<xsl:if test="name(.)='StatementExpression'">
		    xsl:apply-templates select="."/>
	        </xsl:if>
	    </xsl:if>
	</xsl:for-each>
    </xsl:template>

    <xsl:template match="LabeledStatement">
	<xsl:value-of select="@name"/>
	<xsl:text>:</xsl:text>
	<xsl:apply-templates select="Statement"/>
    </xsl:template>

    <xsl:template match="StatementExpression">
	<xsl:if test="name(child::*[1])='PreIncrementExpression'">
	     <xsl:call-template name="PreIncrementExpression"/>
	</xsl:if>
	<xsl:if test="name(child::*[1])='PreDecrementExpression'">
	     <xsl:call-template name="PreDecrementExpression"/>
	</xsl:if>
	<xsl:if test="name(child::*[1])='PrimaryExpression'">
	    <xsl:apply-templates select="PrimaryExpression"/>
	    <xsl:if test="count(./AssignmentOperator)=0">
	        <xsl:value-of select="@operator"/>
	        <xsl:text> </xsl:text>
	    </xsl:if>
	    <xsl:if test="count(./AssignmentOperator)=1">
 	        <xsl:value-of select="./AssignmentOperator"/>
		<xsl:apply-templates select="./Expression"/>
	    </xsl:if>
	</xsl:if>
    </xsl:template>

    <xsl:template match="Expression">
	<xsl:call-template name="Expression"/>
    </xsl:template>

    <xsl:template match="PrimaryExpression">
	<xsl:call-template name="PrimaryExpression"/>
    </xsl:template>

    <xsl:template match="EmptyStatement">
	<xsl:text>;</xsl:text>
    </xsl:template>

    <xsl:template match="LocalVariableDeclaration">
	<xsl:value-of select="@modifiers"/>
	<xsl:value-of select="./Type"/>
	<xsl:text> </xsl:text>
        <xsl:for-each select="./VariableDeclarator">
	    <xsl:if test="position() &gt; 1">
	        <xsl:text>, </xsl:text>
	    </xsl:if>
	    <xsl:apply-templates select="."/>
  	</xsl:for-each>
    </xsl:template>

    <xsl:template match="NslLocalVariableDeclaration">
	<xsl:value-of select="@modifiers"/>
	<xsl:if test="name(child::*[1])='Name'">
	    <xsl:apply-templates select="./Name"/>
            <xsl:for-each select="./NslVariableDeclarator">
	        <xsl:if test="position() &gt; 1">
	            <xsl:text>, </xsl:text>
	        </xsl:if>
	        <xsl:apply-templates select="."/>
  	    </xsl:for-each>
	</xsl:if>
	<xsl:if test="name(child::*[1])='PrimitiveType'">
	    <xsl:apply-templates select="./PrimitiveType"/>
            <xsl:for-each select="./NslArrayDeclarator">
	        <xsl:if test="position() &gt; 1">
	            <xsl:text>, </xsl:text>
	        </xsl:if>
	        <xsl:apply-templates select="."/>
  	    </xsl:for-each>
	</xsl:if>
    </xsl:template>

    <xsl:template match="NslArrayDeclarator">
	<xsl:value-of select="@name"/>
        <xsl:for-each select="./Expression">
	    <xsl:text>[</xsl:text>
	    <xsl:call-template name="Expression"/>
	    <xsl:text>]</xsl:text>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="NslVariableDeclarator">
	<xsl:value-of select="@name"/>
	<xsl:apply-templates select="Arguments"/>
	<xsl:apply-templates select="VariableInitializer"/>
    </xsl:template>

    <xsl:template match="Arguments">
	<xsl:text>(</xsl:text>
	<xsl:apply-templates select="ArgumentList"/>
	<xsl:text>) </xsl:text>
    </xsl:template>

    <xsl:template match="VariableInitializer">
	<xsl:text> = </xsl:text>
	<xsl:for-each select="child::*">
	    <xsl:if test="name(.)='Expression'">
	       <xsl:call-template name="Expression"/>
	    </xsl:if>
	    <xsl:if test="name(.)='ArrayInitializer'">
	       <xsl:call-template name="ArrayInitializer"/>
	    </xsl:if>
	</xsl:for-each>
    </xsl:template>

    <xsl:template match="ArgumentList">
	<xsl:for-each select="./Expression">
	    <xsl:if test="position() &gt; 1">
		<xsl:text>, </xsl:text>
	    </xsl:if>
	    <xsl:call-template name="Expression"/>
	</xsl:for-each>
    </xsl:template>

    <xsl:template name="VariableDeclarator">
	<xsl:call-template name="VariableDeclaratorID"/>
    </xsl:template>

    <xsl:template name="VariableDeclaratorID">
	<xsl:text>(</xsl:text>
	<xsl:value-of select="name(.)"/>
	<xsl:text>:</xsl:text>
	<xsl:value-of select="."/>
	<xsl:text>)</xsl:text>
	<xsl:apply-templates select="VariableInitializer"/>
    </xsl:template>

    <xsl:template name="ArrayInitializer">
	<xsl:text>{ ArrayInitializer (...) }</xsl:text>
    </xsl:template>

    <xsl:template name="Expression">
	<xsl:for-each select="child::*">
	    <xsl:if test="name(.)='ConditionalExpression'">
		<xsl:call-template name="ConditionalExpression"/>
	    </xsl:if>
	    <xsl:if test="name(.)='AssignmentOperator'">
		<xsl:value-of select="."/>
	    </xsl:if>
	    <xsl:if test="name(.)='Expression'">
		<xsl:call-template name="Expression"/>
	    </xsl:if>
	</xsl:for-each>
    </xsl:template>

    <xsl:template name="ConditionalExpression">
	<xsl:for-each select="child::*">
	    <xsl:if test="name(.)='ConditionalOrExpression'">
	        <xsl:call-template name="ConditionalOrExpression"/>
	    </xsl:if>
	    <xsl:if test="name(.)='Expression'">
	        <xsl:text>?</xsl:text>
		<xsl:call-template name="Expression"/>
	    </xsl:if>
	    <xsl:if test="name(.)='ConditionalExpression'">
	        <xsl:text>:</xsl:text>
		<xsl:call-template name="ConditionalExpression"/>
	    </xsl:if>
	</xsl:for-each>
    </xsl:template>

    <xsl:template name="ConditionalOrExpression">
	<xsl:for-each select="child::*">
	    <xsl:if test="name(.)='ConditionalAndExpression'">
	       <xsl:if test="position()=1">
	           <xsl:call-template name="ConditionalAndExpression"/>
	       </xsl:if>
	    </xsl:if>
	    <xsl:if test="position() &gt; 1">
		<xsl:text>||</xsl:text>
		<xsl:if test="name(.)='ConditionalAndExpression'">
		    <xsl:call-template name="ConditionalAndExpression"/>
	        </xsl:if>
	    </xsl:if>
	</xsl:for-each>
    </xsl:template>

    <xsl:template name="ConditionalAndExpression">
	<xsl:for-each select="child::*">
	    <xsl:if test="name(.)='InclusiveOrExpression'">
	       <xsl:if test="position()=1">
	           <xsl:call-template name="InclusiveOrExpression"/>
	       </xsl:if>
	    </xsl:if>
	    <xsl:if test="position() &gt; 1">
		<xsl:text>&amp;&amp;</xsl:text>
		<xsl:if test="name(.)='InclusiveOrExpression'">
		    <xsl:call-template name="InclusiveOrExpression"/>
	        </xsl:if>
	    </xsl:if>
	</xsl:for-each>
    </xsl:template>

    <xsl:template name="InclusiveOrExpression">
	<xsl:for-each select="child::*">
	    <xsl:if test="name(.)='ExclusiveOrExpression'">
	       <xsl:if test="position()=1">
	           <xsl:call-template name="ExclusiveOrExpression"/>
	       </xsl:if>
	    </xsl:if>
	    <xsl:if test="position() &gt; 1">
		<xsl:text>|</xsl:text>
		<xsl:if test="name(.)='ExclusiveOrExpression'">
		    <xsl:call-template name="ExclusiveOrExpression"/>
	        </xsl:if>
	    </xsl:if>
	</xsl:for-each>
    </xsl:template>

    <xsl:template name="ExclusiveOrExpression">
	<xsl:for-each select="child::*">
	    <xsl:if test="name(.)='AndExpression'">
	       <xsl:if test="position()=1">
	           <xsl:call-template name="AndExpression"/>
	       </xsl:if>
	    </xsl:if>
	    <xsl:if test="position() &gt; 1">
		<xsl:text>^</xsl:text>
		<xsl:if test="name(.)='AndExpression'">
		    <xsl:call-template name="AndExpression"/>
	        </xsl:if>
	    </xsl:if>
	</xsl:for-each>
    </xsl:template>

    <xsl:template name="AndExpression">
	<xsl:for-each select="child::*">
	    <xsl:if test="name(.)='EqualityExpression'">
	       <xsl:if test="position()=1">
	           <xsl:call-template name="EqualityExpression"/>
	       </xsl:if>
	    </xsl:if>
	    <xsl:if test="position() &gt; 1">
		<xsl:text>&amp;</xsl:text>
		<xsl:if test="name(.)='EqualityExpression'">
		    <xsl:call-template name="EqualityExpression"/>
	        </xsl:if>
	    </xsl:if>
	</xsl:for-each>
    </xsl:template>

    <xsl:template name="EqualityExpression">
	<xsl:for-each select="child::*">
	    <xsl:if test="name(.)='InstanceOfExpression'">
	       <xsl:if test="position()=1">
	           <xsl:call-template name="InstanceOfExpression"/>
	       </xsl:if>
	    </xsl:if>
	    <xsl:if test="position() &gt; 1">
		<xsl:if test="name(.)='Operator'">
		    <xsl:value-of select="."/>
	        </xsl:if>
		<xsl:if test="name(.)='InstanceOfExpression'">
		    <xsl:call-template name="InstanceOfExpression"/>
	        </xsl:if>
	    </xsl:if>
	</xsl:for-each>
    </xsl:template>

    <xsl:template name="InstanceOfExpression">
	<xsl:for-each select="child::*">
	    <xsl:if test="name(.)='RelationalExpression'">
	        <xsl:call-template name="RelationalExpression"/>
	    </xsl:if>
	    <xsl:if test="name(.)='Type'">
	        <xsl:text>instanceof</xsl:text>
	        <xsl:value-of select="."/>
	    </xsl:if>
	</xsl:for-each>
    </xsl:template>

    <xsl:template name="RelationalExpression">
	<xsl:for-each select="child::*">
	    <xsl:if test="name(.)='ShiftExpression'">
	       <xsl:if test="position()=1">
	           <xsl:call-template name="ShiftExpression"/>
	       </xsl:if>
	    </xsl:if>
	    <xsl:if test="position() &gt; 1">
		<xsl:if test="name(.)='Operator'">
		    <xsl:value-of select="."/>
	        </xsl:if>
		<xsl:if test="name(.)='ShiftExpression'">
		    <xsl:call-template name="ShiftExpression"/>
	        </xsl:if>
	    </xsl:if>
	</xsl:for-each>
    </xsl:template>

    <xsl:template name="ShiftExpression">
	<xsl:for-each select="child::*">
	    <xsl:if test="name(.)='AdditiveExpression'">
	       <xsl:if test="position()=1">
	           <xsl:call-template name="AdditiveExpression"/>
	       </xsl:if>
	    </xsl:if>
	    <xsl:if test="position() &gt; 1">
		<xsl:if test="name(.)='Operator'">
		    <xsl:value-of select="."/>
	        </xsl:if>
		<xsl:if test="name(.)='AdditiveExpression'">
		    <xsl:call-template name="AdditiveExpression"/>
	        </xsl:if>
	    </xsl:if>
	</xsl:for-each>
    </xsl:template>

   <xsl:template name="AdditiveExpression">
	<xsl:for-each select="child::*">
	    <xsl:if test="name(.)='MultiplicativeExpression'">
	       <xsl:if test="position()=1">
	           <xsl:call-template name="MultiplicativeExpression"/>
	       </xsl:if>
	    </xsl:if>
	    <xsl:if test="position() &gt; 1">
		<xsl:if test="name(.)='Operator'">
		    <xsl:value-of select="."/>
	        </xsl:if>
		<xsl:if test="name(.)='MultiplicativeExpression'">
		    <xsl:call-template name="MultiplicativeExpression"/>
	        </xsl:if>
	    </xsl:if>
	</xsl:for-each>
    </xsl:template>

    <xsl:template name="MultiplicativeExpression">
	<xsl:for-each select="child::*">
	    <xsl:if test="name(.)='UnaryExpression'">
	       <xsl:if test="position()=1">
	           <xsl:call-template name="UnaryExpression"/>
	       </xsl:if>
	    </xsl:if>
	    <xsl:if test="position() &gt; 1">
		<xsl:if test="name(.)='Operator'">
		    <xsl:value-of select="."/>
	        </xsl:if>
		<xsl:if test="name(.)='UnaryExpression'">
		    <xsl:call-template name="UnaryExpression"/>
	        </xsl:if>
	    </xsl:if>
	</xsl:for-each>
    </xsl:template>

    <xsl:template name="UnaryExpression">
	<xsl:for-each select="child::*">
	<xsl:if test="name(self::*[1])='UnaryExpression'">
	     <xsl:value-of select="@operator"/>
	     <xsl:call-template name="UnaryExpression"/>
	</xsl:if>
	<xsl:if test="name(self::*[1])='UnaryExpressionNotPlusMinus'">
	     <xsl:call-template name="UnaryExpressionNotPlusMinus"/>
	</xsl:if>
	<xsl:if test="name(self::*[1])='PreIncrementExpression'">
	     <xsl:call-template name="PreIncrementExpression"/>
	</xsl:if>
	<xsl:if test="name(self::*[1])='PreDecrementExpression'">
	     <xsl:call-template name="PreDecrementExpression"/>
	</xsl:if>
	</xsl:for-each>
    </xsl:template>

    <xsl:template name="UnaryExpressionNotPlusMinus">
	<xsl:for-each select="child::*">
	<xsl:if test="name(self::*[1])='UnaryExpression'">
	     <xsl:value-of select="@operator"/>
	     <xsl:call-template name="UnaryExpression"/>
	</xsl:if>
	<xsl:if test="name(self::*[1])='CastExpression'">
	     <xsl:call-template name="CastExpression"/>
	</xsl:if>
	<xsl:if test="name(self::*[1])='PostfixExpression'">
	     <xsl:call-template name="PostfixExpression"/>
	</xsl:if>
	</xsl:for-each>
    </xsl:template>

    <xsl:template name="CastExpression">
	<xsl:text>(</xsl:text>
	<xsl:value-of select="Type"/>
	<xsl:text>)</xsl:text>
	<xsl:for-each select="child::*">
	<xsl:if test="name(.)='UnaryExpression'">
	     <xsl:call-template name="UnaryExpression"/>
	</xsl:if>
	<xsl:if test="name(.)='UnaryExpressionNotPlusMinus'">
	     <xsl:call-template name="UnaryExpressionNotPlusMinus"/>
	</xsl:if>
	</xsl:for-each>
    </xsl:template>

    <xsl:template name="PostfixExpression">
        <xsl:for-each select="child::*">
	<xsl:if test="name(self::*[1])='PrimaryExpression'">
	     <xsl:value-of select="@operator"/>
	     <xsl:call-template name="PrimaryExpression"/>
	</xsl:if>
	</xsl:for-each>
    </xsl:template>

    <xsl:template name="PrimaryExpression">
        <xsl:for-each select="child::*">
	<xsl:if test="name(.)='PrimaryPrefix'">
	     <xsl:value-of select="@operator"/>
	     <xsl:call-template name="PrimaryPrefix"/>
	</xsl:if>
	<xsl:if test="name(.)='PrimarySuffix'">
	     <xsl:call-template name="PrimarySuffix"/>
	</xsl:if>
	</xsl:for-each>
    </xsl:template>

    <xsl:template name="PreIncrementExpression">
        <xsl:for-each select="child::*">
	  <xsl:text>++</xsl:text>
	  <xsl:call-template name="PrimaryExpression"/>
	</xsl:for-each>
    </xsl:template>

    <xsl:template name="PreDecrementExpression">
        <xsl:for-each select="child::*">
	  <xsl:text>--</xsl:text>
	  <xsl:call-template name="PrimaryExpression"/>
	</xsl:for-each>
    </xsl:template>


    <xsl:template name="AllocationExpression">
        <xsl:for-each select="child::*">
	    <xsl:choose>
	        <xsl:when test="name(.)='PrimitiveType'">
		    <xsl:text>new </xsl:text>
	            <xsl:value-of select="."/>
	        </xsl:when>
	        <xsl:when test="name(.)='Name'">
		    <xsl:text>new </xsl:text>
	            <xsl:value-of select="."/>
	        </xsl:when>
	        <xsl:when test="name(.)='ArrayDimsAndInits'">
	  	    <xsl:text>(</xsl:text>
	  	    <xsl:call-template name="ArrayDimsAndInits"/>
	  	    <xsl:text>)</xsl:text>
	        </xsl:when>
	        <xsl:when test="name(.)='Arguments'">
	  	    <xsl:apply-templates select="."/>
	        </xsl:when>
	        <xsl:when test="name(.)='ClassBody'">
	  	    <xsl:apply-templates select="."/>
	        </xsl:when>
	    </xsl:choose>
	</xsl:for-each>
    </xsl:template>

    <xsl:template name="ArrayDimsAndInits">
        <xsl:for-each select="child::*">
	    <xsl:choose>
	        <xsl:when test="name(.)='Expression'">
		    <xsl:text>[</xsl:text>
		    <xsl:call-template name="Expression"/>
		    <xsl:text>]</xsl:text>		    
	        </xsl:when>
	        <xsl:when test="name(.)='ArrayInitializer'">
	  	    <xsl:apply-templates select="."/>
	        </xsl:when>
	    </xsl:choose>
	</xsl:for-each>
    </xsl:template>

    <xsl:template name="PrimaryPrefix">
	<xsl:for-each select="child::*">
	    <xsl:choose>
	        <xsl:when test="name(.)='Literal'">
	            <xsl:value-of select="."/>
	        </xsl:when>
	        <xsl:when test="name(.)='Name'">
	            <xsl:value-of select="."/>
	        </xsl:when>
	        <xsl:when test="name(.)='Expression'">
	  	    <xsl:text>(</xsl:text>
	  	    <xsl:call-template name="Expression"/>
	  	    <xsl:text>)</xsl:text>
	        </xsl:when>
	        <xsl:when test="name(.)='AllocationExpression'">
	  	    <xsl:call-template name="AllocationExpression"/>
	        </xsl:when>
	        <xsl:when test="name(.)='ResultType'">
	            <xsl:value-of select="."/>
	  	    <xsl:text>.class</xsl:text>
	        </xsl:when>
		<xsl:otherwise>
	            <xsl:value-of select="."/>
		</xsl:otherwise>
	    </xsl:choose>
	</xsl:for-each>
    </xsl:template>


    <xsl:template name="PrimarySuffix">
	<xsl:for-each select="child::*">
	<xsl:if test="name(.)='Name'">
	     <xsl:text>.</xsl:text>
	     <xsl:apply-templates select="."/>
	</xsl:if>
	<xsl:if test="name(.)='Arguments'">
	     <xsl:apply-templates select="."/>
	</xsl:if>
	<xsl:if test="name(.)='Expression'">
	     <xsl:text>[</xsl:text>
	     <xsl:call-template name="Expression"/>
	     <xsl:text>]</xsl:text>
	</xsl:if>
	<xsl:if test="name(.)='AllocationExpression'">
	     <xsl:text>.</xsl:text>
 	     <xsl:call-template name="AllocationExpression"/>
	</xsl:if>
	</xsl:for-each>
    </xsl:template>

    <xsl:template name="Indentation">
        <xsl:for-each select="ancestor::*">
	    <xsl:if test="name(.)='ClassBody'">
      	        <xsl:text>&#160;&#160;&#160;&#160;</xsl:text>
	    </xsl:if>
	    <xsl:if test="name(.)='Block'">
      	        <xsl:text>&#160;&#160;&#160;&#160;</xsl:text>
	    </xsl:if>
	    <xsl:if test="name(.)='SwitchStatement'">
      	        <xsl:text>&#160;&#160;&#160;&#160;</xsl:text>
	    </xsl:if>
        </xsl:for-each>
    </xsl:template>
	
</xsl:stylesheet>

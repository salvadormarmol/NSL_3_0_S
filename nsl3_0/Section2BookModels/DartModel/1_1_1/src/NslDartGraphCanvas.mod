/* SCCS @(#)NslDartGraphCanvas.mod	1.4---09/24/99--19:11:16 */

/* Copyright 1999 University of Southern California Brain Lab */
/* Author Jacob Spoelstra */
/* email nsl@java.usc.edu */

nslClass NslDartGraphCanvas (NslFrame frame, NslVariableInfo vi)      
	extends NslOutCanvas(frame,vi) {

    int total=90;

    charString throw_col[total];
    double throw_buf[total];
    
    int last;
    
    public void addThrow(double direction, double prism, int type) {
	throw_buf[last] = direction;
	if (type == 0) {
	    if (prism > 1.) {
		throw_col[last] = "red";
	    } else {
		throw_col[last] = "blue";
	    }
	} else {
	    if (prism > 1.) {
		throw_col[last] = "magenta";
	    } else {
		throw_col[last] = "orange";
	    }
	}
	last++;
    }
	
    public void nslCreateCanvas() {  	
  	last = 0;
    }

    public void nslInitEpochCanvas() {  	
  	last = 0;
	nslClearDisplay();
    }

    public void nslRefresh() {       
 	
 	int x0,x1,y0,y1, h, w;
	int i;  
	 
    	h = nslGetHeight();
	w = nslGetWidth();
	
	// Legends
	y0 = 10;
	x0 = 5;
	nslFillRect(x0, y0 - 7, 7, 7,"blue");
	nslDrawString("Normal, Over",x0+10,y0,"blue");
	
	x0 = w/4;
	nslFillRect(x0, y0 - 7, 7, 7,"orange");
	nslDrawString("Normal, Under",x0+10,y0,"orange");

	x0 = w/2;
	nslFillRect(x0, y0 - 7, 7, 7,"red");
	nslDrawString("Prisms, Over",x0+10,y0,"red");

	x0 = w*3/4;
	nslFillRect(x0, y0 - 7, 7, 7,"magenta");
	nslDrawString("Prisms, Under",x0+10,y0,"magenta");

	// Draw axis
	x0 = 1;
	x1 = w-2;
	y0 = y1 = h/2;
	nslDrawLine(x0,y0,x1,y1,"Gray");
	
	// Indicate +- 30 degrees
	y0 = y1 = h/2 - 30*h/100;
	nslDrawLine(x0,y0,x1,y1,"Gray");
	y0 = y1 = h/2 + 30*h/100;
	nslDrawLine(x0,y0,x1,y1,"Gray");
	
	for (i=0;i<last;i++) {
	    x1 = i*(w-10)/total + 5;
	    y1 = h/2 - (int)(throw_buf[i]*(double)h/100.);
	    nslDrawLine(x0,y0,x1,y1,"black");
	    nslFillRect(x1 - 3, y1 - 3, 7, 7,throw_col[i]);
	    x0 = x1; y0 = y1;
	}

    }
  
    public void nslCollect() { 	
    
    	NslNumeric1 num = (NslNumeric1)vi.getNslVar();

	double throw_nr_in = num.getdouble(0);
	double throw_in    = num.getdouble(1);
  	double p_in        = num.getdouble(2);
  	double s_in        = num.getdouble(3);
	
  	if (throw_nr_in < 0 || throw_nr_in >=90) { 
  	    return;
  	}
	
	    
  	addThrow(throw_in-p_in,p_in,(int)s_in);
		
	nslUpdateDisplay();

    }
}

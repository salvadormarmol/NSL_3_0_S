/* SCCS @(#)GC_layer.mod	1.4---09/24/99--19:11:16 */

/* Copyright 1999 University of Southern California Brain Lab */
/* Author Jacob Spoelstra */
/* email nsl@java.usc.edu */

nslModule GC_layer() {
    // constants
    nslConstant double f_max  = 100.;

    // inports
    NslDinDouble2 pp_in();   // PP input
    NslDinDouble2 fcx_in(); // FCX input

    // outports
    NslDoutDouble2 gc_out(30,30); 

    // variables
    NslDouble0 w();
    NslDouble2 gc_mp(30,30);
    NslDouble0 gc_offset();
    NslDouble0 gc_slope();
    NslDouble0 gc_dist();
    NslInt0    gc_nd();
    int src[3600];
    int Xo[3600];
    int Yo[3600];
    int Xd[3600];
    int Yd[3600];
    int NC;

 public void initModule(){
     
     gc_offset = (NslDouble0)nslGetValue("dartModel.gc_offset");
     gc_slope  = (NslDouble0)nslGetValue("dartModel.gc_slope");
     gc_dist   = (NslDouble0)nslGetValue("dartModel.gc_dist");
     gc_nd     = (NslInt0)nslGetValue("dartModel.gc_nd");

     w = 1./(double)gc_nd;

     int gx,gy,i,x,y;
     
     gc_out = 50.;
     gc_mp = 0.;
     // Create mapping function
     NC = 0;
     for(gx=0;gx<30;gx++){
	 for(gy=0;gy<30;gy++){
	     for(i=0;i<gc_nd;i++){
		 Xd[NC] = gx;
		 Yd[NC] = gy;
		 if(nslRandom() < gc_dist){ // PP input
		     src[NC] = 0;
		     Xo[NC] = (int)nslRandom(3,8);
		     Yo[NC] = (int)nslRandom(0,10);
		 } else { // FCX input
		     src[NC] = 1;
		     Xo[NC] = (int)nslRandom(0,10);
		     Yo[NC] = (int)nslRandom(1,3);
		 }
		 NC++;
	     }
	 }
     }
 }
  
 public void simTrain() {
     simRun();
 }
 
 public void simRun(){
     int i,j;
     int mx,my,ix,iy;

     // Map inputs onto 30x30 array using mapping function
          
     gc_mp = 0.;
     for(i=0;i<NC;i++){
      mx = Xd[i];
      my = Yd[i];
      ix = Xo[i];
      iy = Yo[i];
      if(src[i]==0)
	  gc_mp[mx][my] = gc_mp[mx][my] + pp_in[ix][iy];
      else
	  gc_mp[mx][my] = gc_mp[mx][my] + fcx_in[ix][iy];
     }
     
     gc_mp = w * gc_mp;

     gc_out = f_max * nslSigmoid(gc_mp,gc_slope, gc_offset);        
 }
}

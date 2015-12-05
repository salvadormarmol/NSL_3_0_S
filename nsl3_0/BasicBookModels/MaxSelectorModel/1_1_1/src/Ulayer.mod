/* SCCS  %W--- %G% -- %U% */
//
// Ulayer
//
//////////////////////////////////////////////////////////////////////

nslModule Ulayer(int size) {

    //inports
    public NslDinDouble1 s_in();  
    public NslDinDouble0 v_in();

    //outports
    public NslDoutDouble1 uf(size);

    //variables
    private NslDouble1 up(size);  //for now; change when nslGetValue available
    private NslDouble0 w1();
    private NslDouble0 w2();
    private NslDouble0 h1();
    private NslDouble0 k();
    private double tau;

    public void initRun(){
	uf=0;
	up=0;
	tau = 1.0;
	w1= 1.0;
	w2= 1.0;
	h1= 0.1;
	k= 0.1;
    }

    public void simRun(){
	//compute : up=up+((timestep/tu)*du/dt)
	up = nslDiff(up, tau, -up + w1*uf-w2*v_in - h1 + s_in);
	uf = nslStep(up,(double)k,0,1.0);
    }
}



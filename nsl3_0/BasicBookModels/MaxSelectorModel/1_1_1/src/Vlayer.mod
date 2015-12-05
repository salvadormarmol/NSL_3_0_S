/* SCCS  %W--- %G% -- %U% */
//
// Vlayer
//
//////////////////////////////////////////////////////////////////////

nslModule Vlayer() extends NslModule() {

    // ports 
    public NslDinDouble1 u_in(); // will look for u_in
    public NslDoutDouble0 vf();  // output port

    // variables
    private NslDouble0 vp();  // neuron potential
    private NslDouble0 h2();
    private double tau;         // time constant

    public void initRun(){
	vf=0;
	vp=0;
	tau=1.0;
	h2 = 0.5;
    }

    public void simRun(){
	// vp=vp+((timestep/tv)*dv/dt)
	vp = nslDiff(vp, tau, -vp + nslSum(u_in) -h2);
	vf = nslRamp(vp);
    }
}


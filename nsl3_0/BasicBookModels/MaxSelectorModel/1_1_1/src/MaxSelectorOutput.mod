/* SCCS  %W--- %G% -- %U% */
//
// MaxSelectorOutput
//
//////////////////////////////////////////////////////////////////////

nslOutModule MaxSelectorOutput(int size) {

    public NslDinDouble1 s_out(size);
    public NslDinDouble1 uf(size);

    private NslDouble1 up(size);
    private boolean worked= false;
    
    public void initModule() {
	up.nslSetAccess('W');
    	nslAddAreaCanvas(s_out,0,1);
    	nslAddTemporalCanvas(up,-2.5,2.5);
    	nslAddAreaCanvas(uf,0,1);
    }
    
    public void simRun() {
	// slow
	//up=(NslDouble1)nslGetValue("maxSelectorModel.maxselector.u1.up");
	//fast
	worked=nslSetValue(up,"maxSelectorModel.maxselector.u1.up");
    }

}

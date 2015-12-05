/* SCCS  %W--- %G% -- %U% */
//
// MaxSelectorStimulus
//
//////////////////////////////////////////////////////////////////////

nslModule MaxSelectorStimulus(int size) {

    public NslDoutDouble1 s_out(size);

    public void initRun() {
	s_out=0;
	s_out[1]=0.5;
	s_out[3]=1.0;
    }
}








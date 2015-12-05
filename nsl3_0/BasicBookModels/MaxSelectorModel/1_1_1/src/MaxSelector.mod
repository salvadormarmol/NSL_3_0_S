/* SCCS @(#)MaxSelector.mod	1.2 --- 09/20/99 -- 21:15:36 */
//
// MaxSelector for MaxSelectorModel
//
////////////////////////////////////////////////////////////

nslModule MaxSelector(int size) extends NslModule() {

    public NslDinDouble1 in(size);
    public NslDoutDouble1 out(size);

    private Ulayer u1(size);  
    private Vlayer v1();                   

    public void makeConn() {
	nslConnect(this.in, u1.s_in); 
	nslConnect(u1.uf, v1.u_in); 
	nslConnect(v1.vf, u1.v_in); 
	nslConnect(u1.uf, this.out);
    }

}


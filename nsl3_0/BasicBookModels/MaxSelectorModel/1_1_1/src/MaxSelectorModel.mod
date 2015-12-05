/* SCCS  %W--- %G% -- %U% */
//
// MaxSelectorModel 
//
//////////////////////////////////////////////////////////////////////
/**
 * MaxSelector - A class representing the Didday Model or Maximum Selector Model.
 * The neuron (element) with the greatest strength will propogate to the output
 * of the model blocking out the signal by other neurons.
 * @see            MaxSelector.mod
 * @version        3.0.k 99/4/30
 * @author         HBP
 * #var private: w1 weight constant used in u membrane potential calculation. <p>
 * #var private: w2 weight constant used in u membrane potential calculation.<p>
 * #var private: h1 is a constant that must be 0 <= h1, and is use d in u membrane potential calculation.<p>
 * #var private: h2 is a constant that must be 0<=h2<1 , and is use d in v membrane potential calculation.<p>
 * #var private: k is a threshold constant used in the step function when calculating u firing rate.<p>
 * #var private: s1 is the source array of type NslDouble1  <p>
 * #var private: u_pot holds the membrane potentials for the first layer of type NslDouble1  <p>
 * #var private: u holds the firing rates for the first layer of type NslDouble1  <p>
 * #var private: v_pot holds the membrane potentials for the second layer of type NslDouble0 <p>
 * #var private: v holds the firing rates for the second layer of type NslDouble0 <p>
*/

/* MaxSelectorModel is the name of the model */
/* MaxSelectorModel does not contain any outside ports, but does inherit NslModel */

nslModel MaxSelectorModel() {
 
    private nslConstant int size = 10;

    private MaxSelectorStimulus stimulus(size);
    private MaxSelector maxselector(size);  
    private MaxSelectorOutput output(size);  

    public void initSys() {
	system.setRunEndTime(10.0);
	system.nslSetRunDelta(0.1);
    }

    public void makeConn() {
        nslConnect(stimulus.s_out, maxselector.in);
	nslConnect(stimulus.s_out, output.s_out);
	nslConnect(maxselector.out, output.uf); 
    }
}





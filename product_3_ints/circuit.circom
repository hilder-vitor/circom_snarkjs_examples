template Product3Ints() {

    signal input a;
    signal input b;
    signal input c;
    signal v;
    signal output out;
    
    v <== a * b; 
    out <== c * v;
}

component main {public [a]} = Product3Ints();

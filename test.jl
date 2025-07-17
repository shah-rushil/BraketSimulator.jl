using BraketSimulator

# This script demonstrates how to run a quantum phase estimation circuit using BraketSimulator
# and explains why the original test.jl file was causing a segmentation fault.

println("=== Quantum Phase Estimation Circuit Test ===")


qasm_source = """ 
OPENQASM 3.0;
def physical_magic_state_t_type(int[32] q) {
    ry(0.9553166181245092) __qubits__[q];
    rz(pi / 4) __qubits__[q];
}
def decoder(int[32] q0, int[32] q1, int[32] q2, int[32] q3, int[32] q4) {
    cnot __qubits__[q1], __qubits__[q0];
    cz __qubits__[q1], __qubits__[q0];
    cz __qubits__[q1], __qubits__[q2];
    cz __qubits__[q1], __qubits__[q4];
    cnot __qubits__[q2], __qubits__[q0];
    cz __qubits__[q2], __qubits__[q3];
    cz __qubits__[q2], __qubits__[q4];
    cnot __qubits__[q3], __qubits__[q0];
    cnot __qubits__[q4], __qubits__[q0];
    cz __qubits__[q4], __qubits__[q0];
    z __qubits__[q0];
    z __qubits__[q1];
    z __qubits__[q4];
    h __qubits__[q1];
    h __qubits__[q2];
    h __qubits__[q3];
    h __qubits__[q4];
}
def basis_rotation_t_type(int[32] q) {
    rz(-(pi / 4)) __qubits__[q];
    ry(-0.9553166181245092) __qubits__[q];
}
bit[4] c;
bit __bit_2__;
bit __bit_3__;
bit __bit_4__;
bit __bit_5__;
bit c2;
qubit[5] __qubits__;
bool c1 = true;
while (c1) {
    for int q in [0:5 - 1] {
        reset __qubits__[q];
        physical_magic_state_t_type(q);
    }
    decoder(0, 1, 2, 3, 4);
    bit[4] __bit_1__ = "0000";
    __bit_1__[0] = measure __qubits__[1];
    __bit_1__[1] = measure __qubits__[2];
    __bit_1__[2] = measure __qubits__[3];
    __bit_1__[3] = measure __qubits__[4];
    c = __bit_1__;
    __bit_2__ = c[0];
    __bit_3__ = c[1];
    __bit_4__ = c[2];
    __bit_5__ = c[3];
    bool __bool_6__;
    __bool_6__ = __bit_4__ || __bit_5__;
    bool __bool_7__;
    __bool_7__ = __bit_3__ || __bool_6__;
    bool __bool_8__;
    __bool_8__ = __bit_2__ || __bool_7__;
    c1 = __bool_8__;
}
h __qubits__[0];
y __qubits__[0];
basis_rotation_t_type(0);
bit __bit_9__;
__bit_9__ = measure __qubits__[0];
c2 = __bit_9__;

"""
			
println(BraketSimulator.new_to_circuit("bool c1 = true;"))
simulator = BranchedSimulatorOperators(StateVectorSimulator(2, 100))
branched_sim = BraketSimulator.evolve_branched_operators(simulator, BraketSimulator.new_to_circuit(qasm_source), Dict("a_in"=>3, "b_in"=>7))
states = BraketSimulator.calculate_current_state(branched_sim)

println(length(branched_sim.instruction_sequences))
# println(branched_sim.measurements)
# println(branched_sim.variables)
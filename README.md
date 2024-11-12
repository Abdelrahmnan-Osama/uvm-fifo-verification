# UVM Synchronous FIFO Verification

## Project Overview
This project involves the verification of a synchronous FIFO using Universal Verification Methodology (UVM) in QuestaSim. 
A comprehensive UVM environment was developed to validate the FIFO’s functionality, coverage, and robustness.

## Tools Used
- UVM
- SystemVerilog Assertions (SVA)
- QuestaSim

## Key Features
- **Full UVM Environment:** Complete verification environment following UVM methodology.
- **Sequence Items and Coverpoints:** Constraints added to sequence items and coverage points set up to monitor key conditions.
- **Assertions Integration:** Assertions in the top module to verify functional correctness.
- **Specialized Sequences:** Main sequence split into specialized sequences for targeted testing.
- **Coverage Reports:** Generated Code, Functional, and Sequential Domain Coverage.
- **Bug Report Analysis:** Analysis and recommendations for RTL adjustments.

## Project Structure
- **src/**: UVM testbench and sequence files.
- **assertions/**: Assertions and coverage definitions.
- **simulations/**: Simulation results and coverage reports.

## How to Run
1. Clone the repository.
2. Open in QuestaSim.
3. Run the `fifo.do` file to automate the tests and generate reports.

## Results
- Coverage reports for code, functional, and sequential domains.
- Detailed bug report with RTL recommendations.
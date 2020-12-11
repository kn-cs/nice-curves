## Assembly and high-level implementations of scalar multiplication on the Montgomery curve M4058

The source code of this directory correspond to the work [Security and Efficiency Trade-offs for Elliptic Curve Diffie-Hellman
at the 128-bit and 224-bit Security Levels](https://eprint.iacr.org/2019/1259), authored by [Kaushik Nath](kaushikn_r@isical.ac.in) & [Palash Sarkar](palash@isical.ac.in) of [Indian Statistical Institute, Kolkata, India](https://www.isical.ac.in),
containing various assembly and high-level (using only C) implementations of scalar multiplication on the Montgomery curve M4698. The implementations of Montgomery ladder are developed targeting the modern Intel architectures like Skylake and Haswell.

To report a bug or make a comment regarding the implementations please drop a mail to: [Kaushik Nath](kaushikn_r@isical.ac.in).

---

### Compilation and execution of programs 
    
* Please compile the ```makefile``` in the **test** directory and execute the generated executable file. 
* One can change the architecture accordingly in the makefile before compilation. Default provided is ```Skylake```.
---

### Overview of the implementations in the repository

* **intel64-maa-8limb**: 8-limb 64-bit assembly implementation using the instructions ```mul/add/adc```.
    
* **intel64-mxaa-7limb**: 7-limb 64-bit assembly implementation using the instructions ```mulx/add/adc```.

* **intel64-maax-7limb**: 7-limb 64-bit assembly implementation using the instructions ```mulx/adcx/adox```.

* **intel64-avx2-4x1-16limb**: 16-limb 4-way vectorized assembly implementations using Algorithms 7, 8 and 9 of [Efficient 4-way Vectorizations of the Montgomery Ladder](https://eprint.iacr.org/2020/378.pdf).

* **portable-c**: 8-limb 64-bit high-level implementation using only C.



---    

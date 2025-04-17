Introduction
------------

Fiats, an acronym that expands to “Functional inference and training for surrogates” or
“Fortran inference and training for science,” is a deep learning library that targets
high-performance computing applications in Fortran 2023.


Fiats provides novel support for functional programming styles by providing inference and
training procedures declared to be “pure,” a language requirement for invoking a procedure
inside Fortran’s loop-parallel construct: “do concurrent.” Because pure procedures clarify
data dependencies, at least four compilers are currently capable of automatically
parallelizing “do concurrent” on central processing units (CPUs) or graphics processing
units (GPUs). The talk will present strong scaling results on a single node of Berkeley Lab’s
Perlmutter supercomputer, showing near-ideal scaling up to 16 cores with additional speedup
up to the hardware limit of 128 cores based on results obtained by compiling with a fork of
the LLVM Flang Fortran compiler.

Fiats provides a derived type that encapsulates neural-network parameters and provides
generic bindings for invoking inference functions and training subroutines of various
precisions. A novel feature of the Fiats design is that all procedures involved in
inference and training are non-overridable, which eliminates the need for dynamic
dispatch at call sites. In addition to simplifying the structure of the resulting executable
program and potentially improving performance, we expect this feature to enable the
automatic offload of inference and training to GPUs.

The talk will conclude by presenting the use of “do concurrent” in a parallel training
algorithm, highlighting the considerable simplifications afforded by the evolution of
“do concurrent” from its introduction in Fortran 2008 to its enhancement in Fortran 2018
and further enhancement in Fortran 2023.

[Add a brief introduction to your notebook here. This section should include a brief description of the problem you are trying to solve, the data you are using, and the methods you are using to solve the problem.]

You can use LaTeX syntax for equations. For example, the quadratic formula is shown below:

$$
x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}
$$

You can also embed images in your notebook. 
For example, the image below shows the [NCAR logo](https://www2.cisl.ucar.edu/sites/default/files/NCAR_logo_2017_0.png).

Here is a link to markdown syntax: [Markdown Syntax](https://www.markdownguide.org/basic-syntax/). 
# MSVMLAB

Multiclass support vector machine (MSVM) in MATLAB.

## Code organization

### Solver file naming convention

A solver is named via the following formula:

``<kernel/linear>_<variant>_svm_<optimization technique>.m``

We use ∅ to denote the empty string. 

A "solver" with an empty string for ``<variant>`` and/or ``<optimization technique>`` means that the solver is an [abstract class]([Abstract Classes and Class Members - MATLAB & Simulink (mathworks.com)](https://www.mathworks.com/help/matlab/matlab_oop/abstract-classes-and-interfaces.html)), to be implemented.

- ``<kernel/linear>``  is equal to either ``{kernel, linear}``
- ``<variant>`` is one of ``{∅, cs, ww}`` where 
  - ``∅`` = abstract
  - ``cs`` = Crammer-Singer
  - ``ww`` = Weston-Watkins
- ``optimization technique`` is one of ``{∅,qp,decomp,bcd,sp}`` where
  - ``∅`` = abstract
  - ``qp`` = Quadratic program solver
  - ``decomp`` = decomposition method
  - ``bcd`` = block coordinate descent on the dual
  - ``sp`` = saddle-point optimization

+-- solvers
|   +-- kernel_msvm_solvers
|   |   +-- kernel_msvm.m            Abstract base class
|   |   +-- kernel_msvm_decomp.m     Decomposition (working set) method
|   |   +-- kernel_msvm_qp.m         QP solver
|   +- linear_msvm_solvers
|   |   +-- linear_msvm.m            Abstract class
|   |   +-- linear_msvm_bcd.m        Block coordinate descent (TODO)
|   |   +-- linear_cs_svm_sp.m         Saddle point

# Kernel MSVM solvers


# Synthetic datasets


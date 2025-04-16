# Cloud microphysics training and aerosol inference with the Fiats deep learning library

[![JupyterBook](https://github.com/UCAR-SEA/SEA-ISS-Template/actions/workflows/deploy.yml/badge.svg)](https://github.com/UCAR-SEA/SEA-ISS-Template/actions/workflows/deploy.yml)
[![Made withJupyter](https://img.shields.io/badge/Made%20with-Jupyter-green?style=flat-square&logo=Jupyter&color=green)](https://jupyter.org/try)
![Static Badge](https://img.shields.io/badge/DOI-10.XXXXX%2Fnnnnn-blue)

**Authors**: Damian Rouson, Zhe Bai, Dan Bonachea, Ondrej Certik, Baboucarr Dibba, Ethan Gutmann, Katherine Rasmussen, David Torres

**Abstract**: This paper presents two atmospheric sciences demonstration applications in the `demo/app` subdirectory of the [Fiats](https://go.lbl.gov/fiats) software repository.  The `train-cloud-microphysics` application trains a neural-network cloud microphysics surrogate model that has been integrated into the [Berkeley Lab fork](https://go.lbl.gov/icar) of the Intermediate Complexity Atmospheric Research (ICAR) model. The `infer-aerosol` application performs parallel inference with an aerosol dynamics surrogate pretrained in PyTorch using data from the Energy Exascale Earth System Model ([E3SM](https://e3sm.org/).  The paper describes the structure and execution of each demo app and provides a link to the pretrained model stored in the Fiats JavaScript Object Notation (JSON) file format for the reader to download and reproduce our results.  Because producing the ICAR training data for the cloud microphysics model requires thousands of core-hours and storing the resulting dat requires hundreds of gigabytes, we provide a simplified proxy for users to gain some experience with training using Fiats.  The proxy, a `learn-microphysics` program in the `example` subdirectory, trains a nueral network to serve as a surrogate for the saturated-mixing ratio function in ICAR's simpler microphysics model.

Introduction
------------

Fiats, an acronym that expands to “Functional inference and training for surrogates” or “Fortran inference and training for science,” is a deep learning library that targets high-performance computing applications in Fortran 2023. 


Fiats provides novel support for functional programming styles by providing inference and training procedures declared to be “pure,” a language requirement for invoking a procedure inside Fortran’s loop-parallel construct: “do concurrent.” Because pure procedures clarify data dependencies, at least four compilers are currently capable of automatically parallelizing “do concurrent” on central processing units (CPUs) or graphics processing units (GPUs). The talk will present strong scaling results on a single node of Berkeley Lab’s Perlmutter supercomputer, showing near-ideal scaling up to 16 cores with additional speedup up to the hardware limit of 128 cores based on results obtained by compiling with a fork of the LLVM Flang Fortran compiler.

Fiats provides a derived type that encapsulates neural-network parameters and provides generic bindings for invoking inference functions and training subroutines of various precisions. A novel feature of the Fiats design is that all procedures involved in inference and training are non-overridable, which eliminates the need for dynamic dispatch at call sites. In addition to simplifying the structure of the resulting executable program and potentially improving performance, we expect this feature to enable the automatic offload of inference and training to GPUs.

The talk will conclude by presenting the use of “do concurrent” in a parallel training algorithm, highlighting the considerable simplifications afforded by the evolution of “do concurrent” from its introduction in Fortran 2008 to its enhancement in Fortran 2018 and further enhancement in Fortran 2023.

**Keywords:** deep learning, Fortran, cloud microphysics, aerosols, surrogate model, neural network

**Acknowledgements**: [List any Acknowledgements]

---

*Note: Replace the placeholders above with the specific details of your paper.*
  


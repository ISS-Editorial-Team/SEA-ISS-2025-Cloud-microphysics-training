# Cloud microphysics training and aerosol inference with the Fiats deep learning library

[![JupyterBook](https://github.com/UCAR-SEA/SEA-ISS-Template/actions/workflows/deploy.yml/badge.svg)](https://github.com/UCAR-SEA/SEA-ISS-Template/actions/workflows/deploy.yml)
[![Made withJupyter](https://img.shields.io/badge/Made%20with-Jupyter-green?style=flat-square&logo=Jupyter&color=green)](https://jupyter.org/try)
![Static Badge](https://img.shields.io/badge/DOI-10.XXXXX%2Fnnnnn-blue)

**Authors:** [Damian Rouson](mailto:rouson@lbl.gov), [Zhe Bai](mailto:rouson@lbl.gov), [Dan Bonachea](mailto:dobonachea@lbl.gov), [Baboucarr Dibba](mailto:bdibba@lbl.gov), [Ethan Gutmann](mailto:gutmann@ucar.edu), [Katherine Rasmussen](mailto:krasmussen@lbl.gov), [David Torres](mailto:davytorres@nnmc.edu), [Yunhao Zhang](mailto:yunhao2783@gmail.com), [Jordan Welsman](welsman@lbl.gov)

**Keywords:** deep learning, Fortran, cloud microphysics, aerosols, high-performance computing, neural network, surrogate model

**Abstract**: This notebook presents two atmospheric sciences demonstration applications in the [Fiats](https://go.lbl.gov/fiats) software repository.  The `train-cloud-microphysics` application trains a neural-network cloud microphysics surrogate model that has been integrated into the [Berkeley Lab fork](https://go.lbl.gov/icar) of the Intermediate Complexity Atmospheric Research (ICAR) model. The `infer-aerosol` application performs parallel inference with an aerosol dynamics surrogate pretrained in PyTorch using data from the Energy Exascale Earth System Model ([E3SM](https://e3sm.org/)).  In addition to describing the structure and behavior of the demonstration applications, this notebook aims to provide enough information for the interested reader to gain experience with using Fiats for microphysics training inference and aerosols inference.  Toward this end, the notebook links to a pretrained aerosol model stored in the Fiats JavaScript Object Notation (JSON) file format for downloading, importing, and using to perform batch inference calculations with Fiats.  Because capturing even a single simulated year of physics-based ICAR cloud microphysics model inputs and outputs requires thousands of core-hours to produce and hundreds of gigabytes to store, this notebook links to a proxy application that gives the reader some experience with training one microphysics component: a saturated mixing ratio function.  The proxy application is the `learn-saturated-mixing-ratio` program in the `example` subdirectory of Fiats along with a `gnuplot` script that plots a measure of the accuracy of the resulting surrogate model across a domain bounded by the physics-based model input extrema.

**Acknowledgements**: This material was based upon work supported by the U.S. Department of Energy, Office of Science, Office of Advanced Scientific Computing Research CASS (S4PST) and SciDAC (NUCLEI) programs under Contract No. DE-AC02-05CH11231.



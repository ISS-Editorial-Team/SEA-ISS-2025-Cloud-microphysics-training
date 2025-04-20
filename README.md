# Cloud microphysics training and aerosol inference with the Fiats deep learning library

[![JupyterBook](https://github.com/UCAR-SEA/SEA-ISS-Template/actions/workflows/deploy.yml/badge.svg)](https://github.com/UCAR-SEA/SEA-ISS-Template/actions/workflows/deploy.yml)
[![Made withJupyter](https://img.shields.io/badge/Made%20with-Jupyter-green?style=flat-square&logo=Jupyter&color=green)](https://jupyter.org/try)
![Static Badge](https://img.shields.io/badge/DOI-10.XXXXX%2Fnnnnn-blue)

**Authors:** [Damian Rouson](mailto:rouson@lbl.gov), [Zhe Bai](mailto:rouson@lbl.gov), [Dan Bonachea](mailto:dobonachea@lbl.gov), [Katherine Rasmussen](mailto:krasmussen@lbl.gov)

**Keywords:** deep learning, Fortran, cloud microphysics, aerosols, high-performance computing, neural network, surrogate model

**Abstract**: This notebook presents two atmospheric sciences demonstration applications in the [Fiats](https://go.lbl.gov/fiats) software repository. The first, `train-cloud-microphysics`, trains a neural-network cloud microphysics surrogate model that has been integrated into the [Berkeley Lab fork](https://go.lbl.gov/icar) of the Intermediate Complexity Atmospheric Research (ICAR) model. The second, `infer-aerosol`, performs parallel inference with an aerosol dynamics surrogate pretrained in PyTorch using data from the Energy Exascale Earth System Model ([E3SM](https://e3sm.org)). In addition to describing the structure and behavior of the demonstration applications, this notebook aims to provide enough information for the interested reader to gain experience with using Fiats for microphysics training and aerosols inference. Toward this end, the notebook details how to run two somewhat simpler example programs as proxies for the demonstration applications: a microphysics training example program and a concurrent inferences example program, both of which are in the Fiats repository. The microphysics training proxy is a self-contained example program, requiring no input files. The aerosol inference proxy uses a pretrained aerosol model stored in the Fiats JavaScript Object Notation (JSON) file format and hyperlinked into this notebook for downloading and importing into the concurrent inferences example.

**Acknowledgements**: This material was based upon work supported by the U.S. Department of Energy, Office of Science, Office of Advanced Scientific Computing Research CASS (S4PST) and SciDAC (NUCLEI) programs under Contract No. DE-AC02-05CH11231.



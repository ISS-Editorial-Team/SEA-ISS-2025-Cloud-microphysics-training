# Cloud microphysics training and aerosol inference with the Fiats deep learning library

[![JupyterBook](https://github.com/UCAR-SEA/SEA-ISS-Template/actions/workflows/deploy.yml/badge.svg)](https://github.com/UCAR-SEA/SEA-ISS-Template/actions/workflows/deploy.yml)
[![Made withJupyter](https://img.shields.io/badge/Made%20with-Jupyter-green?style=flat-square&logo=Jupyter&color=green)](https://jupyter.org/try)
![Static Badge](https://img.shields.io/badge/DOI-10.XXXXX%2Fnnnnn-blue)

**Authors**: Damian Rouson, Zhe Bai, Dan Bonachea, Baboucarr Dibba, Ethan Gutmann, Katherine Rasmussen, David Torres, Yunhao Zhang

**Abstract**: This paper presents two atmospheric sciences demonstration applications in the `demo/app` subdirectory of the [Fiats](https://go.lbl.gov/fiats) software repository.  The `train-cloud-microphysics` application trains a neural-network cloud microphysics surrogate model that has been integrated into the [Berkeley Lab fork](https://go.lbl.gov/icar) of the Intermediate Complexity Atmospheric Research (ICAR) model. The `infer-aerosol` application performs parallel inference with an aerosol dynamics surrogate pretrained in PyTorch using data from the Energy Exascale Earth System Model ([E3SM](https://e3sm.org/).  The paper describes the structure and execution of each demo app and provides a link to the pretrained model stored in the Fiats JavaScript Object Notation (JSON) file format for the reader to download and reproduce our results.  Because producing the ICAR training data for the cloud microphysics model requires thousands of core-hours and storing the resulting dat requires hundreds of gigabytes, we provide a simplified proxy for users to gain some experience with training using Fiats.  The proxy, a `learn-microphysics` program in the `example` subdirectory, trains a nueral network to serve as a surrogate for the saturated-mixing ratio function in ICAR's simpler microphysics model.

**Keywords:** deep learning, Fortran, cloud microphysics, aerosols, surrogate model, neural network

**Acknowledgements**: This material was based upon work supported by the U.S. Department of Energy, Office of Science, Office of Advanced Scientific Computing Research CASS (S4PST) and SciDAC (NUCLEI) programs under Contract No. DE-AC02-05CH11231.



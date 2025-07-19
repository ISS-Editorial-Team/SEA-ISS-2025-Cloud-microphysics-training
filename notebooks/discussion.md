# Discussion
This section aims to provide the interested reader with experience in running programs that use Fiats for predicting atmospheric aerosol dynamics and for training a cloud microphysics model. 

## Build system and compiler installation
Building Fiats requires the Fortran Package Manager ([`fpm`](https://github.com/fortran-lang/fpm)) and the LLVM [`flang`](https://github.com/llvm/llvm-project) Fortran compiler.  The "package manager" part of `fpm`'s name refers to `fpm`'s ability to download, if necessary, and build a project's dependencies if those dependencies are also `fpm` projects.  Because LLVM is not an `fpm` project, `fpm` cannot build `flang`.

The commands in this notebook were tested with `fpm` 0.11.0 and `flang` 20.1.2.  It might be easiest to install `fpm` and `flang` using package managers -- for example, using the [Homebrew](https://brew.sh) command `brew install fpm flang` on macOS or the command `sudo apt install fortran-fpm flang-20` on Ubuntu Linux.  Also, the [`spack`](https://github.com/spack/spack) multi-platform package manager installs `flang` on Windows, Linux, and macOS.  For example, the following three instructions from the current `spack` [README.md](https://github.com/spack/spack/blob/8fd48c5d30e998d9ad77f85b0e9b714699e856e5/README.md) file suffice to install `flang` in a `bash`, `zsh`, or `sh` shell:
```bash
git clone -c feature.manyFiles=true --depth=2 https://github.com/spack/spack.git
. spack/share/spack/setup-env.sh
spack install llvm+flang
```
where only the second of these three steps changes for other shells.  The `spack` README.md provides alternatives for the `tcsch` and `fish` shells.

Alternatively, if you have the GNU Compiler Collection ([GCC](https://gcc.gnu.org)) `gfortran` compiler, an especially easy way to install `fpm` is to compile the single file that each `fpm` release offers with all of `fpm`'s source code (which is written in Fortran) concatenated into one file.  On the `fpm` 0.11.0 release page, for example, that file is [fpm-0.11.0.F90](https://github.com/fortran-lang/fpm/releases/download/v0.11.0/fpm-0.11.0.F90).  Downloading that file to an otherwise empty directory (because compiling it produces many files, all but one of which can be deleted after compiling), compiling with a command such as `gfortran -o fpm -fopenmp fpm-0.11.0.F90`, and moving the resulting `fpm` executable file to a directory in your `PATH` gives you a working installation of `fpm`.  In the provided single-file compile command, `-fopenmp` enables `fpm` to shorten compile times via parallel builds.

With `fpm` and `flang` installed and the repository cloned as explained in the [Getting started](#getting-started) section of this notebook, and with your present working directory set to anywhere in the clone, you can build and test Fiats with the command:
```bash
fpm test --compiler flang-new --flag -O3
```
where we invoke `flang` via the alias `flang-new` for historical reasons.  We expect that an upcoming version of `fpm` will recognize `flang` as LLVM `flang`.  If everything succeeds, the trailing output from the latter command should be:
```
_________ In total, 37 of 37 tests pass. _________
```
at which point it will be possible to run any of the programs in the Fiats `example/` subdirectory.

## Running microphysics training
As explained in the [Objectives](#objectives) section of this notebook, this section uses a proxy for the much more involved `train-cloud-microphysics` demonstration application.  The proxy is the `example/learn-saturated-mixing-ratio` program.  The proxy trains a neural-network surrogate to represent the function defined in `example/supporting-modules/saturated-mixing-ratio.f90`.  The function result is the saturated mixing ratio, a thermodynamic variable corresponding to the maximum amount of water vapor that the air at a given location can hold in the gaseous state without condensing to liquid.   The function has two arguments: temperature and pressure. The function was extracted from ICAR's SB04 simple microphysics model, refactored to accept arguments mapped to the unit interval [0,1], and then wrapped by a function that accepts and returns `tensor_t` objects from which the Fiats `infer` function extracts model inputs and the corresponding outputs.  The resulting trained neural network stores the physics-based (SB04) model input and output extrema for purposes of capturing the mapping function that transforms data between the application data range and the model data range ([0,1]). 

The `learn-saturated-mixing-ratio` example program uses Fiats entities that form a subset of those used by `train-cloud-microphysics`:
```fortran
   use fiats_m, only : trainable_network_t, mini_batch_t, tensor_t, input_output_pair_t, shuffle
```
which demonstrates why the example is a simpler proxy for the demonstration application. Because the [Methods](#methods) section of this notebook details the demonstration application's use of Fiats, the current section skips over example program details and instead focuses on running the example.

When compiled and run without command-line arguments, each program in the Fiats `example/` and `demo/app/` subdirectories prints helpful usage information.  Hence, running the provided programs without arguments is one way to find out the required arguments: 
```bash
   fpm run \
     --example learn-saturated-mixing-ratio \
     --compiler flang-new \
     --flag -O3
```
which generates the trailing output:
```bash
Fortran ERROR STOP: 

Usage:
  fpm run \
  --example learn-saturated-mixing-ratio \
  --compiler flang-new \
  --flag "-O3" \
  -- --output-file "<file-name>"

<ERROR> Execution for object " learn-saturated-mixing-ratio " returned exit code  1
<ERROR> *cmd_run*:stopping due to failed executions
STOP 1
```
where `fpm` commands place command-line arguments for the running program after double-dashes (`--`), so the above message indicates that the program requires command-line arguments of the form `--output-file "<file-name>"`.

The following command runs the program again with the required argument:
```bash
   fpm run \
     --compiler flang-new \
     --flag -O3 \
     --example learn-saturated-mixing-ratio \
     -- --output-file saturated-mixing-ratio.json 
```
which should produce leading output like the following:
```
 Initializing a new network
         Epoch | Cost Function| System_Clock | Nodes per Layer
         1000    0.77687E-04     6.0089      2,4,72,2,1
         2000    0.60092E-04     12.062      2,4,72,2,1
         3000    0.45148E-04     18.110      2,4,72,2,1
         4000    0.33944E-04     24.253      2,4,72,2,1
```
showing the cost function decreasing with increasing numbers of epochs for a neural network that accepts `2` inputs (normalized pressure and temperature) and uses three hidden layers of width `4`, `72`, and `2` to produce `1` output (saturated mixing ratio).

The program uses a cost-function tolerance of `1.0E-08`, which takes a very long time to attain when compiled with LLVM `flang` 20.  (An earlier version of Fiats, 0.14.0, supports compiling with `gfortran`, which produces executable programs that run approximately 20x faster.  We anticipate supporting `gfortran` again in a future release after bugs in `gfortran`'s support for kind type parameters have been fixed. We also anticipate that future releases of LLVM `flang`, one of the newest Fortran compilers, will improve in the ability to optimize code and generate faster programs.)

To gracefully shut down the example program, issue the command `touch stop`, which creates an empty file named `stop`.  The program periodically checks for this file, halts execution if the file exists, and prints a table of model inputs along with the actual and desired model outputs.  [Fig. 1](sat-mix-rat) compares the surrogate and physics-based model output surfaces over the unit square domain $[0,1]^2$. It demonstrates that the two surfaces are visually indistinguishable, except that whichever of the two surface colors shows at a given point indicates which surface would be visible from the given viewing angle.  Viewed from above, for example, the color corresponding to whichever surface is slightly higher than the other shows.  From below, whichever is slightly lower shows.

```{figure} ../assets/saturated-mixing-ratio-surface-plot2.png
:name: sat-mix-rat
:align: center

Surface plots of the actual (green) and desired (blue) saturated mixing ratio model outputs.
```

## Running aerosol inference
This section of the notebook uses the `concurrent-inferences` program in the `example/` subdirectory as a proxy for the more involved `infer-aerosol` demonstration application in the `demo/app` subdirectory.  This example program performs batches of inferences taking a three-dimensional (3D) array of `tensor_t` input objects and producing a 3D array of `tensor_t` output objects.  The sizes of the 3D arrays is representative of the grids used in an ICAR production run. 

Run the proxy with no command-line arguments for the program itself:
```bash
   fpm run --example concurrent-inferences --compiler flang-new --flag -O3
```
which should yield the usage information:
```bash
Usage:
  fpm run \
    --example concurrent-inferences \
    --compiler flang-new --flag -O3 \
    -- --network "<file-name>" \
    [--do-concurrent] [--openmp] [--elemental] [--double-precision] [--trials <integer>]
where <> indicates user input and [] indicates an optional argument.
```
where the first three optional arguments specify a strategy for iterating across the batch: Fortran's loop-parallel `do concurrent` construct, OpenMP multithreading, or an `elemental` procedure that operates on whole `tensor_t` arrays or array slices in one `infer` invocation.  If none of the first three optional arguments exists on the command line, then all three execute.  The fourth optional argument decides whether to additionally perform inference using double precision. The final optional argument determines the number of times each strategy will execute.  See {cite}`rouson2025automatically` for a discussion of the performance of each of these approaches.

Before running `concurrent-inferences`, download the pretrained aerosol model file [model.json](./assets/model.json) and save it to the root directory of your Fiats clone. 
To import the pretrained model and run the program, enter the following command:
```bash
  fpm run \
    --example concurrent-inferences \
    --compiler flang-new --flag -O3 \
    -- --network model.json
```
which should yield trailing output of the form:
```
 Constructing a new neural_network_t object from the file model.json
 Defining an array of tensor_t input objects with random normalized components
 Performing 1250565  inferences inside `do concurrent`.
 Elapsed system clock during `do concurrent` inference:  42.464405
 Performing 1250565  inferences inside `omp parallel do`.
 Elapsed system clock during `OpenMP` inference:  43.313417
 Performing elemental inferences inside `omp workshare`
 Elapsed system clock during `elemental` inference:  41.631988
 Constructing a new neural_network_t object from the file model.json
 Defining an array of tensor_t input objects with random normalized components
 Performing double-precision inference inside `do concurrent`
 Elapsed system clock during double precision concurrent inference:  66.173744
 variable          mean           stdev
 t_dc     42.464405 0.
 t_omp    43.313417 0.
 t_elem   41.631988 0.
 t_dp_dc  66.173744 0.
```
In interpreting these timings, note that Homebrew installs LLVM `flang` without OpenMP support and `flang`'s capability for automatically parallelizing of `do concurrent` did not make it into `flang` version 20, but should appear in `flang` version 21.  Lastly, compilers do not yet parallelize array statements inside OpenMP's `!$omp workshare` blocks.  {cite}`rouson2025automatically` present results with OpenMP support and with automatic parallelization of `do concurrent` enabled.

[Fig. 2](aerosol-viz) visualizes predictions of the accumulation-mode aerosol concentration made by the aerosol model that we used with the `infer-aerosol` demonstration application.  The visualization is produced by software unrelated to Fiats and is provided for purposes of understanding the model data the model produces.
```{figure} ../assets/ncvis_output_0104_a1.png
:name: aerosol-viz
:align: center

A global view of the concentration of accumulation-mode aerosol particles as predicted by the model used in this section of the notebook.
```




# Methods
## Getting started
With the `tree` utility installed, the following `bash` shell commands will download the Fiats repository, checkout the `git` commit used in writing this notebook, and show the Fiats directory tree:
```bash
git clone --branch sea-iss-2025 git@github.com:berkeleylab/fiats 
cd fiats
tree -d
.
├── demo
│   ├── app
│   ├── include -> ../include
│   ├── src
│   └── test
├── doc
│   └── uml
├── example
│   └── supporting-modules
├── include
├── scripts
├── src
│   └── fiats
└── test
```
where the `src` directory contains the source comprising the Fiats library that programs link against to access the Fiats library's data entities and procedures.  As such, `src` contains the only files that a Fiats user needs, and it contains no main programs.  The `fiats_m` `module`in `src/fiats_m.f90` exposes all user-facing Fiats functions, subroutines, derived types, and constants.  The `src/fiats` subdirectory contains the definitions of everything in `fiats_m` as well as private internal implementation details.  For a program to access Fiats entities, it would suffice for a `use fiats_m` statement to appear in any program unit or subprogram that requires Fiats.

Apart from the library, the Fiats `git` repository contains main programs that demonstrate how to use Fiats.  The main programs are in two subdirectories: 
1. `example/` contains relatively short and mostly self-contained programs and
2. `demo/app/` contains demonstration applications developed with collaborators for production use.
The next two subsections describe the demonstration applications.  Using the demonstration applications requires several problem-specific files and prerequisite software packages.  Using `train-cloud-microphysics` also requires considerable resources in the form of thousands of core-hours of ICAR runs to produce hundreds of gigabytes of data.  To give the reader a gentler introduction to using Fiats, the [Discussion](#discussion) section describes how to use the example programs only.

## Demonstration application: aerosol inference
The `demo/app/infer-aerosol.f90` program demonstrates the use of Fiats to predict aerosol variables for E<sup>3</sup>SM.  The following statement provides access to all Fiats entities employed by the program:
```fortran
   use fiats_m, only : unmapped_network_t, tensor_t, double_precision, double_precision_file_t
```
where the `unmapped_network_t` derived type encapsulates a neural network that performs no mappings on input and output tensors, `tensor_t` encapsulates network input and output tensors, `double_precision` is a kind type parameter that specifies the desired precision, and the `double_precision_file_t` derived type provides a file abstraction that determines how numerical values in model files will be interpreted.  Because Fiats focuses on surrogate models that must be compact in order to be competitive with the physics-based models they replace, Fiats uses a JSON file format for its human readability because we have found the ability to inspect network parameters visually helpful in the early stages of experimenting with new algorithms.  Users with models trained in PyTorch can use the Fiats companion network export software [Nexport](https://github.com/berkeleylab/nexport) to export models to the Fiats JSON format.

After chores such as printing usage information if a user omits a required command-line argument, the following object declaration demonstrates the first direct use of Fiats in the program: 
```fortran
   type(unmapped_network_t(double_precision)) neural_network
```
Fiats uses derived type parameters -- specifically kind type parameters -- so that one neural-network type can be used to declare objects with any supported `kind` parameter.  Currently, the supported `kind` parameters are `default_real` and `double_precision`, corresponding to the chosen compiler's `real` (with no specified `kind` parameter) and `double precision` types.  Fiats types with a kind type parameter provide a default initialization of the parameter to `default_real`.  

A later line defines the object:
```fortran
   neural_network = unmapped_network_t(double_precision_file_t(path // network_file_name))
```
where `unmapped_network_t` appears in this context as a generic interface patterned after Fortran's structure constructors that define new objects.  Because the JSON specification does not differentiate types of numbers (e.g., JSON does not distinguish integers from real numbers), using the Fiats `double_precision_file_t` type specifies how to interpret values read from the model file.

Similarly, the later line:
```fortran
   type(tensor_t(double_precision)), allocatable :: inputs(:), outputs(:)
```
specifies the precision used for tensor objects, and the `tensor_t` generic interface in the following statement:
```fortran
   inputs(i) = tensor_t(input_components(i,:))
```
resolves to an invocation of a function that produces a double-precision object because of a declaration earlier in the code (not shown here) that declares `input_components` to be of type `double precision`.  Ultimately, inference happens by invoking a type-bound `infer` procedure on the `neural_network` object and providing `tensor_t` input objects to produce the corresponding `tensor_t` output objects:
```fortran
   !$omp parallel do shared(inputs,outputs,icc)
   do i = 1,icc
     outputs(i) = neural_network%infer(inputs(i))
   end do
   !$omp end parallel do
```
where we parallelize the loop using OpenMP directives.  Alternatively, the Fiats `example/concurrent-inferences.F90` program invokes `infer` inside a `do concurrent` construct, taking advantage of `infer` being `pure`.  This approach has the advantage that compilers can automatically parallelize the iterations without OpenMP directives.  Besides simplifying the code, switching to `do concurrent` means the exact same source code can run in parallel on a CPU or a GPU without change.  With most compilers, switching from running on one device to another requires simply recompiling with different flags.  See {cite:t}`rouson2025automatically` for more details on automatically parallelizing inference, including strong scaling results on one node of the Perlmutter supercomputer at the National Energy Research Scientific Computing ([NERSC](https://www.nersc.gov)) Center.

The remainder of `infer-aerosol` contains problem-specific statements not directly related to the use of Fiats and is therefore beyond the scope of this notebook.

## Demonstration application: microphysics training
Training a neural network is an inherently more involved process than using a neural network for inference.  As such, `train-cloud-microphysics` uses a larger number of Fiats entities:
```fortran
use fiats_m, only : tensor_t, trainable_network_t, input_output_pair_t, mini_batch_t, &
    tensor_map_t, training_configuration_t, training_data_files_t, shuffle
```
where only the `tensor_t` type intersects with the set of entities that `infer-aerosols` uses.  The remaining entities in the above `use` statement all relate to training neural networks.

The `trainable_network_t` type extends the `neural_network_t` type and thus offers the same type-bound procedures by inheritance. 
Outwardly, `trainable_network_t` differs from `neural_network_t` only in that `trainable_network_t` provides public `train` and `map_to_training_ranges` generic bindings that `neural_network_t` lacks.  Calling `train` performs a forward pass followed by a back-propagation pass that adjusts the neural-network weights and biases.  If the network input and output ranges for training differ from the corresponding tensor values for the application (e.g., we often find it useful to map input tensor values to the unit interval [0,1] for training), then calling `map_to_training_ranges` performs the desired transformation and the resulting `tensor_map_t` type encapsulates the forward and inverse mappings.  Privately, the `trainable_network_t` type stores a `workspace_t` object containing a training scratchpad that gets dynamically sized in a way that is invisible to Fiats users.  Hiding this implementation detail without forcing the `neural_network_t` type to have components needed only for training is the primary reason that `trainable_network_t` exists.

The `input_output_pair_t` derived type encapsulates training-data pairings ensuring a one-to-one connection between `tensor_t` inputs and outputs as required for supervised learning {cite}`goodfellow2016deep`.  The `mini_batch_t` type supports the formation of `input_output_pair_t` subgroups. The ability to form mini-batches and to randomly shuffle the composition of mini-batches via the listed `shuffle` subroutine combine to facilitate the implementation of the foundational stochastic gradient descent optimization algorithm for training.

Finally, the `training_configuration_t` and `training_data_files_t` types encapsulate file formats that Fiats users employ to define training hyperparameters (e.g., learning rate) and to specify the collection of files that contain training data.  With all of the aforementioned derived types in place, `train-cloud-microphysics` uses a capability of the external Julienne framework {cite}`julienne` to group the training data into bins:
```fortran
   bins = [(bin_t(num_items=num_pairs, num_bins=n_bins, bin_number=b), b = 1, n_bins)]
```
and then these bins are shuffled into new mini-batch subsets at the beginning of each epoch:

```fortran
do epoch = first_epoch, last_epoch

  if (size(bins)>1) call shuffle(input_output_pairs) ! set up for stochastic gradient descent
    mini_batches = [(mini_batch_t(input_output_pairs(bins(b)%first():bins(b)%last())), b = 1, size(bins))]

    call trainable_network%train(mini_batches, cost, adam, learning_rate)
```
where `cost` is an `intent(out)` variable containing the cost function calculated at the end of an epoch; `adam`
is a `logical` `intent(in)` variable that switches on the Adam optimizer {cite}`kingma2017adam`; and `learning_rate` is an `intent(in)` variable that scales the adjustments to the model weights and biases. This completes the presentation of essential Fiats capabilities employed by `train-cloud-microphysics`.



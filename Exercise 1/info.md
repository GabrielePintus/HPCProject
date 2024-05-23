# Info for Exercise 1


## Distribution algorithms

The following algorithms are available for the distribution of data in MPI.

### Broadcast

`MCA coll tuned: parameter "coll_tuned_bcast_algorithm"`
- Current value: "ignore" 
- Data source: default 
- Level: 5 tuner/detail 
- Type: int
- Description: Which bcast algorithm is used. Can be locked down to choice of: 
  - 0 ignore
  - 1 basic linear
  - 2 chain
  - 3 pipeline
  - 4 split binary tree
  - 5 binary tree
  - 6 binomial tree
  - 7 knomial tree
  - 8 scatter_allgather
  - 9 scatter_allgather_ring



`MCA coll tuned: parameter "coll_tuned_scatter_algorithm"`
- Current value: "ignore"
- Data source: default
- Level: 5 tuner/detail
- Type: int
- Description: Which scatter algorithm is used. Can be locked down to choice of: 
  - 0 ignore
  - 1 basic linear
  - 2 binomial
  - 3 non-blocking linear


Which scatter algorithm is used. Can be locked down to choice of: 0 ignore, 1 basic linear, 2 binomial, 3 non-blocking linear. Only relevant if coll_tuned_use_dynamic_rules is true.
                          Valid values: 0:"ignore", 1:"basic_linear", 2:"binomial", 3:"linear_nb"


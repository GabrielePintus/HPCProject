import subprocess
from itertools import product
from datetime import datetime
from time import sleep


class Combinations:
    '''
    This class takes a dictionary of parameters and generates all possible combinations of them.
    @params: dictionary of parameters
    '''
    
    def __init__(self, params):
        self.params = params

    def make_combinations(self):
        yield from product(*self.params.values())

    def make_combinations_dicts(self):
        yield from (dict(zip(self.params.keys(), values)) for values in self.make_combinations())
            
    def __iter__(self):
        return self.make_combinations_dicts()
    
    @staticmethod
    def compute_length(params):
        length = 0
        for key in params:
            length += len(params[key])
        return length

    
    

class Run:
    '''
    This class takes a command and runs it.
    '''
    
    def __init__(
        self,
        operation = 'osu_bcast',
        warmup = 10,
        iterations = 1000
    ):
        '''
            Inside of params there should be the following keys:
            - operation: the name of the executable
            - warmup: the number of warmup iterations
            - iterations: the number of total iterations
        '''
        self.operation = operation
        self.warmup = warmup
        self.iterations = iterations
        self.command = f"mpirun ./{operation} --warmup {warmup} --iterations {iterations} --full"

    def run(self):
        process = subprocess.Popen(self.command, shell=True, stdout=subprocess.PIPE)
        process.wait()
        stdout, stderr = process.communicate()
        return stdout, stderr
    
    def __call__(self):
        return self.run()
    
    def __str__(self):
        return f"operation: {self.operation} | warmup: {self.warmup} | iterations: {self.iterations}"
    
    # Make a generator of runs from a combinations object
    @staticmethod
    def make_runs(self, combinations):
        for combination in combinations:
            yield Run(**combination)
    

    


if __name__ == '__main__':
    STORAGE = '/home/alejandro/Projects/mpi_benchmarks'
    DELAY = 0.01
    
    # Define the parameters
    params = {
        'param1': [1, 2, 3],
        'param2': ['a', 'b', 'c'],
        'param3': [True, False]
    }
    
    # Generate all possible combinations and runs
    comb = Combinations(params)
    runs = Run.make_runs(comb)
    
    # Determine the total number of runs to be executed
    total_runs = Combinations.compute_length(params)
    counter = 0
    
    # delay of 10 milliseconds
    sleep(DELAY)
    
    # Execute all runs
    for run in runs:
        # Create log file name and metadata
        current_time = datetime.now().strftime("%Y%m%d_%H%M%S")
        filename = f"{run}_{current_time}.log"
        metadata = str(run)
        
        # Run the command
        stdout, stderr = run()
        
        # delay of 10 milliseconds
        sleep(DELAY)
        
        # Write the log file
        with open(filename, 'w') as f:
            f.write(metadata + '\n')
            f.write("---| STDOUT |---\n")
            f.write(stdout.decode('utf-8') + '\n')
            f.write("---| STDERR |---\n")
            f.write(stderr.decode('utf-8') + '\n')
        print(f"Log file {filename} created.")
        
        # Print progress
        counter += 1
        print(f"{counter}/{total_runs} runs completed.")
        
        # delay of 10 milliseconds
        sleep(DELAY)
        
    print("All runs completed!")
        
        

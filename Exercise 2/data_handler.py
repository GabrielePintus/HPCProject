import pandas
import numpy
from tabulate import tabulate
import matplotlib.pyplot as plt


class DataHandler:
    
    @staticmethod
    def _parse_filename(file_path):
        filename = file_path.split('/')[-1]
        parts = filename.split('_')
        scaling_type = parts[1]
        scaling_framework = parts[2]
        n_processes = int(parts[3].split('.')[0])
        return filename, scaling_type, scaling_framework, n_processes
    
    @staticmethod
    def _parse_header(file_path):
        # read first three lines of file
        with open(file_path, 'r') as f:
            header = [next(f) for x in range(3)]
        # Second line contains width, height and max_iter
        splitted = header[1].split()
        width = int(splitted[1].replace(',', ''))
        height = int(splitted[3].replace(',', ''))
        max_iter = int(splitted[-1])
        # Third line contains x_min, y_min, x_max, y_max
        splitted = header[2].split()
        x_min = float(splitted[1].replace(',', ''))
        y_min = float(splitted[3].replace(',', ''))
        x_max = float(splitted[5].replace(',', ''))
        y_max = float(splitted[7])
        
        return width, height, max_iter, x_min, y_min, x_max, y_max
    
    @staticmethod
    def _read_data(file_path):
        lines = []
        with open(file_path, 'r') as f:
            for line in f:
                if line[:7] == 'Process':
                    lines.append(line.strip())
        return lines
    
    def _parse_data(self, lines):
        dataset = []
        entire_comp_time = dict()
        for line in lines:
            splitted = line.split(':')
            proc = int(splitted[0].replace('Process ', ''))
            if splitted[1].strip()[:6] == 'Entire':
                entire_comp_time[proc] = float(splitted[2].strip())
            else:
                comp_time = float(splitted[2].strip())
                dataset.append([proc, comp_time])
        return dataset, entire_comp_time
    
    def __init__(self, file_path):
        self.file_path = file_path
        
        filename_parsed = DataHandler._parse_filename(file_path)
        self.filename = filename_parsed[0]
        self.scaling_type = filename_parsed[1]
        self.scaling_framework = filename_parsed[2]
        self.n_processes = filename_parsed[3]
        
        header_parsed = DataHandler._parse_header(file_path)
        self.width = header_parsed[0]
        self.height = header_parsed[1]
        self.max_iter = header_parsed[2]
        self.x_min = header_parsed[3]
        self.y_min = header_parsed[4]
        self.x_max = header_parsed[5]
        self.y_max = header_parsed[6]
        
        file_data = DataHandler._read_data(file_path)
        file_data_parsed = DataHandler._parse_data(self, file_data)
        self.dataframe = pandas.DataFrame(file_data_parsed[0], columns=['proc', 'comp_time'])
        self.entire_comp_time = file_data_parsed[1]
        
        # Sort entire_comp_time by key
        self.entire_comp_time = dict(sorted(self.entire_comp_time.items()))
        
    def duration(self):
        return max(self.entire_comp_time.values())
        
        
    def __str__(self):
        table = [
            ['Filename', self.filename],
            ['Scaling type', self.scaling_type],
            ['Scaling framework', self.scaling_framework],
            ['Number of processes', self.n_processes],
            ['Width', self.width],
            ['Height', self.height],
            ['Max iterations', self.max_iter],
            ['x_min', self.x_min],
            ['y_min', self.y_min],
            ['x_max', self.x_max],
            ['y_max', self.y_max],
            ['Entire computation time', self.duration()]
        ]
        return tabulate(table, tablefmt='grid')
    
    def plot(self):
        # barplot with process number on x-axis and computation time on y-axis
        fig, ax = plt.subplots()
        ax.bar(self.entire_comp_time.keys(), self.entire_comp_time.values())
        ax.set_xlabel('Process number')
        ax.set_ylabel('Computation time (s)')
        ax.set_title('Computation time per process')
        return fig
    
    def hist(self):
        # histogram of computation time
        fig, ax = plt.subplots()
        ax.hist(self.dataframe['comp_time'])
        ax.set_xlabel('Computation time (s)')
        ax.set_ylabel('Frequency')
        ax.set_title('Histogram of computation time')
        return fig
        
        
        
if __name__ == '__main__':
    file_path = 'data/THIN/Strong Scaling/MPI/4096x4096/mandelbrot_strong_mpi_96.log'
    dh = DataHandler(file_path)
    print(dh)

    hist = dh.plot()
    plt.show()


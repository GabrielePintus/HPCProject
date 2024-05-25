import pandas
import numpy
import matplotlib.pyplot as plt
import os



class DataHandler:
    
    @staticmethod
    def from_file(file_path):
        if 'bcast' in file_path:
            return BroadcastDataHandler(file_path)
        elif 'scat' in file_path:
            return ScatterDataHandler(file_path)
        else:
            return DataHandler(file_path)
    
    @staticmethod
    def _load_data(file_path):
        lines = []
        for line in open(file_path):
            l = line.strip().split(' ')
            if l:
                lines.append([ x for x in l if x])
        header = lines[:4]
        for i in range(4):
            header[i] = ' '.join(header[i])
        body = lines[4:]
                
        return header, body
    
    def __init__(self, file_path):
        self.file_path  = file_path
        self.filename   = file_path.split('/')[-1]
        self.operation  = self.filename.split('_')[0]
        
        self.header, data = DataHandler._load_data(file_path)
        try:
            self.data = pandas.DataFrame(
                data,
                columns=['Size', 'Avg Latency (us)', 'Min Latency (us)', 'Max Latency (us)', 'Iterations', 'P50 Tail Lat(us)', 'P90 Tail Lat(us)', 'P99 Tail Lat(us)'],
                dtype=numpy.float64
            )
        except Exception as e:
            # For latency data
            self.data = pandas.DataFrame(
                data,
                columns=['Size', 'Latency (us)', 'P50 Tail Lat(us)', 'P90 Tail Lat(us)', 'P99 Tail Lat(us)'],
                dtype=numpy.float64
            )
        try:
            self.data.rename(columns={'Latency (us)': 'Avg Latency (us)'}, inplace=True)
        except Exception:
            pass
        self.data['Size'] = self.data['Size'].astype(numpy.int64)
        self.data.set_index('Size', inplace=True)
        
    def __str__(self):
        string = f'File: {self.filename}\n'
        string += f'Operation: {self.operation}\n'
        string += f'Entity: {self.entity}\n'
        string += f'Algorithm: {self.algorithm}\n'
        string += f'Number of Processes: {self.n_proc}\n'
        string += self.data['Avg Latency (us)'].to_string()
        return string
    
    def time(self, size):
        return self.data[self.data.index==size]['Avg Latency (us)'].values
        
    def save(self, file_path):
        header = '\n'.join(self.header)
        body = self.data.to_string(header=False, index=True)
        file_text = header + '\n' + body
        with open(file_path, 'wt') as f:
            f.write(file_text)


class BroadcastDataHandler(DataHandler):
    
    def __init__(self, file_path):
        super().__init__(file_path)
        self.entity     = self.filename.split('_')[1]
        self.n_proc     = int(self.filename.split('_')[2])
        self.algorithm  = int(self.filename.split('_')[3].replace('.csv', ''))
        
        
class ScatterDataHandler(DataHandler):
    
    def __init__(self, file_path):
        super().__init__(file_path)
        self.entity     = self.filename.split('_')[1]
        self.n_proc     = int(self.filename.split('_')[2])
        self.algorithm  = int(self.filename.split('_')[3].replace('.csv', ''))


class LatencyDataHandler(DataHandler):
    
    
    def __init__(self, file_path):
        super().__init__(file_path)
        self.file_path      = file_path
        self.filename       = file_path.split('/')[-1]
        self.entity         = self.filename.split('_')[1]
        self.ranking_code   = self.filename.split('_')[2].replace('.csv', '')
        self.operation = 'latency'
        self.algorithm = 'none'
        self.n_proc         = 2
        if self.entity == 'cluster':
            self.nodes   = [self.ranking_code[0]] + [self.ranking_code[3]]
            self.sockets = [self.ranking_code[1]] + [self.ranking_code[4]]
            self.cores   = [self.ranking_code[2]] + [self.ranking_code[5]]
        elif self.entity == 'node':
            self.nodes   = [0,0]
            self.sockets = [self.ranking_code[0]] + [self.ranking_code[2]]
            self.cores   = [self.ranking_code[1]]
            if len(self.ranking_code) == 5:
                self.cores.append(self.ranking_code[-2:])
            else:
                self.cores.append(self.ranking_code[-1])
        elif self.entity == 'socket':
            self.nodes   = [0,0]
            self.sockets = [0] + [0]
            self.cores   = [0] + [self.ranking_code[0]]
            
        
        
    def __str__(self):
        string = f'File: {self.filename}\n'
        string += f'Operation: {self.operation}\n'
        string += f'Entity: {self.entity}\n'
        # string += f'Algorithm: {self.algorithm}\n'
        # string += f'Number of Processes: {self.n_proc}\n'
        string += f'Nodes: {self.nodes}\n'
        string += f'Sockets: {self.sockets}\n'
        string += f'Cores: {self.cores}\n'
        string += self.data['Avg Latency (us)'].to_string()
        return string        



if __name__ == '__main__':
    
    dh_bcast = []
    dh_scat = []
    
    for file in os.listdir('output_data/broadcast'):
        if file.endswith('.csv'):
            dh_bcast.append(DataHandler.from_file(f'output_data/broadcast/{file}'))
    for file in os.listdir('output_data/scatter'):
        if file.endswith('.csv'):
            dh_scat.append(DataHandler.from_file(f'output_data/scatter/{file}'))
    
    
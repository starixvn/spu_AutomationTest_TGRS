import csv, types
from collections import defaultdict

def read_csv_file(filename, header=False):
        data = []
        with open(filename) as f:
                reader = csv.reader(f, skipinitialspace=True)
                for row in reader: data.append(row)
                if not header: del data[0]
                return data

def count_csv_rows(filename, header=False):
        return len(read_csv_file(filename, header))

def count_csv_cols(filename):
        return len(read_csv_file(filename)[0])

def get_csv_header_set(filename):
        return read_csv_file(filename, True)[0]

def get_csv_cell_value_by_position(filename, column, row):
        data = read_csv_file(filename, False)
        if int(column) < 1 or int(column) > len(data[0]): raise Exception('Column index must between 1 and %d' % len(data[0]))
        if int(row) < 1 or int(row) > len(data): raise Exception('Row index must between 1 and %d' % len(data))
        return data[int(row)-1][int(column)-1]

def read_csv_file_dict(filename):
        with open(filename) as f:
                reader = csv.reader(f, skipinitialspace=True)
                header = next(reader)
                data = [dict(zip(header, map(str, row))) for row in reader]
                return data

def write_csv_file_dict(filename, listDict, column_order=None):
        if column_order is not None:
                if not isinstance(column_order, list):
                        raise Exception('Column Order list is not a list.')
                keys = column_order
                for dict in listDict:
                        keys_to_remove = [key for key, value in dict.iteritems() if key not in column_order]
                        for key in keys_to_remove:
                                del dict[key]
        else:
                keys = listDict[0].keys()
        with open(filename, 'wb') as output:
                dict_writer = csv.DictWriter(output, keys)
                dict_writer.writeheader()
                dict_writer.writerows(listDict)

def get_csv_column(filename, column):
        data = defaultdict(list)

        with open(filename) as csvfile:
                reader = csv.DictReader(csvfile)
                for row in reader:
                        for k, v in row.items():
                                data[str(k)].append(str(v))
        return data[column]

def lookup_csv_value(filename, lookupKey, lookupVal, returnKey, index=1):
        with open(filename) as f:
                reader = csv.reader(f, skipinitialspace=True)
                header = next(reader)
                listDict = [dict(zip(header, map(str, row))) for row in reader]

        count = 0
        if index < 1: index = 1

        for d in listDict:
                if d[lookupKey] == lookupVal:
                        count = count + 1
                if count >= int(index):
                        return d[returnKey]
        return None

def remove_csv_row_by_value(filename, lookupKey, lookupVal, returnKey, index=1):
        with open(filename) as f:
                reader = csv.reader(f, skipinitialspace=True)
                header = next(reader)
                listDict = [dict(zip(header, map(str, row))) for row in reader]

        count = 0
        if index < 1: index = 1
        
        for d in listDict:
                if d[lookupKey] == lookupVal:
                        count = count + 1
                if count >= int(index):
                        del listDict[d]
        
        keys = listDict[0].keys()
        with open(filename, 'wb') as output:
                dict_writer = csv.DictWriter(output, keys)
                dict_writer.writeheader()
                dict_writer.writerows(listDict)

def lookup_csv_list(filename, lookupKey, lookupVal, returnKey):
        mylist = []
        with open(filename) as f:
                reader = csv.reader(f, skipinitialspace=True)
                header = next(reader)
                data = [dict(zip(header, map(str, row))) for row in reader]
        
        if isinstance(lookupVal, list):
                ival = self._remove_duplicates(lookupVal)
                for sRow in data:
                        for val in ival:
                                if sRow[lookupKey] == val: mylist.append(sRow[returnKey])
        else:
                for sRow in data:
                        if sRow[lookupKey] == lookupVal: mylist.append(sRow[returnKey])
        return mylist

def lookup_csv_row(filename, lookupKey, lookupVal, index=1):
        with open(filename) as f:
                reader = csv.reader(f, skipinitialspace=True)
                header = next(reader)
                listDict = [dict(zip(header, map(str, row))) for row in reader]
        
        count = 0
        if index < 1: index = 1
        
        for d in listDict:
                if d[lookupKey] == lookupVal:
                        count = count + 1
                if count >= int(index):
                        return d
        
        return None

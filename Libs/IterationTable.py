#!/usr/bin/python
# encoding: utf-8

from robot.libraries.BuiltIn import BuiltIn
from numpy import *
from decimal import Decimal
import datetime
import types
import copy
import numbers
import csv
import ast


class IterationTable(object):
    '''
        Class to support data analysing from table (2 dimentions list)
    '''

    def __init__(self):
        self._original_header = None
        self._original_data = None
        self._header = None
        self._row_alias = {}
        self._filters = {}
        self._filter_cols = []
        self._filtered_data = None
        self._filtered_data_dicts = None

    def _validate_r(self, row, isFiltered=True):
        r = int(row) - 1
        if r < 0: raise Exception('Wrong index, row must start from 1')
        if isFiltered:
            if r >= len(self._filtered_data): raise Exception('Wrong index, max rows are %d' % len(self._filtered_data))
        else:
            if r >= len(self._original_data): raise Exception('Wrong index, max rows are %d' % len(self._original_data))
        return r

    def _validate_c(self, col):
        c = int(col) - 1
        if c < 0: raise Exception('Wrong index, column must start from 1')
        if c > len(self._header): raise Exception('Wrong index, max columns are %d' % len(self._header))
        return c

    def _select_iteration_table(self, data, cscord, rscord, cecord, record):
        cs = 1 if cscord is None else int(cscord)
        rs = 1 if rscord is None else int(rscord)
        re = len(data) if record is None else int(record) - rs + 1
        ce = len(data[0]) if cecord is None else int(cecord) - cs + 1

        iData = array(data)
        iData = delete(iData, s_[:rs - 1], 0)  # Cut header
        iData = delete(iData, s_[:cs - 1], 1)  # Cut left
        iData = delete(iData, s_[re:], 0)  # Cut footer
        iData = delete(iData, s_[ce:], 1)  # Cut right
        return iData.tolist()

    def _apply_filter(self):
        tmpHeader = copy.copy(self._original_header)
        tmpData = array(self._original_data)
        ## Filter rows
        if self._filters:
            tmpDelList = {}
            for ir, row in enumerate(tmpData):
                delFlag = False
                for key in self._filters.keys():
                    if key != 'table-alias':
                        if row[self.column_index(self, key) - 1] not in self._list_in(self._filters.get(key)): delFlag = True
                    else:
                        if ir + 1 not in self._row_alias.get(self._filters.get(key)): delFlag = True
                tmpDelList.update({ir: delFlag})
            tmpData = delete(tmpData, [k for k, v in tmpDelList.items() if v], 0)

        ## Filter cols
        if self._filter_cols:
            tmpDelList = []
            for col_name in self._original_header:
                if col_name not in self._filter_cols:
                    tmpDelList.append(self._original_header.index(col_name))
            for i in sorted(tmpDelList, reverse=True):
                del tmpHeader[i]
            tmpData = delete(tmpData, tmpDelList, 1)

        ## Apply result to object properties
        self._header = tmpHeader
        self._filtered_data = tmpData.tolist()
        self._filtered_data_dicts = [dict(zip(tmpHeader, row)) for row in tmpData]

    def _list_in(self, obj):
        if type(obj) == tuple:
            return list(obj)
        elif type(obj) != list:
            return [obj]
        return obj

    def _list_out(self, obj):
        if type(obj) == tuple:
            return list(obj)[0] if len(obj) == 1 else list(obj)
        elif type(obj) == list:
            return obj[0] if len(obj) == 1 else obj
        return obj

    def _get_eval(self, eval_string, module=None):
        return BuiltIn().evaluate(str(eval_string), module)

    def _parse_eval(self, val):
        if type(val) == types.UnicodeType: return val.replace('''\n''', ' ').encode('ascii', 'ignore')
        if type(val) == types.StringType: return val.replace('''\n''', ' ')
        if type(val) == types.LongType: return str(val)
        if type(val) == types.IntType: return int(val)
        if type(val) == types.FloatType: return float(val)
        if type(val) == types.BooleanType: return bool(val)
        if type(val) == types.NoneType:
            return ''
        else:
            return val

    def _val_data_in(self, data):
        return data

    def _val_data_out(self, data):
        iData = array(data)
        iData[:] = vectorize(self._parse_eval)(iData)
        return iData.tolist()

    ###################### Init methods ##############################

    def parse_inter_table_from_2dlist(self, data, isHeaderFirst=True):
        '''
        Parse a two dimensional list to inter table format object\n
        Set isHeaderFirst as False if 2darray list not already have header as first row
        '''
        new_iTable = IterationTable()
        if isHeaderFirst:
            new_iTable._original_header = data[0]
            new_iTable._original_data = self._val_data_in(data[1:])
        else:
            new_iTable._original_header = arange(array([len(i) for i in data]).max())
            new_iTable._original_data = self._val_data_in(data[:])
        new_iTable._apply_filter()
        return new_iTable

    def parse_inter_table_from_listdict(self, listdict):
        '''
        Parse a list dictionary to inter table format object
        '''
        iData = [listdict[0].keys()] + [d.values() for d in listdict]
        return self.parse_inter_table_from_2dlist(iData, True)

    def parse_inter_table_with_cordinate(self, data, isHeaderFirst=True, cscord=None, rscord=None, cecord=None, record=None):
        '''
        Parse a two dimensional list (with header at first row) to inter table format object.\n
        Use coordinate of first and last row/column to crop data
        '''
        iData = self._select_iteration_table(data, cscord, rscord, cecord, record)
        return self.parse_inter_table_from_2dlist(iData, isHeaderFirst)

    def parse_inter_table_from_csv(self, filepath):
        '''
        Parse a csv file to inter table format object
        '''
        iData = []
        with open(filepath) as f:
            reader = csv.reader(f, skipinitialspace=True)
            for row in reader:
                iData.append(row)
        return self.parse_inter_table_from_2dlist(iData, True)

    def parse_inter_table_from_eval_result(self, eval_string, isHeaderFirst=True, module=None):
        '''
        Parse an evaluation expression result (which returns a two dimensional list or a list dict) to inter table format object.\n
        The eval expression and module param using is similar to method evaluate of robotframework
        '''
        try:
            iData = self._get_eval(eval_string, module)
            if type(iData[0]) == dict:
                return self.parse_inter_table_from_listdict(iData, True)
            elif type(iData[0]) in (list, tuple):
                return self.parse_inter_table_from_2dlist(iData, isHeaderFirst)
        except TypeError as e:
            raise Exception(
                'Wrong type of input detected. Must be a list dict or a two dimensional list\nFound error: %s' % e)

    ###################### Compare methods ##############################

    def compare_iterTable_by_row(self, iterTableA_, iterTableB_, caseSensitive=True):
        '''
        Compare two iterTable if they are equal or not\n
        Return None if no differences found
        '''
        iter1 = array(iterTableA_._filtered_data) if caseSensitive else array(vectorize(lambda x: x.lower())(iterTableA_._filtered_data))
        iter2 = array(iterTableB_._filtered_data) if caseSensitive else array(vectorize(lambda x: x.lower())(iterTableB_._filtered_data))

        tmpDiff = []
        for ir, row in enumerate(iter1):
            r1 = array(iter1[ir])
            r2 = array(iter2[ir])
            if not array_equal(r1, r2):
                tmpDiff.append('Row1: %s' % dict(zip(iterTableA_._header, r1.tolist())))
                tmpDiff.append('Row2: %s' % dict(zip(iterTableB_._header, r2.tolist())))
        if tmpDiff:
            print('Found differences and returned')
            return tmpDiff
        return None

    ###################### Sort methods ##############################

    def rearrange_columns(self, iterTable_, *column_name):
        '''
        Rearrange the column list of the current table by expected order specified in params\n
        Note: No need to provide full column list
        '''
        index = [iterTable_.column_index(iterTable_, col) - 1 for col in column_name]
        for i in range(len(iterTable_._header)):
            if i not in index: index.append(i)
        iterTable_._header = [x for _, x in sorted(zip(index, iterTable_._header))]
        iterTable_._filtered_data = array(iterTable_._filtered_data)[:, argsort(index)].tolist()

    def sort_by_column(self, iterTable_, column_name):
        '''
        Perform sort data by indicated column name
        '''
        index = iterTable_.column_index(iterTable_, column_name) - 1
        iData = array(self._val_data_out(iterTable_._filtered_data))
        iterTable_._filtered_data = iData[iData[:, index].argsort()].tolist()

    ###################### Statistic methods ##############################

    def count_rows(self, iterTable_, isDistinct=False):
        '''
        Returns the number of rows
        '''
        print('Count rows of interTable object %s' % iterTable_)
        return len(iterTable_._filtered_data) if not isDistinct else len(list(set(iterTable_._filtered_data)))

    def count_columns(self, iterTable_, isDistinct=False):
        '''
        Returns the number of columns
        '''
        print('Count colums of interTable object %s' % iterTable_)
        return len(iterTable_._header) if not isDistinct else len(list(set(iterTable_._header)))

    def column_index(self, iterTable_, column_name):
        '''
        Return colummn index by name
        '''
        if iterTable_._header.index(column_name) < 0: raise Exception('Could not find column %d in iterTable' % column_name)
        return iterTable_._header.index(column_name) + 1

    def sum_if(self, iterTable_, search_column, sum_column, *keyword):
        '''
        Perform sum all values in a column which satisfy the conditions. Use name for search column and sum column\n
        Keyword can be a list, tuple or single value
        '''
        tmpResult = sum(map(float, self.search_list_by_keyword(iterTable_, search_column, sum_column, *keyword)))
        return tmpResult if int(tmpResult) != tmpResult else int(tmpResult)

    def count_if(self, iterTable_, search_column, sum_column, *keyword):
        '''
        Perform count all values in a column which satisfy the conditions. Use name for search column and sum column\n
        Keyword can be a list, tuple or single value
        '''
        return len(self.search_list_by_keyword(iterTable_, search_column, sum_column, *keyword))

    def average_if(self, iterTable_, search_column, sum_column, *keyword):
        '''
        Perform average calculate for all values in a column which satisfy the conditions. Use name for search column and sum column\n
        Keyword can be a list, tuple or single value
        '''
        tmpData = map(float, self.search_list_by_keyword(iterTable_, search_column, sum_column, *keyword))
        tmpResult = sum(tmpData) / len(tmpData)
        return tmpResult if int(tmpResult) != tmpResult else int(tmpResult)

    def min_value(self, iterTable_, search_column):
        '''
        Return min value of input column. Note: min condition to compare depends on datatype of column
        '''
        return min(self._val_data_out(self.get_column_by_name(iterTable_, search_column, False)))

    def max_value(self, iterTable_, search_column):
        '''
        Return max value of input column. Note: min condition to compare depends on datatype of column
        '''
        return max(self._val_data_out(self.get_column_by_name(iterTable_, search_column, False)))

    ###################### Get data methods ##############################

    def get_headers(self, iterTable_):
        '''
        Returns the list of headers
        '''
        return iterTable_._header

    def set_headers(self, iterTable_, *header):
        '''
        Apply names to all headers in iterTable\n
        The list must have same number of headers as the number of cols. Order of headers should follow order of columns
        Note: This action will clean up all current iterTable filters and sorting
        '''
        iHeader = self._list_in(*header)
        if len(iHeader) != len(iterTable_._original_header):
            raise Exception('Header list does not match number of iterTable columns amount')
        iterTable_._original_header = iHeader
        iterTable_._filters = {}
        iterTable_._filter_cols = []
        iterTable_._apply_filter()

    def get_cell_value_by_position(self, iterTable_, column_index, row_index):
        '''
        Returns the value of the cell indicated by number of column and row index. Start by 1
        '''
        return iterTable_._filtered_data[iterTable_._validate_r(row_index)][iterTable_._validate_r(column_index)]

    def set_cell_value_by_position(self, iterTable_, column_index, row_index, new_value):
        '''
        Set the value of the cell indicated by number of column and row index. Start by 1
        '''
        iterTable_._original_data[iterTable_._validate_r(row_index)][iterTable_._validate_r(column_index)] = new_value
        iterTable_._apply_filter()

    def set_column_name(self, iterTable_, column_name, new_column_name):
        '''
        Update a column name to a new name
        '''
        if column_name in (iterTable_._original_header):
            iterTable_._original_header[iterTable_._original_header.index(column_name)] = new_column_name
        if column_name in (iterTable_._header):
            iterTable_._header[iterTable_._header.index(column_name)] = new_column_name
        if column_name in (iterTable_._filter_cols):
            iterTable_._filter_cols[iterTable_._filter_cols.index(column_name)] = new_column_name
        if column_name in (iterTable_._filters.keys()):
            iterTable_._filters[new_column_name] = iterTable_._filters.pop(column_name)
        iterTable_._filtered_data_dicts = [dict(zip(iterTable_._header, row)) for row in iterTable_._filtered_data]

    def get_cell_value_by_name(self, iterTable_, column_name, row_index):
        '''
        Returns the value of the cell indicated by name of column and row index. Start by 1
        '''
        return iterTable_._filtered_data[iterTable_._validate_r(row_index)][iterTable_._validate_r(self.column_index(iterTable_, column_name))]

    def get_row(self, iterTable_, index, rtype='dict'):
        '''
        Returns the row by row index. Start by 1\n
        rtype as list or dict for data type return
        '''
        if rtype not in ('list', 'dict'): raise Exception('Not supported input name %s' % rtype)
        result = iterTable_._filtered_data[iterTable_._validate_r(index)]
        if rtype == 'list':
            return result
        return dict(zip(iterTable_._header, result))

    def get_column_by_index(self, iterTable_, column, isDistinct=False):
        '''
        Return a full column by index
        '''
        data = array(iterTable_._filtered_data)[:, iterTable_._validate_c(column)].tolist()
        return self._list_out(data) if not isDistinct else self._list_out(list(set(data)))

    def get_column_by_name(self, iterTable_, column_name, isDistinct=False):
        '''
        Return a full column by column name
        '''
        return self.get_column_by_index(iterTable_, self.column_index(iterTable_, column_name), isDistinct)

    def get_current_filters(self, iterTable_):
        '''
        Return the current list of filters
        '''
        return iterTable_._filters

    def get_current_filtered_result(self, iterTable_):
        '''
        Return the current filtered result
        '''
        return iterTable_._filtered_data

    def get_full_table_content(self, iterTable_):
        '''
        Return the full content of iterTable (without filters)
        '''
        return iterTable_._original_data

    ###################### Filters methods ##############################

    def add_filter(self, iterTable_, column_name, *by_value):
        '''
        Filter the current iterTable by a value in specific column. Return filtered result after adding\n
        Note: column name must be unique in filter list. If add an existing column, it will be updated with new value\n
        Keyword can be a list, tuple or single value
        '''
        print('Add filter to interTable %s with option %s = %s' % (iterTable_, column_name, str(by_value)))
        iterTable_._filters.update({column_name: by_value})
        iterTable_._apply_filter()
        return iterTable_._filtered_data

    def remove_filter(self, iterTable_, column_name):
        '''
        Remove a filter from current filter results. Return filtered result after removing
        '''
        print('Remove filter %s from interTable %s' % (column_name, iterTable_))
        if column_name not in iterTable_._filters.keys():
            raise Exception('Could not find filter %s in iterTable' % column_name)
        del iterTable_._filters[column_name]
        iterTable_._apply_filter()
        return iterTable_._filtered_data

    def clear_all_filters(self, iterTable_):
        '''
        Remove all current filters from interTable
        '''
        print('Remove all filters from interTable %s' % iterTable_)
        iterTable_._filters.clear()
        iterTable_._apply_filter()

    def set_row_alias(self, iterTable_, alias, *row_index):
        '''
        Define a unique alias for a row or a set of row index (base on row index without column filtering). Row_index starts by 1\n
        Unique alias can be used as row alias for data analysing
        Notes: Alias address will not be changed if apply column filtering
        '''
        iterTable_._row_alias.update({alias: [iterTable_._validate_r(i, False) + 1 for i in row_index]})

    def get_row_alias(self, iterTable_):
        '''
        Return current list of row alias applied
        '''
        return iterTable_._row_alias

    def add_filter_by_alias(self, iterTable_, *alias):
        '''
        Filter the current iterTable by alias
        Note: Keyword can be a list, tuple or single value
        '''
        print('Add alias filter %s to interTable %s' % (alias, iterTable_))
        for i in alias:
            if i not in iterTable_._row_alias.keys():
                raise Exception('Could not find alias %s in iterTable' % alias)
            iterTable_._filters.update({'table-alias': i})
        iterTable_._apply_filter()
        return iterTable_._filtered_data

    def add_filter_column(self, iterTable_, *column_name):
        '''
        Filter table by expected column or list of columns. Table will only show with filtered column(s)\n
        Keyword can be a list, tuple or single value
        '''
        if not self._list_in(column_name):
            raise Exception('Missing column name argument')
        for i in self._list_in(column_name):
            if i not in iterTable_._header:
                raise Exception('Could not find %s in header list' % i)
            iterTable_._filter_cols.append(i)
        iterTable_._apply_filter()
        return iterTable_._filtered_data

    def remove_filter_column(self, iterTable_, *column_name):
        '''
        Exclude a column or a list of columns from current filtered columns list\n
        Keyword can be a list, tuple or single value
        '''
        if not self._list_in(column_name):
            raise Exception('Missing column name argument')
        for i in self._list_in(column_name):
            if i not in iterTable_._filter_cols:
                raise Exception('Could not find %s in hiding list' % i)
            if i not in iterTable_._original_header:
                raise Exception('Could not find %s in header list' % i)
            iterTable_._filter_cols.remove(i)
        iterTable_._apply_filter()
        return iterTable_._filtered_data

    def reset_filter_column(self, iterTable_):
        '''
        Reset column filter to original state (no filtering)
        '''
        iterTable_._filter_cols.clear()
        iterTable_._apply_filter()
        return iterTable_._filtered_data

    ###################### Search methods ##############################

    def search_row_by_keyword(self, iterTable_, column_nameA, keyword, index=1):
        '''
        Perform search in column A with a keyword and return equipvalent row if match\n
        Return single row with index. Keyword can be a list, tuple or single value
        '''
        count = 0
        if index < 1: index = 1

        for d in iterTable_._filtered_data_dicts:
            if d[column_nameA] in self._list_in(keyword):
                count = count + 1
            if count >= int(index):
                return d
        return None

    def search_value_by_keyword(self, iterTable_, column_nameA, column_nameB, keyword, index=1):
        '''
        Perform search in column A with a keyword and return equipvalent value in column B if match\n
        Return single value with index. Keyword can be a list, tuple or single value
        '''
        return self.search_row_by_keyword(iterTable_, column_nameA, keyword, index).get(column_nameB)

    def search_list_by_keyword(self, iterTable_, column_nameA, column_nameB, *keyword):
        '''
        Perform search in column A with a keyword and return list of equipvalent values in column B if match\n
        Keyword can be a list, tuple or single value
        '''
        tmpResult = []
        for d in iterTable_._filtered_data_dicts:
            if d[column_nameA] in self._list_in(keyword):
                tmpResult.append(d[column_nameB])
        return tmpResult

    ###################### Print methods ##############################

    def print_iterTable(self, iterTable_, colList=None, indent=0):
        '''
        Pretty print iTerTable data (with filter if any)
        '''
        ichar = ''
        for i in range(0, int(indent)): ichar = ichar + ' '

        myData = [iterTable_._header] + self._val_data_out(iterTable_._filtered_data)
        colSize = map(max, zip(*[[len(str(cell)) for cell in row] for row in myData]))
        formatStr = ' | '.join(["{{:<{}}}".format(i) for i in colSize])
        myData.insert(1, ['-' * i for i in colSize])
        print 'Itertable printing result:'
        for item in myData: print(ichar + formatStr.format(*item))

    def print_iterTable_obj_detail(self, iterTable_):
        '''
        Print iTerTable object attributes
        '''
        print('Header: %s' % iterTable_._header)
        print('Filters: %s' % iterTable_._filters)
        print('Alias: %s' % iterTable_._row_alias)
        print('Filtered Data:')
        for ir, row in enumerate(iterTable_._filtered_data):
            print('Row %s: %s' % (ir + 1, row))
        print('Filtered Dict:')
        for ir, row in enumerate(iterTable_._filtered_data_dicts):
            print('Row %s: %s' % (ir + 1, row))
        print('Data:')
        for ir, row in enumerate(iterTable_._original_data):
            print('Row %s: %s' % (ir + 1, row))

    def print_iterTable_to_csv(self, iterTable_, filepath, delimiter=','):
        '''
        Print iTerTable data to a csv file
        '''
        with open(filepath, 'wb') as output:
            dict_writer = csv.DictWriter(output, iterTable_._header, delimiter=delimiter)
            dict_writer.writeheader()
            dict_writer.writerows(iterTable_._filtered_data_dicts)

import xlrd
from decimal import Decimal
from openpyxl import load_workbook
from openpyxl import __version__ as openpyxl_ver
from openpyxl.utils import get_column_letter
from openpyxl.styles import colors
import os.path
import glob


# import numpy as np


class ExcelExtendLibrary(object):
    '''
        Extended excel Library for Robot-Framework. Can run standalone or using in pair with external ExcelLibrary of robot-framework
            Require:
                - xlrd (Excel .xls file support library) #https://pypi.python.org/pypi/xlrd
                - openpyxl (Excel .xlsx file support library) #https://openpyxl.readthedocs.io/en/default/

            Install from cmd:
                pip install xlrd
                pip install openpyxl
    '''

    # Private functions
    # def _read(self, f, r=True): return load_workbook(filename=f, read_only=r)
    # def _sheet(self, f, s, r=True): return self._read(f, r)[str(s)]
    # def _data(self, file, sheet): return [[self._parse(x.value) for x in row] for row in self._sheet(file, sheet).rows]

    def _read(self, f, r=False):
        if self._isXls(f):
            return xlrd.open_workbook(f)
        else:
            return load_workbook(filename=f, read_only=r)

    def _sheet(self, f, s):
        path = os.path.realpath(f)
        files = glob.glob(path) if not os.path.exists(path) else [path]
        if not len(files):
            raise Exception('Could not locate excel file: %s' % f)
        sheets = self._read(files[0])
        version = float(openpyxl_ver[:openpyxl_ver.find('.', openpyxl_ver.find('.') + 1)])
        if self._isXls(files[0]):
            return sheets.sheet_by_name(s)
        else:
            if float(openpyxl_ver[:openpyxl_ver.find('.', openpyxl_ver.find('.') + 1)]) < 2.5:
                return sheets.get_sheet_by_name(s)
            else:
                return sheets[s]

    def _data(self, f, s):
        if self._isXls(f):
            data = self._sheet(f, s)
            return [[self._parse(data.cell_value(r, c)) for c in range(data.ncols)] for r in range(data.nrows)]
        else:
            return [[self._parse(x.value) for x in row] for row in self._sheet(f, s).rows]

    def _isXls(self, f):
        return True if f[-4:].lower() == '.xls' else False

    def _float(self, s):
        return float(str(s)) if self._isfloat(s) else s

    def _isstr(self, s):
        return True if isinstance(s, basestring) or isinstance(s, unicode) else False

    def _format(self, s):
        return str(s).replace('u', '').replace('\'', '')

    def _rgb_to_hex(self, rgb):
        return '#%02x%02x%02x' % rgb

    def _validate_index(self, i):
        try:
            if int(i) < 1:
                raise Exception('Wrong index number provided. Should >= 1')
            else:
                return int(i)
        except:
            raise Exception('Wrong index number provided. Should >= 1')

    def _parse(self, s):
        try:
            if isinstance(s, float):
                return str(s).rstrip('0').rstrip('.')
            elif isinstance(s, int):
                return int(s)
            elif isinstance(s, complex):
                return str(s)
            elif isinstance(s, str):
                return str(s)
            elif isinstance(s, unicode):
                return s
            else:
                return s
        except ValueError as err:
            raise Exception(err)

    def _list_to_dict(self, data, header):
        return [dict(zip(header, map(str, row))) for row in data]

    # Public function
    def get_sheet_content(self, file, sheet):
        '''
            Return a two dimensions list (or a list of dictionaries) which represent the content of a sheet.\n
        '''
        return self._data(file, sheet)

    def count_sheet_rows(self, file, sheet):
        '''
            Return the number of rows from an excel spreadsheet
        '''
        return len(self._data(file, sheet))

    def count_sheet_columns(self, file, sheet):
        '''
            Return the number of columns from an excel spreadsheet
        '''
        return len(self._data(file, sheet)[0])

    def get_row_by_index(self, file, sheet, rowIndex=1):
        '''
            Return a list which represent data of a row by it's index in the sheet.\n
        '''
        for index, row in enumerate(self._data(file, sheet)):
            if index + 1 == self._validate_index(rowIndex): return row

    def get_row_by_reference(self, file, sheet, refValue, index=1):
        '''
            Return a row in list format which match the search condition by index.\n
            The index parameter represent the order of row in case multiple rows have found match the expectation
            The index starts at 1
        '''
        result = []
        for rn, row in enumerate(self._data(file, sheet)):
            for cn, cell in enumerate(row):
                if cell == refValue: result.append(row)
        if self._validate_index(index) <= len(result) and len(result) > 0:
            return result[self._validate_index(index) - 1]

        return None

    def get_cell_color(self, file, sheet, row, column):
        '''
            Return the colour code of the expected cell by row, column address
            @Parameters: excel path & file name | sheet name | row index (start by 1) | column index (start by 1)
        '''
        try:
            path = os.path.realpath(file)
            file = glob.glob(path)[0] if not os.path.exists(path) else [path]
            if self._isXls(file[0]):
                wb = xlrd.open_workbook(file[0], formatting_info=True)
                s = wb.sheet_by_name(sheet)
                xf = wb.xf_list[s.cell_xf_index(self._validate_index(row) - 1, self._validate_index(column) - 1)]
                bgx = xf.background.pattern_colour_index
                return self._rgb_to_hex(wb.colour_map[bgx])
            else:
                wb = load_workbook(filename=file[0], read_only=True)
                ws = wb[sheet]
                column_letter = get_column_letter(int(column))
                color_i = colors.COLOR_INDEX[ws[column_letter + str(row)].fill.start_color.index]
                return "#" + color_i[2:]
        except ValueError as err:
            raise Exception(err)

    def get_column_data_by_index(self, file, sheet, columnIndex, startRow):
        '''
            Return a column data value by the index of column in the excel file.\n
            The index starts at 1
        '''
        if self._isXls(file):
            return self._sheet(file, sheet).col_values(self._validate_index(columnIndex) - 1)
        else:
            sheet = self._sheet(file, sheet)
            range = sheet.get_squared_range(self._validate_index(columnIndex), self._validate_index(startRow),
                                            self._validate_index(columnIndex), sheet.max_row)
            return [[self._parse(x.value) for x in row][0] for row in range]

    def get_cell_value_by_index(self, file, sheet, rowIndex, columnIndex):
        '''
            Return a cell value by the index of row and column in the excel file.\n
            The index starts at 1
        '''
        return self._data(file, sheet)[self._validate_index(rowIndex) - 1][self._validate_index(columnIndex) - 1]

    def get_cell_value_by_coordinate(self, file, sheet, coordinate):
        '''
            Return a cell value by the coordinate (row, col) in the excel file.\n
        '''
        return self._data(file, sheet)[self._validate_index(coordinate[0]) - 1][self._validate_index(coordinate[1]) - 1]

    def get_column_index(self, file, sheet, value, index=1):
        '''
            Return the column address of the cell has value input.\n
            The index parameter represent the order of column in case multiple addresses have found. I.e index = 2 means return the column address of 2nd searched result
            Return None when no cell value found matching the expected index
        '''
        try:
            return self.get_cell_coordinate(file, sheet, value, index)[1]
        except:
            return None

    def get_row_index(self, file, sheet, value, index=1):
        '''
            Return the row address of the cell has value input.\n
            The index parameter represent the order of row in case multiple addresses have found. I.e index = 2 means return the row address of 2nd searched result
            Return None when no cell value found matching the expected index
        '''
        try:
            return self.get_cell_coordinate(file, sheet, value, index)[0]
        except:
            return None

    def get_cell_coordinate(self, file, sheet, value, index=1):
        '''
            Return the row, column address of the cell has value input in a tube type.\n
            The index parameter represent the order of address in case multiple addresses have found. I.e index = 2 means return the address of 2nd searched result
            Return None when no cell value found matching the expected index
        '''
        if self._validate_index(index) < 1: index = 1
        count = 0

        try:
            for ri, row in enumerate(self._data(file, sheet)):
                for ci, cell in enumerate(row):
                    if isinstance(cell, str): cell = cell.strip()
                    if cell == value:
                        count = count + 1
                    if count >= int(index):
                        return ri + 1, ci + 1
            return None
        except:
            return None

    def compare_sheet(self, fileA, sheetA_name, fileB, sheetB_name, isCaseSensitive=True, isShow=False, stopAtDifference=True):
        '''
            Return True or False for 2 sheets if they are same or not.
            Set isShow = True to print out the list to compare.
            Set stopAtDifference = True if exists right after the first difference found
        '''

        flag = True
        dA = self._data(fileA, sheetA_name)
        dB = self._data(fileB, sheetB_name)
        isCaseSensitive = True if str(isCaseSensitive).lower() in ("yes", "true", "1") or isCaseSensitive == True else False
        isShow = True if str(isShow).lower() in ("yes", "true", "1") or isShow == True else False
        stopAtDifference = True if str(stopAtDifference).lower() in ("yes", "true", "1") or stopAtDifference == True else False

        if len(dA) != len(dB) or len(dA[0]) != len(dB[0]): return False
        for row in range(0, len(dA)):
            for col in range(0, len(dA[0])):
                aVal = dA[row][col] or ''
                bVal = dB[row][col] or ''
                if isCaseSensitive == False:
                    if self._isstr(aVal): aVal = aVal.lower()
                    if self._isstr(bVal): bVal = bVal.lower()
                if aVal != bVal: flag = False
                if isShow:
                    if flag:
                        print("Compare cell value %d,%d: %s = %s" % (row + 1, col + 1, aVal, bVal))
                    else:
                        print("Compare cell value %d,%d: %s != %s" % (row + 1, col + 1, aVal, bVal))
                if stopAtDifference:
                    if flag == False: return flag

        return flag

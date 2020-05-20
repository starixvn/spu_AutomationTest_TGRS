#!/usr/bin/python
# encoding: utf-8

import pymssql
import csv
import types
import xlwt
import os, sys
import datetime
import numbers
from xlsxwriter import Workbook as wb
from xlsxwriter.format import Format as fm
from collections import defaultdict
from robot.api import logger
from decimal import Decimal

class DBLibrary(object):
	'''
		Database Library for Robot-Framework
			Prequisite:
				- xlsxwriter (Excel file library) #http://xlsxwriter.readthedocs.io/index.html
				- pymssql 2.1.1 (Microsoft SQL Server API library) #http://www.pymssql.org/en/latest/ref/pymssql.html
				- xlwt (Excel .xls file support library) #https://pypi.python.org/pypi/xlwt
				
			Install from cmd:
				pip install pymssql==2.1.1
				pip install xlsxwriter
				pip install xlwt
	'''
	
	def __init__(self): self._dbconnection = None	#Database connection
	
	def _isfloat(self, s):
		try:
                        if isinstance(s, numbers.Number):
                                if str(s).find('.') > 0:
                                        return True # For float
                                else:
                                        return False # For int
                        else:
                                return False
		except ValueError: return False
		
	def _fi(self, s):
                if isinstance(s, bool):
                        return bool(s)
                elif isinstance(s, datetime.datetime):
                        return str(s)
                elif isinstance(s, (types.LongType)):
                        return str(s).rstrip('L')
                elif isinstance(s, Decimal):
                        return float(s)
                elif isinstance(s, int):
                        return int(s)
                elif self._isfloat(s):
                        return str(s).rstrip('0').rstrip('.') if '.' in str(s) else str(s) #Remove float suffix
                elif isinstance(s, unicode):
                        return s.encode('utf-8', 'ignore')
                elif isinstance(s, basestring):
                        return str(s)
                elif isinstance(s, type(None)):
                        return None
                else:
                        return s

        def _build_dataset(self, DBcursor):
                '''
                        Build the data set as list dict for each table returned after a sql run
                '''

                resultset = []
		while True:
                        try:
                                rows = DBcursor.fetchall()
                                resultset.append([dict(zip([column[0] for column in DBcursor.description], map(self._fi, row))) for row in rows])
                        except pymssql.OperationalError as error:
                                break
                        if DBcursor.nextset() is None:
                                break
                return None if len(resultset) == 0 else resultset
                
	def connect_to_database(self, dbServer, dbUser, dbPass, dbDatabase, dbPort=1433, dbQTimeout=0, dbLoginTimeout=60, charSet='UTF-8'):
		'''
			Connect to database. Must be called before calling any query actions.
		'''
		try:
			self._dbconnection = pymssql.connect(server=dbServer, user=dbUser, password=dbPass, database=dbDatabase, port=int(dbPort), timeout=int(dbQTimeout), login_timeout=int(dbLoginTimeout), charset=charSet, as_dict=False)
			return self._dbconnection
		except Exception as e: logger.error(e)
	
	def read_cfFile_connectionString(self, filename):
		dict = {}
		f = open(filename)
		for lines in f:
			items = lines.split('=', 1)
			dict[items[0]]=items[1].rstrip('\n')
		return dict
	
	def connect_to_database_by_cfFile(self, filename):
		'''
			Connect to database. Must be called before calling any query actions.
			Format:
				dbServer=@value\n
				dbPort=@value\n
				dbUser=@value\n
				dbPassword=@value\n
				dbDataBase=@value\n
				dbQueryTimeout=0\n
				dbLoginTimeout=60\n
		'''
		dict = self.read_cfFile_connectionString(filename)
		return self.connect_to_database(dict.get('dbServer'), dict.get('dbUser'), dict.get('dbPassword'), dict.get('dbDataBase'), dict.get('dbPort'), dict.get('dbQueryTimeout'), dict.get('dbLoginTimeout'))
	
	def disconnect_from_database(self):
		'''Disconnect from current database connection. Should be called after finishing all query actions'''
		self._dbconnection.close()
	
	def execute_proc_with_result(self, sp_name, output_path=None, output_type=None, *param):
		'''
			Execute a stored procedure with parameters list in a tube. Export all result tables into output folder path as csv, xls or xlsx
		'''

		result = False
		cResoult = 1

		cur = self._dbconnection.cursor()
		cur.callproc(str(sp_name), param)
		if output_path is not None and str(output_path).lower() != 'none' and os.path.isdir(str(output_path)):
			if str(output_type).lower() not in ('csv', 'xls', 'xlsx'): raise Exception('Wrong file type specified. Must be csv, xls or xlsx')
			result = cur.nextset()
		
		while result:
			fileStr = output_path + sp_name + '_' + str(cResoult) + '.' + output_type
			rows = cur.fetchall()
			try:
				if output_type == 'csv':
					with open(fileStr, "wb") as outfile:
						writer = csv.writer(outfile)
						writer.writerow([column[0] for column in cur.description])	#Write header column
						for row in rows: writer.writerow([self._fi(s) for s in row])
						
				elif output_type == 'xls':
					workbook = xlwt.Workbook()
					sheet = workbook.add_sheet('Sheet1')
					format = xlwt.easyxf('font: bold 1')	
					for i, val in enumerate([column[0] for column in cur.description]): sheet.write(0, i, self._fi(val), format)	#Write header column
					for r, row in enumerate(rows):
						for c, s in enumerate(row): sheet.write(r+1, c, self._fi(s)) # Write table data
					if os.path.exists(fileStr): os.remove(fileStr)
					workbook.save(fileStr)
					
				else:
					workbook = wb(fileStr)
					sheet = workbook.add_worksheet('Sheet1')
					format = workbook.add_format({'bold': True})
					for i, val in enumerate([column[0] for column in cur.description]): sheet.write(0, i, self._fi(val), format)	#Write header column
					for r, row in enumerate(rows):
						for c, s in enumerate(row): sheet.write(r+1, c, self._fi(s)) # Write table data
					workbook.close()
					
			except Exception as e:
                                raise e
			finally:			   
				## Loop for next result set
				cResoult = cResoult + 1
				result = cur.nextset()
				
		self._dbconnection.commit()
		return cur

	def execute_proc(self, sp_name, *param):
		'''
			Execute a stored procedure with parameters list in a tube
		'''
		cur = self.execute_proc_with_result(sp_name, None, None, *param)
		result = self._build_dataset(cur)
                self._dbconnection.commit()
                return result

	def execute_proc_dict(self, sp_name, param):
		'''
			Execute a stored procedure with parameters list in a dictionary
			Sample:
				params = {'@param1'='1', '@param2'='20', '@param3'='test'}\n
				execute_proc_dict	sp_a	params\n
				>>> sql run: exec sp_a @param1=1, @param2=20, @param3='test'
		'''
		params = ', '.join("@%s=%s" % (key.strip('@'),val.strip('@')) for (key,val) in param.iteritems())
		sql = "exec " + sp_name + " " + params
		
		cur = self._dbconnection.cursor()
		cur.execute(sql + ';')
		result = self._build_dataset(cur)
                self._dbconnection.commit()
                return result
		
	def execute_sql(self, sql):
		'''
			Execute a sql command. Return a dict of table if the sql script returns
		'''
		cur = self._dbconnection.cursor()
		cur.execute(sql + ';')
		result = self._build_dataset(cur)
                self._dbconnection.commit()
                return result

        def execute_sql_file(self, filepath):
                '''
                        Execute a sql file with input filepath/filename.sql. Use with awareness of your own safety
                '''
                with open(filepath, 'r') as f:
                        sql = f.read() # Don't do that with untrusted inputs
                cur = self._dbconnection.cursor()
                cur.execute(sql + ';')
                result = self._build_dataset(cur)
                self._dbconnection.commit()
                return result
	
	def get_query_result_csv(self, sql, csvFile, header='True'):
		'''
			Build a csv file from result set of the sql command \n
			Example: get query result csv		select * from customer		test.csv
		'''
		
		cur = self._dbconnection.cursor()
		cur.execute(sql + ';')
		rows = cur.fetchall()
		
		with open(csvFile, "wb") as outfile:
			writer = csv.writer(outfile)
			if header.lower() == 'true': writer.writerow([column[0] for column in cur.description])	#Write header column
			for row in rows: writer.writerow([self._fi(s) for s in row])
		
	def format_list_to_string(self, obj, ttype='Number'):
		'''
			Return a string from a list with sql formated. Useful for IN condition
		'''
                if type(obj) in (list, tuple):
                        return ','.join(str(e) for e in obj) if ttype == 'Number' else ','.join("'%s'" % str(e) for e in obj)
		else:
                        return str(obj) if ttype == 'Number' else "'%s'" % str(obj)

	def get_query_result_xlsx(self, sql, excelFile, sheetName, header='True'):
		'''
			Build an xlsx excel file from result set of the sql command \n
			Example: get query result xlsx		select * from customer		test.xlsx
		'''
		
		cur = self._dbconnection.cursor()
		cur.execute(sql + ';')
		rows = cur.fetchall()

		if excelFile[-5:] == '.xlsx':
			workbook = wb(excelFile)
			sheet = workbook.add_worksheet(sheetName)
			format = workbook.add_format({'bold': True})
			
			if header.lower() == 'true':
				for i, val in enumerate([column[0] for column in cur.description]): sheet.write(0, i, self._fi(val), format)	#Write header column
			for r, row in enumerate(rows):
				for c, s in enumerate(row): sheet.write(r+1, c, self._fi(s)) # Write table data
			workbook.close()
		else: 
			raise Exception('Wrong file extention name. Must be .xlsx')
		
	def get_query_result_xls(self, sql, excelFile, sheetName, header='True'):
		'''
			Build an xls excel file from result set of the sql command \n
			Example: get query result xls		select * from customer	test.xls	Sheet1
		'''
		
		cur = self._dbconnection.cursor()
		cur.execute(sql + ';')
		rows = cur.fetchall()

		if excelFile[-4:] == '.xls':
			workbook = xlwt.Workbook()
			sheet = workbook.add_sheet(sheetName)
			format = xlwt.easyxf('font: bold 1')
			
			
			if header.lower() == 'true':
				for i, val in enumerate([column[0] for column in cur.description]): sheet.write(0, i, self._fi(val), format)	#Write header column
			for r, row in enumerate(rows):
				for c, s in enumerate(row): sheet.write(r+1, c, self._fi(s)) # Write table data
			try:
				if os.path.exists(excelFile): os.remove(excelFile)
				workbook.save(excelFile)
			except: raise Exception('Error saving to file path: ' + excelFile + '. Recheck file if wrong path, no write-permission or file is opening')
		else:
			raise Exception('Wrong file extention name. Must be .xls')
			
	def get_query_result_dict(self, sql):
		'''
			Return a list of dictionary which stands for each row in queried table
		'''
		cur = self._dbconnection.cursor()
		cur.execute(sql + ';')
		rows = cur.fetchall()
		return [dict(zip([column[0] for column in cur.description], map(self._fi, row))) for row in rows]

	def get_query_result_tuple(self, sql):
		'''
			Return a list of tuples which stands for each row in queried table
		'''
		data = []
		cur = self._dbconnection.cursor()
		cur.execute(sql + ';')
		rows = cur.fetchall()
		cols = [column[0] for column in cur.description]

		for row in rows:
			r = []
			for i in range(0, len(cols)-1):
				r.append((cols[i],row[i]))
			data.append(r)
		return data		
		
	def get_query_result_list(self, sql, header=True):
		'''
			Return a list of list which stands for each row in queried table
		'''
		cur = self._dbconnection.cursor()
		cur.execute(sql + ';')
		rows = cur.fetchall()
		
		data = []
		try:
			if header: data.append([column[0] for column in cur.description]) 	#Write header column
			for row in rows: data.append([self._fi(s) for s in row])
			return data
		except Exception as err: raise RuntimeError(err)
		
	def get_query_result(self, sql):
		'''
			Execute then return result data
		'''
		cur = self._dbconnection.cursor()
		cur.execute(sql + ';')
		return cur
		
	def get_column_header(self, cursor):
		'''
			Return column header list of a data result set
		'''		
		return [column[0] for column in cursor.description]
		
	def data_to_dict(self, cursor):
		'''
			Return a list of dictionary which stands for each row in queried table
		'''
		return [dict(zip([column[0] for column in cursor.description], map(self._fi, row))) for row in cursor.fetchall()]
		
	def data_to_tuples(self, cursor):
		'''
			Return a list of tuples which stands for each row in queried table
		'''
		data = []
		cols = [column[0] for column in cursor.description]
		for row in cursor.fetchall():
			r = []
			for i in range(0, len(cols)-1):
				r.append((cols[i],row[i]))
			data.append(r)
		return data	

#!/usr/bin/python
# encoding: utf-8

import time

def wait_until_true(timeout, frequency, wait_func, *args):
    '''
        Params:
         - timeout: int as second
         - frequency: float as second for each loop delay
         - wait_func: func name
         - args: arg array
    '''
    maxtime = time.time() + int(timeout)
    while wait_func(*args) == False:
        if time.time() > maxtime: return False
        time.sleep(frequency)
    return True   

def wait_until_false(timeout, frequency, wait_func, *args):
    '''
        Params:
         - timeout: int as second
         - frequency: float as second for each loop delay
         - wait_func: func name
         - args: arg array
    '''
    maxtime = time.time() + int(timeout)
    while wait_func(*args) == True:
        if time.time() > maxtime: return True
        time.sleep(frequency)
    return False 

def wait_until_equal(timeout, frequency, expectation, wait_func, *args):
    '''
        Params:
         - timeout: int as second
         - frequency: float as second for each loop delay
         - expectation: return value of func to compare
         - wait_func: func name
         - args: arg array
    '''
    maxtime = time.time() + int(timeout)
    while wait_func(*args) != expectation:
        if time.time() > maxtime: return False
        time.sleep(frequency)
    return True  

def wait_until_not_equal(timeout, frequency, expectation, wait_func, *args):
    '''
        Params:
         - timeout: int as second
         - frequency: float as second for each loop delay
         - expectation: return value of func to compare
         - wait_func: func name
         - args: arg array
    '''
    maxtime = time.time() + int(timeout)
    while wait_func(*args) == expectation:
        if time.time() > maxtime: return False
        time.sleep(frequency)
    return True  

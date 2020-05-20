#!/usr/bin/python
# encoding: utf-8

from random import randint

class Math(object):
    '''
        Class to support match and number cal
    '''

    def __init__(self):
        pass

    @staticmethod
    def random(minx, maxx):
        return randint(int(minx), int(maxx))

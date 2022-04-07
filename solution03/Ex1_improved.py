# Exercise 1: Declarativity and Query Execution Strategies

from DB1 import Table
contains = Table('legosets/contains.csv') 
minifigs = Table('legosets/minifigs.csv')

# construct a temporary help data structure containing the pieces per set
pieces_temp = {'671-1': [], '377-1': []}
for c in contains:
    if c['set'] == '671-1':
        pieces_temp['671-1'].append(c['piece'])
    elif c['set'] == '377-1':
        pieces_temp['377-1'].append(c['piece'])

for m in minifigs:
    # check whether each minifigure belongs to either one of the sets AND category 67
    # if so, print the set ID and the minifigure name
    if m['piece'] in pieces_temp['377-1'] and m['cat'] == '67':
        print({ 'set': '377-1', 'name': m['name'] })

    if m['piece'] in pieces_temp['671-1'] and m['cat'] == '67':
        print({ 'set': '671-1', 'name': m['name'] })


# Execution and timing via:
# time python3 -u Ex1_improved.py
# -> run time: 0.94 seconds

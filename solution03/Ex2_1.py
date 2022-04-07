# Exercise 2: Query Optimization through Data Pre-Processing

# Exercise 2.1

from DB1 import Table
contains = Table('legosets/contains.csv') 
minifigs = Table('legosets/minifigs.csv')
bricks = Table('legosets/bricks.csv')

# get the piece IDs of all minifigures
minifigs_piece = [m['piece'] for m in minifigs]
l = []

for c in contains:
    if c['piece'] in minifigs_piece: # check whether the piece is a minifigure
        t = 'm'
    else: # if the piece is not a minifigure, it is a brick
        t = 'b'

    # add the information (dictionary) of the piece to the list
    l.append({'set': c['set'], 'extra': c['extra'], 'color': c['color'], 'piece': c['piece'], 'type': t, 'quantity': c['quantity']})

# construct a Table object from the list of dictionaries and dump it into a CSV file
Table(l).dump('Ex2_contains_type.csv')


# Execution and timing via:
# time python3 -u Ex2_1.py
# -> run time: 24 seconds

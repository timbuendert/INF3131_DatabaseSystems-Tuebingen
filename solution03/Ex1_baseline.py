# Exercise 1: Declarativity and Query Execution Strategies

from DB1 import Table
contains = Table('legosets/contains.csv') 
bricks = Table('legosets/bricks.csv') 
minifigs = Table('legosets/minifigs.csv')

for c in contains:
    for m in minifigs:
        if c['piece'] == m['piece']:
            if (c['set'] == '671-1' or c['set'] == '377-1'):
                if m['cat'] == '67':
                    print({ 'set': c['set'], 'name': m['name'] })


# Execution and timing via:
# time python3 -u Ex1_baseline.py
# -> run time: roughly 105 minutes


# Output:
#{'set': '377-1', 'name': 'Plain White Torso with White Arms, Blue Legs, Black Pigtails Hair'}
#{'set': '377-1', 'name': 'Shell - Classic - Blue Legs, Red Hat (Stickered Torso)'}
#{'set': '377-1', 'name': 'Shell - Classic - Blue Legs, Black Pigtails Hair (Stickered Torso)'}
#{'set': '377-1', 'name': 'Plain White Torso with White Arms, Blue Legs, Red Hat'}
#{'set': '671-1', 'name': 'Shell - Classic - Blue Legs, Red Hat (Stickered Torso)'}
#{'set': '671-1', 'name': 'Plain White Torso with White Arms, Blue Legs, Red Hat'}
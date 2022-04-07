# Exercise 2: Query Optimization through Data Pre-Processing

# Exercise 2.2

# Query execution times (via time python3 -u Ex2_2_3.py):
# baseline query: 4.13 seconds (average across five executions)
# optimized query: 1.20 seconds (average across five executions)

query = 'optimized' # please select either 'baseline' or 'optimized'


if query == "baseline":
    from DB1 import Table
    contains = Table('legosets/contains.csv') 
    minifigs = Table('legosets/minifigs.csv')
    bricks = Table('legosets/bricks.csv')

    weight = 0
    for c in contains:
        if c['set'] == '5610-1':
            for b in bricks:
                if c['piece'] == b['piece']:
                    weight = weight + int(c['quantity']) * float(b['weight'])
            for m in minifigs:
                if c['piece'] == m['piece']:
                    weight = weight + int(c['quantity']) * float(m['weight'])

    print(weight)


if query == "optimized":
    # import package and tables
    from DB1 import Table
    minifigs = Table('legosets/minifigs.csv')
    bricks = Table('legosets/bricks.csv')
    contains_type = Table('Ex2_contains_type.csv')

    # initialize weight
    weight = 0

    # construct a temporary help data structures of the piece types containing the piece ID and the quantity of its occurence in the set 5610-1
    minifigs_list = []
    bricks_list = []
    for c in contains_type:
        if c['set'] == '5610-1' and c['type'] == 'b':
            bricks_list.append({'piece': c['piece'], 'quantity': c['quantity']})
        elif c['set'] == '5610-1':
            minifigs_list.append({'piece': c['piece'], 'quantity': c['quantity']})

    # iterate through minifigs and bricks and check whether the piece is part of the set 5610-1 using the temporary help data structures
    # if it is, the product of quantity and weight is added to the weight
    for m in minifigs:
        if m['piece'] in [c['piece'] for c in minifigs_list]:
            weight = weight + sum([int(c['quantity']) for c in minifigs_list if c['piece']==m['piece']]) * float(m['weight'])

    for b in bricks:
        if b['piece'] in [p['piece'] for p in bricks_list]:
            weight = weight + sum([int(p['quantity']) for p in bricks_list if p['piece']==b['piece']]) * float(b['weight'])

    print(weight)



# Exercise 2.3

# Estimation of work performed by the optimized PyQL query: |contains_type| + |minifigs| + |bricks|

# After optimizing the PyQL query, it is necessary to iterate through contains_type only once to retrieve the information regarding piece and quantity of the set's pieces and store it in temporary data structures corresponding to the types.
# Then, one needs to iterate through both the minifigs and the bricks table only once to check for each piece whether it is present in the respective temporary data structure.
# If so, one can directly add the product of the corresponding weight and quantity to the weight of the overall set.
# The remaining smaller lookups in the temporary data structures are of type O(1) and can therefore be neglected for the purpose of estimating the work performance.

# Additional remarks:
# In case minifigs_list contains only one item, it may be theoretically more efficient to switch the query strategy and instead search for that minifigure by iterating through the minifigs table.
# This is because the query needs, on average, to iterate through half of the table to find the corresponding piece. 
# Hence, if minifigs_list contains two items, the work performed would be on average the same as for our proposed query (2*1/2 = 1 time through minifigs). 
# If minifigs_list contains more than two items, our proposed query ("optimized") is theoretically on average faster (x*1/2 > 1 for x = 3, ...).
# We also implemented this query version (selecting the best strategy based on the number of items in minifigs_list), however, it did not lead to any speed improvements in practice and therefore, we did not include it.
# Of course, the exact same reasoning applies to bricks_list and bricks.

# A further possible improvement could be the concept of parallelization, however, this is not implemented as it is not the focus/purpose of this exercise.

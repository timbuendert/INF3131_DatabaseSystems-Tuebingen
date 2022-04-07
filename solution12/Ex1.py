# Exercise 1: Relational Algebra

from DB1 import *

aircraft = Table('airline/aircraft.csv')
certified = Table('airline/certified.csv')
crew = Table('airline/crew.csv')
flights = Table('airline/flights.csv')
pilots = Table('airline/pilots.csv')

# Exercise 1.1
print('Exercise 1: \n')
q = project(lambda t:{'flno':t['flno'], 'origin':t['from']},
            select(lambda t:t['to'] == 'Berlin', 
                   flights))

for row in q:
  print(row)


# Exercise 1.2
print('\nExercise 2: \n')
q = project(['aid','name'],
            join(lambda t:int(t['distance']) < int(t['cruisingrange']),
                 select(lambda t:t['from'] == 'Bonn' and t['to'] == 'Madras', 
                        flights),
                 aircraft))

for row in q:
  print(row)


# Exercise 1.3
print('\nExercise 3: \n')

q = project(['pid','name'],
            natjoin(pilots,
                    natjoin(certified,
                            project(['aid'],
                                    select(lambda t:t['manufacturer'] == 'Boeing', 
                                           aircraft)))))

for row in q:
  print(row)


# Exercise 1.4
print('\nExercise 4: \n')

q = project(lambda t:{'city':t['from1']},
            join(lambda t:t['to2'] == t['from3'] and t['to3'] == t['from1'], # second and third connection -> round trip
                 project(lambda t:{'from3':t['from'], 'to3':t['to']}, flights), 
                 join(lambda t:t['to1'] == t['from2'], # first connection
                      project(lambda t:{'from2':t['from'], 'to2':t['to']}, flights),
                      project(lambda t:{'from1':t['from'], 'to1':t['to']}, flights))))

for row in q:
  print(row)

# round trip of length 2: Pittsburgh - Madison
# round trip of length 3: Munich - Hamburg - Berlin, Tokyo - Los Angeles - Chicago, Hamburg - Kiel - Bremen
# round trip of length 4: Barcelona - Madrid - Lissabon - Sevilla
# Exercise 3: Non-monotonic Queries in the Relational Algebra

from DB1 import *
from datetime import *

aircraft = Table('airline/aircraft.csv')
certified = Table('airline/certified.csv')
crew = Table('airline/crew.csv')
flights = Table('airline/flights.csv')
pilots = Table('airline/pilots.csv')


# Exercise 3.1

print('Exercise 1: \n')

# pilots who are certified for an aircraft which can pass the flight distance
q1 = project(['pid'],
             join(lambda t:int(t['distance']) < int(t['cruisingrange']),
                  project(['pid', 'cruisingrange'], 
                          natjoin(certified, 
                                  aircraft)),
                  project(['distance'], 
                          select(lambda t:t['flno'] == '970', # '970' = 'LH 970'
                                 flights))))


# flight numbers of flights, which collide with the scheduled flight time of LH 970
q2_1 = project(lambda t:{'flno':t['flno2']},
               join(lambda t:(datetime.fromisoformat(t['departs2']) > datetime.fromisoformat(t['departs']) and (datetime.fromisoformat(t['departs2']) < datetime.fromisoformat(t['arrives']))
                          or (datetime.fromisoformat(t['departs2']) < datetime.fromisoformat(t['departs']) and (datetime.fromisoformat(t['departs']) < datetime.fromisoformat(t['arrives2'])))), 
                    project(['departs', 'arrives'],
                            select(lambda t:t['flno'] == '970', # '970' = 'LH 970'
                                   flights)), 
                    project(lambda t:{'flno2':t['flno'], 'departs2':t['departs'], 'arrives2':t['arrives']}, 
                            flights)))

# pilots which are deployed on of those flights (during the scheduled flight time)
q2_2 = project(['pid', 'name', 'salary'],   
                natjoin(natjoin(pilots, 
                                crew),
                        q2_1))

# pilots who are not yet deployed on another flight during the scheduled flight time
q2 = difference(pilots,
                q2_2)


q = project(['pid','name'],
        natjoin(q1,
                q2))


for row in q:
    print(row)


# Exercise 3.2
print('\nExercise 2: \n')

# select all flights for which there exists flight(s) with a shorter flight distance
q1 = project(['flno','from','to'],  
             join(lambda t:int(t['distance']) > int(t['distance2']),
                  flights,
                  project(lambda t:{'flno2':t['flno'], 'distance2':t['distance']}, 
                          flights)))

# select flight which does not appear in q1 -> it does not have a join partner in q1 (flight with a lower flight distance) -> this is the flight  with shortest flight distance
q = difference(project(['flno','from','to'], 
                        flights),
               q1)

'''
# or more compact using the left antijoin
q = project(['flno','from','to'],
            lantijoin(lambda t:int(t['distance']) > int(t['distance2']),
                      flights,
                      project(lambda t:{'flno2':t['flno'], 'distance2':t['distance']}, 
                              flights)))
'''

for row in q:
  print(row)



########################################################################
# In one query:
'''
# 1.
q = project(['pid','name'],
        natjoin(join(lambda t:int(t['distance']) < int(t['cruisingrange']),
                     project(['pid','name','cruisingrange'], natjoin(project(['pid', 'cruisingrange'], 
                                                                        natjoin(certified, aircraft)), 
                                                                     pilots)),
                     project(['distance'], select(lambda t:t['flno'] == '970', flights))), # '970' = 'LH 970'
                difference(pilots,
                           project(['pid', 'name', 'salary'],
                            natjoin(natjoin(pilots, 
                                            natjoin(crew, flights)),
                                    project(lambda t:{'flno':t['flno2']},
                                            join(lambda t:(datetime.fromisoformat(t['departs2']) > datetime.fromisoformat(t['departs']) and (datetime.fromisoformat(t['arrives2']) < datetime.fromisoformat(t['arrives']))
                                                       or (datetime.fromisoformat(t['departs2']) < datetime.fromisoformat(t['departs']) and (datetime.fromisoformat(t['departs']) < datetime.fromisoformat(t['arrives2'])))), 
                                                    project(['departs', 'arrives'],
                                                            select(lambda t:t['flno'] == '970', flights)),
                                                    project(lambda t:{'flno2':t['flno'], 'departs2':t['departs'], 'arrives2':t['arrives']}, flights)))))))) # '970' = 'LH 970'  

# 2.
q = difference(project(['flno','from','to'], flights),
                project(['flno','from','to'],  
                    join(lambda t:int(t['distance']) > int(t['distance2']),
                        flights,
                        project(lambda t:{'flno2':t['flno'], 'distance2':t['distance']}, flights))))
'''
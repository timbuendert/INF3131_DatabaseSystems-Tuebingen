# Exercise 2: SQL and Relational Algebra

from DB1 import *
from datetime import *

aircraft = Table('airline/aircraft.csv')
certified = Table('airline/certified.csv')
crew = Table('airline/crew.csv')
flights = Table('airline/flights.csv')
pilots = Table('airline/pilots.csv')

# Exercise 2.1

# flights from Basel to Berlin for which a connecting flight to Amsterdam exists
q1 = project(lambda t:{'flno':t['flno2']}, 
             join(lambda t:(datetime.fromisoformat(t['departs']) > datetime.fromisoformat(t['arrives2'])) and (t['to'] == 'Amsterdam') and (t['from'] == t['to2']),
                 flights,
                 project(lambda t:{'flno2':t['flno'], 'from2':t['from'], 'to2':t['to'], 'departs2':t['departs'], 'arrives2':t['arrives']}, 
                         select(lambda t:t['from'] == 'Basel' and t['to'] == 'Berlin', 
                                flights))))

# flights directly from Basel to Amsterdam
q2 = project(['flno'],
             select(lambda t:t['from'] == 'Basel' and t['to'] == 'Amsterdam', 
                    flights))

q = union(q1,
          q2)                                                                      

'''
# In one query:
q = union(project(['flno'],
                  select(lambda t:t['from'] == 'Basel' and t['to'] == 'Amsterdam', 
                         flights)),
          project(lambda t:{'flno':t['flno2']},
                  join(lambda t:(datetime.fromisoformat(t['departs']) > datetime.fromisoformat(t['arrives2'])) and (t['to'] == 'Amsterdam') and (t['from'] == t['to2']),
                        flights,
                        project(lambda t:{'flno2':t['flno'], 'from2':t['from'], 'to2':t['to'], 'departs2':t['departs'], 'arrives2':t['arrives']}, 
                                select(lambda t:t['from'] == 'Basel' and t['to'] == 'Berlin', 
                                       flights)))))
'''

for row in q:
  print(row)
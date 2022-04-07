# Exercise 2: Relational Tavern

from DB1 import *

patrons = Table('data/patrons.csv')
likes = Table('data/likes.csv')
offers = Table('data/offers.csv')


# Exercise 1.1
# π[w](likes) ∪ π[w](offers)       
print('Exercise 1:')
q = union(project(['w'], likes),
          project(['w'], offers))

for row in q:
  print(row)


# Exercise 1.2
# π[w](offers) \ π[w](likes)       
print('\nExercise 2:')
q = difference(project(['w'], offers),
               project(['w'], likes))

for row in q:
  print(row)


# Exercise 1.3
# patrons ÷ (π[t](patrons) ∪ π[t](offers))
print('\nExercise 3:')
q = division(patrons,
             union(project(['t'], 
                           patrons),
                   project(['t'], 
                           offers)))

for row in q:
  print(row)


# Exercise 1.4
# (π[p](patrons) ∪ π[p](likes)) \ π[p](offers ⨝ likes)       
print('\nExercise 4:')

q = difference(union(project(['p'], 
                              patrons),
                     project(['p'], 
                              likes)),
               project(['p'], 
                       natjoin(offers, likes)))

for row in q:
  print(row)


# Exercise 1.5
# π[p](patrons ⨝ (likes ⨝ offers)    
print('\nExercise 5:')

q = project(['p'], 
            natjoin(patrons,
                    natjoin(likes,
                            offers)))

for row in q:
  print(row)


## Tut
q2 = project(['p'], 
            intersect(patrons,
                      project(['p', 't'],
                               natjoin(likes,
                                       offers))))
print()

for row in q2:
  print(row)


# Exercise 1.6
print('\nExercise 6:')
# π[p](patrons) \ π[p](patrons ▷[p = p1, t = t1] π[p1←p, t1←t](likes ⨝ offers))

q1 = project(['p'], patrons)

q2 = project(['p'],
             lantijoin(lambda t:t['p'] == t['p1'] and t['t'] == t['t1'],
                       patrons,
                       project(lambda t:{'p1':t['p'], 't1':t['t']},
                               natjoin(likes,
                                       offers))))

q = difference(q1, q2)

for row in q:
  print(row)


## Tut:
q1 = project(['p'], patrons)

q2 = project(['p'],
             difference(patrons,
                        project(['p', 't'],
                                 natjoin(likes,
                                         offers))))

q = difference(q1, q2)

print()
for row in q:
  print(row)


# Exercise 1.7
# π[p](patrons \ π[p,t]((patrons ⨝ offers) ▷[w = w1, p = p1] π[w1←w, p1←p](likes)))
print('\nExercise 7:')

q1 = project(['p', 't'],
             lantijoin(lambda t:t['w'] == t['w1'] and t['p'] == t['p1'],
                       natjoin(patrons,
                               offers),
                       project(lambda t:{'w1':t['w'], 'p1':t['p']},
                               likes)))

q = project(['p'],
            difference(patrons,
                       q1))

for row in q:
  print(row)


## Tut
alpha = natjoin(likes, offers)
beta = natjoin(patrons, offers)

q = project(['p'],
            difference(project(['p', 't'], beta),
                       project(['p', 't'], difference(beta, alpha))))

print()
for row in q:
  print(row)

# Exercise 1.8
# π[p](patrons) \ π[p]((patrons ⨝ offers) ▷[w = w1, p = p1] π[w1←w, p1←p](likes))
print('\nExercise 8:')

q1 = project(['p'],
             lantijoin(lambda t:t['w'] == t['w1'] and t['p'] == t['p1'],
                       natjoin(patrons,
                               offers),
                       project(lambda t:{'w1':t['w'], 'p1':t['p']},
                               likes)))

q = difference(project(['p'],
                       patrons),
               q1)

for row in q:
  print(row)

## Tut

q = difference(project(['p'],
                       patrons),
               project(['p'],
                       difference(project(['p', 'w'],
                                           beta),
                                  likes)))

print()
for row in q:
  print(row)
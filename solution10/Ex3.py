# Exercise 3: Key Derivation

# implementation of cover algorithm
def cover(alpha, fds): # correct
    X = alpha
    change = 1
    while change == 1:
        change = 0
        for beta in fds:
            if frozenset.issubset(beta, X) and not frozenset.issubset(fds[beta], X):
                X = X.union(fds[beta])
                change = 1
    return X

# implementation of key algorithm to derive one candidate key
## Tut-Rückmeldung: "Unfortunately since your algorithm diverges so much from the pseudocode given in the lecture I can't take the time to figure out where your algorithm is going wrong."
def key_alg(k, u, fds):
    if len(u) == 0:
        return k
    else:
        X = frozenset({})
        for c in u:
            c = frozenset({c})
            u = frozenset(u)
            if not frozenset.issubset(c, cover(k.union(u.difference(c)), fds)):
                X = X.union(key_alg(k.union(c), u.difference(cover(k.union(c), fds)), fds))
            else:
                X = X.union(key_alg(k, u.difference(c), fds))
            return X

####################################

# meta algorithm to determine set of candidate keys
def key(k, u, fds):
    k_all = []
    u_list = perm(list(u))
    for u_l in u_list:
        candidate_key = key_alg(k, u_l, fds)
        if candidate_key not in k_all:
            k_all.append(candidate_key)
    return frozenset(k_all)

# create all possible permutations for the set of column names (u) to be able to derive different candidate keys with the key_alg
def addperm(x,l):
    return [ l[0:i] + [x] + l[i:]  for i in range(len(l)+1) ]

def perm(l):
    if len(l) == 0:
        return [[]]
    return [x for y in perm(l[1:]) for x in addperm(l[0],y) ]
    
####################################


if __name__ == "__main__":

    # test case 1
    instructions = key(frozenset({}), 
                       frozenset({'set', 'step', 'piece', 'color', 'quantity', 'page', 'img', 'width', 'height'}), 
                       {frozenset({'set', 'step', 'piece', 'color'}): frozenset({'quantity'}), frozenset({'set', 'step'}): frozenset({'page', 'img'}), frozenset({'img'}): frozenset({'width', 'height'})})
    print(f"Result for instructions: {instructions}\n")


    # test case 2
    n = 4
    r1_fds = {}
    for i in range(n): # set up FDs
        r1_fds[frozenset({'A'+str(i+1)})] = frozenset({'B'+str(i+1)})
        r1_fds[frozenset({'B'+str(i+1)})] = frozenset({'A'+str(i+1)})

    r1 = key(frozenset({}), 
             frozenset({'A'+str(i+1) for i in range(n)}).union(frozenset({'B'+str(i+1) for i in range(n)})),
             r1_fds)
    print(f"Result for first relation r: {r1}\n")
    # to obtain the result in reasonable time (< 5 seconds), n <= 4


    # test case 3
    r2 = key(frozenset({}), 
             frozenset({'A', 'B', 'C', 'D', 'E'}), 
             {frozenset({'A', 'B'}): frozenset({'E'}), frozenset({'A', 'D'}): frozenset({'B'}), frozenset({'B'}): frozenset({'C'}), frozenset({'C'}): frozenset({'D'})})
    print(f"Result for second relation r: {r2}\n")
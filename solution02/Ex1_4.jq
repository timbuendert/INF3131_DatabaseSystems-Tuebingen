(: Exercise 1.4 :)

let $pokedex := json-doc("data/pokedex.json")

return
    let $n :=
        max(for $pokemon in members($pokedex)
            return count(members($pokemon.next_evolution)))
    return 
        for $pokemon in members($pokedex)
        where count(members($pokemon.next_evolution)) eq $n
        return {"name": $pokemon.name, "evolutions": $n }

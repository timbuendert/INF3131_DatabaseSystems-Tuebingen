(: Exercise 1.1 :)

let $pokedex := json-doc("data/pokedex.json")

return
    for $pokemon in members($pokedex)
    return { "number": $pokemon.num, "name": $pokemon.name }

(: Exercise 1.3 :)

let $pokedex := json-doc("data/pokedex.json")

return
    let $km_hatched:=    
        for $pokemon in members($pokedex) 
        where $pokemon.egg ne "Not in Eggs"
        return double($pokemon.egg)
    return 
        avg($km_hatched)

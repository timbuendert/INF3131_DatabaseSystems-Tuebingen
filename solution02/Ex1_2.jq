(: Exercise 1.2 :)

let $pokedex := json-doc("data/pokedex.json")

return
    for $pokemon in members($pokedex)
    return 
        let $preferred_opponents:=
            for $opp in members($pokedex)

            where count(for $w in members($opp.weaknesses)
                        for $t in members($pokemon.types)
                        where $t eq $w
                        return $w) gt 0
                
            return $opp
        return { "name": $pokemon.name, "opponents": count($preferred_opponents) }


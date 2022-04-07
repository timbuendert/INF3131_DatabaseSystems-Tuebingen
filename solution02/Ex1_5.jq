(: Exercise 1.5 :)

declare function descendant-objects($seq as item*, $pok_num as string) as item*
{
  for $pokemon in members($seq)
  where $pokemon.num eq $pok_num
  return typeswitch ($pokemon.next_evolution)
        case array return { "pokemon" : $pokemon.name, "evolutions": (for $pok in members($pokemon.next_evolution)
                                                                        return descendant-objects($seq, $pok.num))}
        default return { "pokemon" : $pokemon.name, "evolutions": []}
};

let $pokedex := json-doc("data/pokedex.json")
let $pok_number := "060"

return descendant-objects($pokedex, $pok_number)

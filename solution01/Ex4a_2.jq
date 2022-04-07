(: Exercise 4.2 - JSONiq 

Here, two solutions are proposed (longer and short variant) with both variants returning the same solution.
However, due to its compact structure, the shorter variant is preferred and the other one is commented out.

:)

let $tweets := json-doc("data/tweets.json")
let $users := json-doc("data/users.json")

(: Shorter variant: directly accesses tweet.user.screen_name :)

return
    for $tweet in members($tweets)
    where $tweet.user.screen_name eq "Tagblatt"
    return { "User name": $tweet.user.screen_name, "Text": $tweet.text }


(: Longer variant: first retrieves the user.id for "Tagblatt", then filters the tweets for this id and then double-checks by returning the screen_name of the found id  :)

(:
return
    let $tagblatt_id :=
        for $user in members($users)
        where $user.screen_name eq "Tagblatt"
        return $user.id
    return
        for $tweet in members($tweets)
        where $tweet.user.id eq $tagblatt_id
        return { "User name": (for $user in members($users)
                                where $user.id eq $tagblatt_id
                                return $tweet.user.screen_name), 
                "Text": $tweet.text }
:)


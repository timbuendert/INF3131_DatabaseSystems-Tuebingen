(: Exercise 4.5 - JSONiq :)

let $tweets := json-doc("data/tweets.json")
let $users := json-doc("data/users.json")

return
    let $screen_names:=
        for $user in members($users)
        return $user.screen_name 

    for $screen_name in $screen_names
    where empty(for $tweet in members($tweets)
                where $tweet.user.screen_name eq $screen_name
                return $tweet)
    return
        $screen_name

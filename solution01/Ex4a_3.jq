(: Exercise 4.3 - JSONiq :)

let $tweets := json-doc("data/tweets.json")
let $users := json-doc("data/users.json")

return
    for $user in members($users)
    return (let $single_tweets:=
                for $tweet in members($tweets)
                where $user.id = $tweet.user.id
                return $tweet
            return { "User": $user.screen_name, "number of tweets": count($single_tweets)})

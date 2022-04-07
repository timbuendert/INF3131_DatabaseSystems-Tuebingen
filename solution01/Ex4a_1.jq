(: Exercise 4.1 - JSONiq :)

let $tweets := json-doc("data/tweets.json")

return
    for $tweet in members($tweets)
    where $tweet.retweet_count gt 5
    return $tweet.text

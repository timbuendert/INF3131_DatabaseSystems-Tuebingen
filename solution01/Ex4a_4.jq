(: Exercise 4.4 - JSONiq :)

let $tweets := json-doc("data/tweets.json")

return
    for $tweet in members($tweets)
    group by $lang := $tweet.lang
    return { "Language": $lang, "number of tweets": count($tweet) }

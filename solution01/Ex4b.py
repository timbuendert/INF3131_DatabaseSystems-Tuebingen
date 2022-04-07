# Exercise 4 - PyQL
# All of the five subtasks are solved in this file and can be easily selected for execution below. 
# Additionally, both styles of query formulation (list-oriented style and imperative style) 
# discussed in the lecture are implemented to solve the subtasks at hand and both lead to identical results.
# Here, it is important to note that the imperative query style can be arbitrarily complex to evaluate and the list-oriented style may be preferred.
# The corresponding subtask and query style can be selected below.

subtask = 1 # please select one of the subtasks 1-5
style = 'lo' # please select either 'lo' (list-oriented style) or 'ip' (imperative style)

# import the Python module DB1 for reading the csv files
import DB1
tweets = DB1.Table('data/tweets.csv')
users = DB1.Table('data/users.csv')


if subtask == 1:
    print("Subtask 1:")

    if style == 'lo':
        [print(tweet['text']) for tweet in tweets if float(tweet['retweet_count'])>5] # or with "\n".join()

    elif style == 'ip':
        for tweet in tweets:
            if float(tweet['retweet_count']) > 5:
                print(tweet['text'])

    else: 
        print('Please enter a correct style (either \'lc\' or \'ip\').')


elif subtask == 2:
    print("Subtask 2:")

    if style == 'lo':
        [print({'User name': [user['screen_name'] for user in users if user['user_id']==tweet['user_id']][0], 'Text': tweet['text']}) for tweet in tweets if tweet['user_id'] == [user['user_id'] for user in users if user['screen_name']== 'Tagblatt'][0]]
    
    elif style == 'ip':
        for tweet in tweets:
            if tweet['user_id'] == [user['user_id'] for user in users if user['screen_name']=='Tagblatt'][0]:
                print({'User name': [user['screen_name'] for user in users if user['user_id']==tweet['user_id']][0], 'Text': tweet['text']})

    else: 
        print('Please enter a correct style (either \'lc\' or \'ip\').')


elif subtask == 3:
    print("Subtask 3:")

    if style == 'lo':
        [print({'User': user['screen_name'], 'Number of tweets': len([tweet for tweet in tweets if tweet['user_id'] == user['user_id']])}) for user in users]

    elif style == 'ip':
        for user in users:
            num_tweets = 0
            for tweet in tweets:
                if tweet['user_id'] == user['user_id']:
                    num_tweets += 1
            print({'User': user['screen_name'], 'Number of tweets': num_tweets})

    else: 
        print('Please enter a correct style (either \'lc\' or \'ip\').')


elif subtask == 4:
    print("Subtask 4:")

    lang = list(set([tweet['lang'] for tweet in tweets])) # or via DB1.dupe()
    
    if style == 'lo':
        [print({'Language': l, 'Number of tweets': len([tweet for tweet in tweets if tweet['lang'] == l])}) for l in lang]
    
    elif style == 'ip':
        for l in lang:
            num_tweets = 0
            for tweet in tweets:
                if tweet['lang'] == l:
                    num_tweets += 1
            print({'Language': l, 'Number of tweets': num_tweets})

    else: 
        print('Please enter a correct style (either \'lc\' or \'ip\').')


elif subtask == 5:
    print("Subtask 5:")

    if style == 'lo':
        [print(user['screen_name']) for user in users if len([tweet for tweet in tweets if tweet['user_id'] == user['user_id']]) == 0]

    elif style == 'ip':
        for user in users:
            num_tweets = 0
            for tweet in tweets:
                if tweet['user_id'] == user['user_id']:
                    num_tweets += 1
            if num_tweets == 0:
                print(user['screen_name'])

    else: 
        print('Please enter a correct style (either \'lo\' or \'ip\').')

else:
    print("Please provide a correct subtask number (between 1 and 5).")

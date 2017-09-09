# urbit-slack
Slack integration talkbot (based on the example in [urbit by doing](https://github.com/Fang-/Urbit-By-Doing))

![demo](https://github.com/asssaf/urbit-slack/raw/master/talkbot.png "bot demo")

## Usage
1. Create an app in slack, you'll need the URL for the next step.

2. Start the talkbot
```
> |start %talkbot
```

3. Join a channel
```
> :talkbot [%join our ~.sandbox]
```

  Optionally, map the station to a slack channel:
  ```
  > :talkbot [%channel [our ~.sandbox] `'#urbit-sandbox']
  ```

4. Configure the slack integration  
Replace the URL below with the slack webhook
```
:talkbot [%slack [~ "https://hooks.slack.com/services/XXXX/XXXX/XXXX"]
```

### Disable integration
```
> :talkbot [%slack ~]
> :talkbot [%leave our ~.sandbox]
```

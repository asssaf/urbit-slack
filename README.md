# urbit-slack
Slack integration talkbot (based on the example in [urbit by doing](https://github.com/Fang-/Urbit-By-Doing))

## Usage
1. Create an app in slack, you'll need the URL for the next step.

2. Start the talkbot
```
|start %talkbot
```

3. Join a channel
```
:talkbot [%join our ~.sandbox]
```

4. Configure the slack integration  
Replace the URL below with the slack webhook
```
:talkbot [%slack [~ "https://hooks.slack.com/services/XXXX/XXXX/XXXX"]
```

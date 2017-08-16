::  Bot for talk.

/-  talk
!:

|%
++  move  {bone card}
++  card
  $%  {$peer wire {@p term} path}
      {$pull wire {@p term} $~}
      {$poke wire {@p term} {$talk-command command:talk}}
      {$hiss wire $~ $httr {$hiss hiss}}
  ==
++  action
  $%  {$join s/station:talk}
      {$leave s/station:talk}
      {$joined $~}
      {$slack s/(unit tape)}                    :: set slack webhook url
      {$channel s/station:talk c/(unit cord)}   :: map station to slack channel
  ==
++  state
  $:  $1
      joined/(list station:talk)
      slack/(unit tape)
      channelmap/(map station:talk cord)
  ==
++  oldstate
  $%  state
      {$0 joined/(list station:talk) slack/(unit tape)}
  ==
--

|_  {bowl state}

:: adapt old state
++  prep
  |=  old/(unit oldstate)
  ^-  (quip move +>)
  ?~  old
    [~ +>]
  ?-  u.old
  {$0 *}
    [~ +>(+<+ [%1 joined.+<.u.old slack.+>.old ~])]
  {$1 *}
    [~ +>(+<+ u.old)]
  ==

++  poke-noun
  |=  a/action
  ^-  {(list move) _+>.$}
  ?-  a
  {$join *}
    ?^  (find [s.a ~] joined)
      ~&  [%already-joined s.a]
      [~ +>.$]
    ~&  [%joining s.a]
    :-  [[ost %peer /listen/(scot %p p.s.a)/[q.s.a] [p.s.a %talk] /afx/[q.s.a]/(scot %da now)] ~]
    +>.$(joined [s.a joined])
  {$leave *}
    =+  i=(find [s.a ~] joined)
    ?~  i
      ~&  [%already-left s.a]
      [~ +>.$]
    ~&  [%leaving s.a]
    :-  [[ost %pull /listen/(scot %p p.s.a)/[q.s.a] [p.s.a %talk] ~] ~]
    +>.$(joined (weld (scag u.i joined) (slag +(u.i) joined)))
  {$joined $~}
    ~&  [%currently-joined joined]
    [~ +>.$]
  {$slack *}
    ~&  [%setting-slack s.a]
    [~ +>.$(slack s.a)]
  {$channel *}
    ~&  [%map-slack-channel s.a c.a]
    =.  channelmap
    ?~  c.a
      (~(del by channelmap) s.a)
    (~(put by channelmap) s.a (need c.a))
    [~ +>.$]
  ==

++  diff-talk-report
  |=  {wir/wire rep/report:talk}
  ^-  {(list move) _+>.$}
  ?+  rep
    ~&  [%unprocessed-report-type -:rep]
    [~ +>.$]
  {$grams *}  ::  Message list.
    :_  +>.$
    %+  murn  q.rep
      |=  gram/telegram:talk
      (read-telegram wir gram)
  ==

++  read-telegram
  |=  {wir/wire gram/telegram:talk}
  ^-  (unit move)
  =+  aud=(station-from-wire wir)
  ?~  aud
    ~&  %message-source-unclear
    ~
  =+  txt=(process-speech r.r.q.gram)
  ?~  txt
    ~
  (send-slack p.gram u.txt (~(get by channelmap) u.aud))

++  process-speech
  |=  msg/speech:talk
  ^-  (unit {@t json})
  ?+  msg
    ~&  [%unprocessed-message-type -:msg]
    ~
  {$lin *}  ::  Regular message.
    =+  tmsg=(trip q.msg)
    %-  some
    :-  %text
    :-  %s
    %-  crip
    ?:  p.msg
      "{tmsg}"
    "_{tmsg}_"
  ::
  {$url *}  ::  URL
    =+  pur=p.msg
    `text+s+(crip "<{(earf pur)}>")
  ::
  {$exp *}  ::  hoon line
    =+  exp=(trip p.msg)
    `text+s+(crip "`{exp}`")
  ::
  {$fat *}  ::  attachment
    :: deal with speech
    =+  pretxt=(process-speech q.msg)
    ?~  pretxt
      ~
    ?.  ?=({$text *} u.pretxt)
      ~&  [%unsupported-fat-speech -.u.pretxt]
      ~
    :: deal with attachment
    ?+  p.msg
      ~&  [%unsupported-torso-type p.msg]
      ~
    {$tank *}
      ~&  [%tank q=+.p.msg]
      =/  txt
      %-  role
      %+  turn
        ^-  wall
        %-  zing
        ^-  (list wall)
        %+  turn  +.p.msg
        |=(tan/tank (wash 0^50 tan))
      crip
      %-  some
      :-  %attachments
      ^-  json
      :-  %a
      :~
        %-  jobe
        :~
          pretext++.u.pretxt
          text+s+txt
          :-  'mrkdwn_in'
            [%a [s+'pretext' ~]]
        ==
      ==
    ==
  ==

++  send
  |=  {aud/station:talk mess/?(tape @t)}
  ^-  move
  =+  mes=?@(mess (trip mess) mess)
  :*  ost
      %poke
      /repeat/(scot %ud 1)/(scot %p p.aud)/[q.aud]
      [our %talk]
      (said our aud %talk now eny [%leaf (weld ":: " mes)]~)
  ==

++  send-slack
  |=  {usr/@p content/{@t json} channel/(unit @t)}
  ^-  (unit move)
  ?~  slack
    ~&  %slack-url-not-set
    ~
  =+  pusr=(crip (cite usr))
  =/  hiz
  :*  (scan (need slack) auri:epur)
      %post  ~  ~
      %-  taco  %-  crip  %-  pojo  %-  jobe  :~
        content
        username+s+pusr
        mrkdwn+b+&
        channel+s+(fall channel '')
      ==
  ==
  `[ost %hiss /send-slack ~ %httr [%hiss hiz]]

++  sigh-httr
  |=  {way/wire res/httr}
  ^-  {(list move) _+>.$}
  ::~&  [%sigh way=way res=res]
  ?.  =(200 p.res)
    ~&  [%response p=p.res r=r.res]
    [~ +>.$]
  [~ +>.$]

++  sigh-tang
  |=  {way/wire tan/tang}
  ^-  {(list move) _+>.$}
  %-  (slog >%talk-sigh-tang< tan)
  [~ +>.$]
::

++  said  ::  Modified from lib/talk.hoon.
  |=  {our/@p cuz/station:talk dap/term now/@da eny/@uvJ mes/(list tank)}
  :-  %talk-command
  ^-  command:talk
  :-  %publish
  |-  ^-  (list thought:talk)
  ?~  mes  ~
  :_  $(mes t.mes, eny (sham eny mes))
  ^-  thought:talk
  :+  (shaf %thot eny)
    [[[%& cuz] [*envelope:talk %pending]] ~ ~]
  [now *bouquet:talk [%lin & (crip ~(ram re i.mes))]]

++  station-from-wire
  |=  wir/wire
  ^-  (unit station:talk)
  ?:  ?=({$listen *} wir)
    $(wir t.wir)
  ?.  ?=({@tas @tas *} wir)
    ~
  =+  ship=(slaw %p i.wir)
  ?~  ship
    ~&  [%unparsable-wire-station wir]
    ~
  =+  channel=(crip (slag 1 (spud t.wir)))
  [~ [u.ship channel]]

--

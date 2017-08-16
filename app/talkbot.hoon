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
      {$slack s/(unit tape)}
  ==
++  state
  $:  $0
      joined/(list station:talk)
      slack/(unit tape)
  ==
--

|_  {bowl state}

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
  =*  msg  r.r.q.gram
  ?+  msg
    ~&  [%unprocessed-message-type -:msg]
    ~
  {$lin *}  ::  Regular message.
    =+  tmsg=(trip q.msg)
    (send-slack (crip "{(cite p.gram)}: {tmsg}"))
  {$url *}  ::  URL
    =+  pur=p.msg
    (send-slack (crip "{(cite p.gram)}: <{(earf pur)}>"))

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
  |=  a/@t
  ^-  (unit move)
  ?~  slack
    ~&  %slack-url-not-set
    ~
  =/  hiz
  :*  (scan (need slack) auri:epur)
      %post  ~  ~
      %-  taco  %-  crip  %-  pojo  %-  jobe  :~
        text+s+a
      ==
  ==
  `[ost %hiss /send-ext ~ %httr [%hiss hiz]]

++  sigh-httr
  |=  {way/wire res/httr}
  ^-  {(list move) _+>.$}
  ::~&  [%sigh way=way res=res]
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

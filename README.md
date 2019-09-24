# rpi-boardgame-turns

Web application for measuring turns in board games. Used for Raspberry PI with touchscreen 800x480.

## Script for restore


```ex
alias Balloonboard.Repo
rb = Repo.get!(Round, 374)
re = Repo.get!(Round, 376)
Repo.insert!(%Round{session_id: 28, started_at: rb.stopped_at, stopped_at: re.started_at, player: 2})
```

```ex
session = Repo.get!(Session, 29)
Repo.delete(session)
```

```ex
UsedTag.update_comment!(0, "")
```

```
update sessions set config = '{"dust":true}' where id = 28;
```

## TODO

- multiplayer support
- avatars
- display all data (dust)
- timeline per session

## Notes

session at 27.04.2019 (TC error)

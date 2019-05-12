# Balloonboard

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


## TODO

- fairy dust flag
- confirm on stop
- timeline
- multiplayer support
- avatars

## Notes

session_id: 28 (fairy dust)

session at 27.04.2019 (TC error)

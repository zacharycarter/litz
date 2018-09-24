import hashes, sets, macros, sequtils,
  tagdef

macro html5_tags(n: untyped): untyped =
  result = newStmtList(
    parseStmt staticRead("./private/html5_tag_defs.nim")
  )

html5_tags:
  foo
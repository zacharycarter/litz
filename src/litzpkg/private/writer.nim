{.experimental: "notnil".}
import macros

type
  ## This writer is used for creating an AST which represents the
  ## implementation of an emerald template. It merges adjacent literal
  ## strings into one instead of creating one write command for every
  ## literal string.
  StmtListWriterObj* = tuple
    streamIdent: NimNode
    output: NimNode
    cache1, cache2, cache3: NimNode
    filteredStringCache: string
    literalStringCache: string
    curFilters: seq[NimNode]

  StmtListWriter* = ref StmtListWriterObj not nil
  OptionalStmtListWriter* = ref StmtListWriterObj

proc newStmtListWriter*(streamName: NimNode, cache1: NimNode, cache2: NimNode, cache3: NimNode,
            lineRef: NimNode = nil):
             StmtListWriter {.compileTime.} =
  new(result)
  result.streamIdent = streamName
  result.output = newNimNode(nnkStmtList, lineRef)
  result.filteredStringCache = ""
  result.literalStringCache = ""
  result.cache1 = cache1
  result.cache2 = cache2
  result.cache3 = cache3
  result.curFilters = newSeq[NimNode]()

proc copy*(writer: StmtListWriter, lineRef: NimNode = nil):
    StmtListWriter {.compileTime.} =
  new(result)
  result.streamIdent = writer.streamIdent
  result.output = newNimNode(nnkStmtList, lineRef)
  result.filteredStringCache = ""
  result.literalStringCache = ""
  result.cache1 = writer.cache1
  result.cache2 = writer.cache2
  result.cache3 = writer.cache3
  result.curFilters = writer.curFilters

proc addFilteredNode(writer: StmtListWriter, node: NimNode) {.compileTime.} =
  if writer.curFilters.len > 0:
    for i in 0 .. writer.curFilters.len - 1:
      var call = newCall(writer.curFilters[i][0])
      if i == writer.curFilters.len - 1:
        call.add(copyNimTree(writer.cache3))
      else:
        writer.output.add(newCall(newNimNode(nnkDotExpr).add(
            if i mod 2 == 0: writer.cache1 else: writer.cache2,
              ident("setLen")),  newIntLitNode(0)))
        call.add(if i mod 2 == 0: writer.cache1 else: writer.cache2)
      call.add(if i == 0: node else: newCall("substr", if i mod 2 == 0: writer.cache2
          else: writer.cache1, newIntLitNode(0),
          newNimNode(nnkInfix).add(ident("-"), newCall("len",
          if i mod 2 == 0: writer.cache2 else: writer.cache1),
          newIntLitNode(1))))
      for p in 1..writer.curFilters[i].len - 1:
        call.add(writer.curFilters[i][p])
      writer.output.add(
        newAssignment(
          call[1],
            call
        )
      )
  else:
    writer.output.add(
      newAssignment(
        writer.cache3,
        node
      )
    )

proc consumeCache(writer : StmtListWriter) {.compileTime.} =
  if writer.filteredStringCache.len > 0:
    writer.addFilteredNode(newStrLitNode(writer.filteredStringCache))
    writer.filteredStringCache = ""
  if writer.literalStringCache.len > 0:
    writer.output.add(newCall(ident("add"), writer.cache3,
        newStrLitNode(writer.literalStringCache)))
    writer.literalStringCache = ""

proc setStreamIdent*(writer: StmtListWriter,
             streamIdent: NimNode) {.compileTime.} =
  writer.consumeCache()
  writer.streamIdent = streamIdent

proc targetStream*(writer: StmtListWriter): NimNode {.compileTime.} =
  writer.streamIdent

proc cacheVars*(writer: StmtListWriter):
    tuple[cache1: NimNode, cache2: NimNode, cache3: NimNode] {.compileTime.} =
    (writer.cache1, writer.cache2, writer.cache3)

proc result*(writer : StmtListWriter): NimNode {.compileTime.} =
  ## Get the current result AST. This proc has the side effect of finalizing
  ## the current literal string cache.

  writer.consumeCache()
  writer.output.add(
    newAssignment(writer.streamIdent, newDotExpr(writer.cache3, ident"cstring"))
  )
  return writer.output

proc streamName*(writer: StmtListWriter):
    NimNode {.inline, compileTime.} =
  ## returns the node containing the name of the output stream variable.
  writer.streamIdent

proc addFiltered*(writer : StmtListWriter, val: string) {.compileTime.} =
  if writer.literalStringCache.len > 0:
    writer.consumeCache()
  writer.filteredStringCache.add(val)

proc addLiteral*(writer: StmtListWriter, val: string) {.compileTime.} =
  if writer.filteredStringCache.len > 0:
    writer.consumeCache()
  writer.literalStringCache.add(val)

proc addFiltered*(writer: StmtListWriter, val: NimNode) {.compileTime.} =
  writer.consumeCache()
  writer.addFilteredNode(val)

proc addLiteral*(writer: StmtListWriter, val: NimNode) {.compileTime.} =
  if writer.filteredStringCache.len > 0:
    writer.consume_cache()
  writer.literalStringCache.add($toStrLit(val))

proc addAttrVal*(writer: StmtListWriter, name: string,
           val: NimNode) {.compileTime.} =
  writer.addLiteral(' ' & name & "=\"")
  writer.consumeCache()
  writer.output.add(newAssignment(writer.cache3, newCall("escape_html", writer.cache3, val,
      ident("true"))))
  writer.addLiteral("\"")

proc addAttrVal*(writer: StmtListWriter, name: string,
           val: string) {.compileTime.} =
  writer.addLiteral(' ' & name & "=\"")
  writer.consumeCache()
  writer.output.add(newAssignment(writer.cache3, newCall("escape_html", writer.cache3,
      newStrLitNode(val), ident("true"))))
  writer.addLiteral("\"")

# proc add_bool_attr*(writer: StmtListWriter, name: string,
#   val: NimNode) {.compileTime.} =
#   writer.consume_cache()
#   writer.output.add(newIfStmt((val, newCall("write", writer.streamIdent,
#   newStrLitNode(' ' & name & "=\"" & name & "\"")))))

proc add_bool_attr*(writer: StmtListWriter, name: string,
                    val: NimNode) {.compileTime.} =
  # writer.output.add(newIfStmt((val, newCall("write", writer.streamIdent,
  #   newStrLitNode(' ' & name & "=\"" & name & "\"")))))
    
  let strVal = val.strVal
  if strVal == "true":
    writer.consume_cache()
    writer.literalStringCache.add($newStrLitNode(' ' & name & "=\"" & name & "\""))



proc addNode*(writer : StmtListWriter, val: NimNode) {.compileTime.} =
  writer.consumeCache()
  writer.output.add(val)

proc `filters=`*(writer: StmtListWriter, filters: seq[NimNode]) {.compileTime.}=
  if writer.filteredStringCache.len > 0:
    writer.consumeCache()
  writer.curFilters = filters
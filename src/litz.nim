# litz
# Copyright zacharycarter
# Tagged template literal web app lib
import 
  dom, jsffi, jsconsole, strutils, sequtils, sets,
  litzpkg / [html, filters]

from litzpkg / tagdef import 
  tag_list,
  ContentCategory,
  TagId,
  ExtendedTagId,
  TagDef,
  unknownTag

from hashes import hashIgnoreCase

export 
  html,
  filters,
  ContentCategory,
  TagId,
  ExtendedTagId,
  TagDef,
  hashIgnoreCase,
  unknownTag,
  sets

type
  JSString* = cstring
  WeakMap = ref object of JsObject
  WeakSet = ref object of JsObject
  DocumentFragment = ref object of Node
  Template = ref object of Element
    content: DocumentFragment

proc `jss`*(s: string): JSString = s.JSString

proc indexOf(cs: cstring, c: char): cint {.importcpp: "#.indexOf(#)".}
proc jsBind*(p: JsObject, e: JsObject): JsObject {. importcpp: "#.bind(#)" .}
proc newWeakMap(): WeakMap {.importcpp: "new WeakMap()".}
proc len(wm: WeakMap): cint {.importcpp: "#.length".}
proc newWeakSet(): WeakSet {.importcpp: "new WeakSet()".}
proc has(ws: WeakSet, n: Node): bool {.importcpp.}
proc `[]`(o: JsObject, o1: JsObject): JsObject {.importcpp: "#[#]".}
proc `[]`(wm: WeakMap, k: JsObject): JsObject {.importcpp: "#.get(#)".}
proc `[]=`(wm: WeakMap, k: JsObject, v: JsObject) {.importcpp: "#.set(#, #)".}
proc setAssgn(wm: WeakMap, k, v, v2: JsObject) {.importcpp: "#.set(#, # = #)".}
proc retAssgn(o, k: JsObject, v: proc (s: JsObject): JsObject): JsObject {.importcpp: "(#[#] = #)".}
proc retAssgn(o, k: JsObject, v: JsObject): JsObject {.importcpp: "(#[#] = #)".}
proc retAssgn(o: JsObject, v: JsObject): JsObject {.importcpp: "(# = #)".}
proc `[]=`(wm: WeakMap, n: Node, v: JsObject) {.importcpp: "#.set(#, #)".}
proc `[]`(m: JsObject, i: cint): JsObject {.importcpp: "#[#]".}
proc `[]=`(m: JsObject, k: JsObject, v: JsObject) {.importcpp: "#.set(#, #)".}
proc `[]`(n: Node, a: cstring): JsObject {.importcpp: "#[#]".}
proc `[]=`(n: Node, k: cstring, v: JsObject) {.importcpp: "#[#] = #".}
proc propertyIsEnumerable(a: JsObject, p: cstring): bool {.importcpp: "#.propertyIsEnumerable(#)".}
proc defaultView(d: Document): JsObject {.importcpp: "#.defaultView".}
proc join(a: JsObject, sep: cstring = ""): cstring {.importcpp: "#.join(#)".}
proc apply(p: JsObject, t: JsObject, r: JsObject): JsObject {.importcpp: "#.apply(#, #)", discardable.}
proc call(p: proc, t: JsObject, r: JsObject): JsObject {.importcpp: "#.call(#, #)", discardable.}
proc call(p: proc, t: JsObject): JsObject {.importcpp: "#.call(#)", discardable.}
proc freeze(o: JsObject): JsObject {.importcpp: "Object.freeze(#)".}
proc indexOf(a: JsObject, b: JsObject): cint {.importcpp: "#.indexOf(#)".}
proc indexOf(a: JsObject, b: cstring): cint {.importcpp: "#.indexOf(#)".}
proc push(a: JsObject, n: JsObject): cint {.importcpp: "#.push(#)", discardable.}
proc newRegExp(r: cstring, g: cstring = ""): JsObject {.importcpp: "new RegExp(#, #)".}
proc test(r: JsObject, t: cstring): bool {.importcpp: "#.test(#)".}
proc replace(s: cstring, r: JsObject, p: JsObject): cstring {.importcpp: "#.replace(#, #)".}
proc replace(s: cstring, r: JsObject, p: cstring): cstring {.importcpp: "#.replace(#, #)".}
proc `or`(a: cstring, b: cstring): cstring {.importcpp: "# || #".}
proc `or`(a: cstring, b: char): cstring {.importcpp: "# || String.fromCharCode(#)".}
proc `in`(a: cstring, b: JsObject): bool {.importcpp: "# in #".}
proc `in`(a: cstring, n: Node): bool {.importcpp: "# in #".}
proc `in`(a: cstring, b: Element): bool {.importcpp: "# in #".}
proc `in`(a: cstring, b: DocumentFragment): bool {.importcpp: "# in #".}
proc `in`(a: cstring, b: Template): bool {.importcpp: "# in #".}
proc `in`(a: cstring, b: Document): bool {.importcpp: "# in #".}
proc createDocumentFragment(d: Document): DocumentFragment {.importcpp: "#.createDocumentFragment()".}
proc getMatch(m: cint): cstring {.importcpp: "RegExp.$$#".}
proc querySelectorAll(d: Template, selectors: cstring): seq[Element] {.importcpp.}
proc slice(): JsObject {.importcpp: "[].slice".}
proc genUid(): cstring {.importcpp: "(Math.random() * new Date() | 0)".}
proc textContent(n: Node): cstring {.importcpp: "#.textContent".}
proc textContent(o: JsObject): cstring {.importcpp: "#.textContent".}
proc `textContent=`(n: Node, s: cstring) {.importcpp: "#.textContent = #".}
proc toLowerCase(s: cstring): cstring {.importcpp.}
proc ownerElement(n: Node): Node {.importcpp: "#.ownerElement".}
proc importNode(d: Document, n: Node, deep: bool): Node {.importcpp: "#.importNode(#, #)".}
proc typeof(o: JsObject): cstring {.importcpp: "typeof(#)".}
proc createEvent(d: Document, kind: cstring): Event {.importcpp: "#.createEvent(#)".}
proc initEvent(e: Event, kind: cstring, bubbles: bool, cancelable: bool) {.importcpp.}
proc newMutationObserver(p: proc(records: JsObject)): JsObject {.importcpp: "new MutationObserver(#)".}
proc value(n: Node): JsObject {.importcpp: "#.value".}
proc `value=`(n: Node, v: JsObject) {.importcpp: "#.value = #".}
proc resolvePromise(o: JsObject): JsObject {.importcpp: "Promise.resolve(#)".}
proc promiseAll(o: JsObject): JsObject {.importcpp: "Promise.all(#)".}
proc stringConstructor(s: JsObject): cstring {.importcpp: "String(#)".}
proc then(f: JsObject, o: JsObject): JsObject {.importcpp: "#.then(#)".}
proc then(f: JsObject, o: proc (v: var JsObject)) {.importcpp: "#.then(#)".}
proc ownerDocument(n: Node): Document {.importcpp: "#.ownerDocument".}
proc instanceof(o: JsObject, o1: JsObject): bool {.importcpp: "# instanceof #".}
proc createRange(d: Document): JsObject {.importcpp.}
proc `===`(a, b: JsObject): bool {.importcpp: "# == #".}
proc newClass(c: JsObject, ctx: JsObject): JsObject {.importcpp: "new #(#)".}

proc tag*(w, o: JsObject, t: cstring): Element {.exportc, discardable.} =
  proc innerTag(innerW, innerO: JsObject, innerT: cstring, innerO1: JsObject): Element {.importcpp: """eval("#(#)`" + #.replace("this", "#") + "`")""", discardable.}
  result = innerTag(w, o, t, o)

proc tagCustomElement*(w: proc(po: JsObject): JsObject, o: cstring, t: Element): Element {.exportc, discardable.} =
  proc innerTag(innerW: proc(po: JsObject): JsObject, innerO: cstring, innerT: Element): Element {.importcpp: """eval("#`" + #.replace("this", "#") + "`")""", discardable.}
  result = innerTag(w, o, t)

proc tagTempl*(w: JsObject, t: JsObject): Element {.exportc, discardable.} =
  proc innerTag(innerW: proc(po: JsObject): JsObject, innerT: JsObject): Element {.importcpp: """eval("#`" + # + "`")""", discardable.}
  result = innerTag(to(w, proc(po: JsObject): JsObject), t)

const
  expando = "_litz: "
  spaces: cstring = " \\f\\n\\r\\t"

proc doc(n: Node): Document =
  result = to(toJs(n.ownerDocument) or toJs(n), Document)

proc create[T](n: Node, t: cstring): T =
  result = (T)(doc(n).createElement(t))

proc fragment(n: Node): DocumentFragment =
  result = doc(n).createDocumentFragment()

proc text(n: Node, t: cstring): Node =
  result = doc(n).createTextNode(t)

let
  almostEverything: cstring = "[^ " & spaces & """\\/>"\'=]+"""
  attrName: cstring = "[ " & spaces & "]+" & almostEverything
  tagName: cstring = "<([A-Za-z]+[A-Za-z0-9:_-]*)((?:"
  attrPartials: cstring = """(?:=(?:\'[^\']*?\'|"[^"]*?"|<[^>]*?>|""" & almostEverything & "))?)"
  connected = "connected"
  disconnected = "dis" & connected
  g = document.defaultView()
  UID: cstring = expando & genUid()
  UIDC: cstring = "<!--" & UID & "-->"
  testFragment = fragment(document)
  hasContent = "content" in create[Template](document, "template")
  hasAppend = "append" in testFragment
  hasImportNode = "importNode" in document
  shouldUseTextContent = newRegExp("""^style|textarea$""", "i")
  trim = to(
    toJs(UID).trim or 
      toJs(proc(): cstring = 
        var this {.importc, nodecl.}: JsObject 
        result = to(this, cstring).replace(newRegExp("""^\s+|\s+$""", "g"), ""))
    , proc(s: cstring): cstring
  )

# forward declaration
proc renderLit*(t: JsObject, tv: varargs[JsObject]): JsObject

proc append(n: Node, cn: openArray[Node]) =
  if hasAppend:
    toJs(n).append.apply(n, cn)
  else:
    for i in 0 ..< len(cn):
      n.appendChild(cn[i])

proc htmlFragment(n: Node, h: cstring): DocumentFragment =
  var container = create[Template](n, "template")

  if hasContent:
    container.innerHTML = h
    return container.content
  else:
    var content = fragment(n)

    if newRegExp("""^[^\S]*?<(col(?:group)?|t(?:head|body|foot|r|d|h))""", "i").test(h):
      var selector = getMatch(1)
      container.innerHTML = "<table>" & h & "</table>"
      append(content, to(slice.call(toJs(container.querySelectorAll(selector))), seq[Node]))
    else:
      container.innerHTML = h
      append(content, to(slice.call(toJs(container.childNodes)), seq[Node])) 
    
    result = content

proc newMap(): JsObject =
  var
    keys = toJs([])
    values = toJs([])
  
  return JsObject{
    get: proc (o: JsObject): JsObject = result = values[keys.indexOf(o)],
    `set`: proc (k: JsObject, v: JsObject) = values[keys.push(k) - 1] = v
  }

proc newTemplateMap(): JsObject =
  try:
    var
      wm = newWeakMap()
      fo = freeze(toJs([]))
      
    wm[fo] = toJs(true)
    if wm[fo] == nil:
      raise newException(KeyError, "Frozen object key not found.")
    result = wm
  except:
    result = jsnew(g.Map or newMap())

proc component(): JsObject =
  var this {.nodecl, importc.}: JsObject
  result = this


var
  known = newWeakMap()
  components = newWeakSet()
  templates = newTemplateMap()
  attrSeeker = newRegExp(tagName & attrName & attrPartials & "+)([ " & spaces & "]*/?>)", "g")
  findAttributesRegex = newRegExp("(" & attrName & """=)([\'"]?)""" & UIDC & """\\2""", "gi")
  selfClosingRegex = newRegExp(tagName & attrName & attrPartials & "*)([ " & spaces & "]*/>)", "g")
  voidElements = newRegExp("^area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr$", "i")
  notObserving = true
  newEvent = to(g["Event"], proc(kind: cstring): Event)
  jsString {.nodecl, importc: "String".}: JsObject
  jsArray {.nodecl, importc: "Array".}: JsObject 
  attributes = newJsObject()
  intents = newJsObject()
  hasOwnProperty = intents.hasOwnProperty
  keys = toJs([])
  length = 0
  wires = newWeakMap()
  intent = JsObject{
    attributes: newJsObject(),
    define: 
      proc(i: JsObject, cb: JsObject) =
        if i.indexOf("-") < 0:
          if not to(i in intents, bool):
            length = keys.push(i)
          intents[i] = cb
        else:
          attributes[i] = cb,
    invoke: proc(o: JsObject, cb: JsObject): JsObject =
        for i in 0 ..< length:
          var key = keys[i]
          if to(hasOwnProperty.call(o, key), bool):
            result = to(intents[key], proc(o: JsObject, cb: JsObject): JsObject)(o[key], cb)
  }
  isObjectArray = proc(toString: proc(a: JsObject): cstring): proc (a: JsObject): bool =
            return proc (a: JsObject): bool =
              return toString.call(a) == toJs("[object Array]")

  isJsArray: proc(o: JsObject): bool = 
    to(jsArray.isArray or toJs(isObjectArray(to(JsObject{}.toString, proc(a: JsObject): cstring))), proc(o: JsObject): bool)
      

try:
  discard jsNew(newEvent("Event"))
except:
  newEvent = proc(kind: cstring): Event =
    result = document.createEvent("Event")
    result.initEvent(kind, false, false)

proc TL(t: JsObject): JsObject =
  var
    ua = $to((g.navigator or JsObject{}).userAgent, cstring)
    ffv: float

  if t != nil and t.propertyIsEnumerable("raw") or
    to(newRegExp("""Firefox\/(\d+)""").test((g.navigator or JsObject{}).userAgent) and toJs(to(toJs(getMatch(1).parseFloat()), cfloat) < 55), bool):
    var 
      T = JsObject{}
      k = "^".cstring & t.join("^".cstring)
    
    if T[k] == nil: T[k] = t
    result = T[k]
  else:
    result = t

proc unique(t: JsObject): JsObject = 
  result = TL(t)

proc selfClosingPlace(a, b, c: cstring): cstring =
  result = if voidElements.test(b): a else: "<" & b & c & "></" & b & ">"

proc replaceAttributes(a, b, c: cstring): cstring =
  var
    c1 = c or '"'

  result = b & c1 & UID & c1

proc comments(a, b, c, d: cstring): cstring =
  result = "<" & b & c.replace(findAttributesRegex, toJs(replaceAttributes)) & d

proc createFragment(n: Node, html: cstring): DocumentFragment =
  result = htmlFragment(n, html.replace(attrSeeker, toJs(comments)))

proc prepend(path: JsObject, parent: Node, n: Node): cint {.discardable.} =
  result = to(path.unshift(path.indexOf.call(parent.childNodes , n)), cint)

proc createPath(n: Node): JsObject =
  var path = toJs([])

  var parentNode: Node

  case n.nodeType:
  of ElementNode, DocumentFragmentNode:
    parentNode = n
  of CommentNode:
    parentNode = n.parentNode
    prepend(path, parentNode, n)
  else:
    parentNode = n.ownerElement
  
  var tn = parentNode
  parentNode = parentNode.parentNode
  while parentNode != nil:
    prepend(path, parentNode, tn)
    tn = parentNode
    parentNode = parentNode.parentNode

  return path

proc createPathObj(t: cstring, n: Node, name: cstring = ""): JsObject =
  result = JsObject{
    kind: t,
    name: name,
    node: n,
    path: createPath(n)
  }

proc findPath(n: Node, path: seq[cint]): Node =
  var tn = n
  for i in 0 ..< len(path):
    tn = tn.childNodes[path[i]]
  result = tn

proc findAttributes(n: Node, paths: var seq[JsObject], parts: JsObject) =
  var 
    cache = newJsObject()
    attributes = toJs(n.attributes)
    arr = slice.call(toJs(attributes))
    remove = toJs([])
    length = to(arr.length, cint)
    
  for i in 0 ..< length:
    var attribute = arr[i]
    if to(attribute.value, cstring) == UID:
      var name = to(attribute.name, cstring)

      if not(name in cache):
        var realName = to(parts.shift().replace(newRegExp("""^(?:|[\S\s]*?\s)(\S+?)=['"]?$"""), "$$1"), cstring)
        cache[name] = attributes[realName] or attributes[realName.toLowerCase()]
        paths.add(createPathObj("attr", to(cache[name], var Node), realName))
      remove.push(attribute)
  
  var len = to(remove.length, cint)
  for i in 0 ..< len:
    var 
      attr = remove[i]
      attrName = to(attr.name, cstring)
    if newRegExp("^id$", "i").test(attrName): 
      n.removeAttribute(attrName)
    else:
      n.removeAttributeNode(to(remove[i], Node))
  
  let nodeName = n.nodeName
  if newRegExp("^script$", "i").test(nodeName):
    var script = document.createElement(nodeName)
    for attr in attributes:
      script.setAttributeNode(to(attr.cloneNode(true), Node))
    script.textContent = n.textContent
    n.parentNode.replaceChild(script, n)

proc find(n: Node, paths: var seq[JsObject], parts: JsObject) =
  var
    childNodes = n.childNodes
    length = to(toJs(childNodes).length, cint)

  for i in 0 ..< length:
    var child = childNodes[i]
    case child.nodeType
    of ElementNode:
      findAttributes(child, paths, parts)
      find(child, paths, parts)
    of CommentNode:
      if child.textContent == UID:
        parts.shift()
        paths.add(
          if shouldUseTextContent.test(n.nodeName): createPathObj("text", n) else: createPathObj("any", child)
        )
    of TextNode:
      if shouldUseTextContent.test(n.nodeName) and to(toJs(trim).call(child.textContent), cstring) == UIDC:
        parts.shift()
        paths.add(createPathObj("text", n))
    else:
      discard

proc createTemplate(t: JsObject): JsObject =
  var
    this {.nodecl, importc.}: JsObject
    info: JsObject
    paths: seq[JsObject] = @[]
    html = t.join(UIDC).replace(selfClosingRegex, toJs(selfClosingPlace))
    fragment = (Node)createFragment(to(this, Node), html)
  find(fragment, paths, t.slice())
  info = JsObject{fragment: fragment, paths: paths}
  templates[t] = info
  result = info

proc impNode(d: Document, n: Node): Node =
  if hasImportNode:
    result = d.importNode(n, true)
  else:
    result = cloneNode(n, true)

proc wireChildNodes(cn: JsObject) =
  var this {.nodecl, importc.}: JsObject
  this.childNodes = cn
  this.length = cn.length
  this.first = cn[0]
  this.last = cn[to(this.length, cint) - 1]

toJs(wireChildNodes).prototype.insert = 
  proc(): DocumentFragment =
    var this {.nodecl, importc.}: JsObject
    var df = fragment(to(this.first, Node))
    append(df, to(this.childNodes, seq[Node]))
    result = df

toJs(wireChildNodes).prototype.remove = 
  proc(): Node =
    var 
      this {.nodecl, importc.}: JsObject
      first = to(this.first, Node)
      last = to(this.last, Node)
    
    if to(this.length, cint) == 2:
      last.parentNode.removeChild(last)
    else:
      var rng = doc(first).createRange()
      rng.setStartBefore(this.childNodes[1])
      rng.setEndAfter(last)
      rng.deleteContents()
    result = first


proc asNode(item: JsObject, i: cint): Node =
  if "ELEMENT_NODE" in item:
    result = to(item, Node)
  else:
    if item.constructor == toJs(wireChildNodes):
      if 1 / i < 0:
        result = to(if i != 0: item.remove() else: item.last, Node)
      else:
        result = to(if i != 0: item.insert() else: item.first, Node)
    else:
      result = asNode(renderLit(item), i)
      console.log("Item : ", item)

proc eqeq(a, b: JsObject): bool =
  result = a === b

proc identity(o: JsObject): JsObject = result = o

proc remove(g: proc(item: JsObject, i: cint): Node, pn, before, after: Node) =
  if after == nil:
    pn.removeChild(g(toJs(before), -1))
  else:
    var rng = pn.ownerDocument.createRange()
    rng.setStartBefore(g(toJs(before), -1))
    rng.setEndAfter(g(toJs(after), -1))
    rng.deleteContents()

proc domdiff(pn: Node, cn: var seq[Node], fn: seq[Node], opts: var JsObject): seq[Node] =
  if opts == nil:
    opts = JsObject{}
  
  var
    compare = to(toJs(opts.compare) or toJs(eqeq), proc(a, b: Node): bool)
    get = to(toJs(opts.node) or toJs(identity), proc(b: JsObject, i: cint): Node)
    before = if opts.before == nil: nil else: get(opts.before, 0)
    currentStart = 0
    futureStart = 0
    currentEnd = len(cn) - 1
    currentStartNode = if len(cn) > 0: cn[0] else: nil
    currentEndNode = if currentEnd > 0: cn[currentEnd] else: nil
    futureEnd = len(fn) - 1
    futureStartNode = if len(fn) > 0: fn[0] else: nil
    futureEndNode = if futureEnd > 0: fn[futureEnd] else: nil
  
  while currentStart <= currentEnd and futureStart <= futureEnd:
    if currentStartNode == nil:
      inc currentStart
      currentStartNode = cn[currentStart]
    elif currentEndNode == nil:
      dec currentEnd
      currentEndNode = cn[currentEnd]
    elif futureStartNode == nil:
      inc futureStart
      futureStartNode = fn[futureStart]
    elif futureEndNode == nil:
      dec futureEnd
      futureEndNode = fn[futureEnd]
    elif compare(currentStartNode, futureStartNode):
      inc currentStart
      inc futureStart
      currentStartNode = cn[currentStart]
      futureStartNode = fn[futureStart]
    elif compare(currentEndNode, futureEndNode):
      dec currentEnd
      dec futureEnd
      currentEndNode = cn[currentEnd]
      futureEndNode = fn[futureEnd]
    elif compare(currentStartNode, futureEndNode):
      pn.insertBefore(get(toJs(currentStartNode), 1), get(toJs(currentEndNode), -0).nextSibling)
      inc currentStart
      dec futureEnd
      currentStartNode = cn[currentStart]
      futureEndNode = fn[futureEnd]
    elif compare(currentEndNode, futureStartNode):
      pn.insertBefore(get(toJs(currentEndNode), 1), get(toJs(currentStartNode), 0))
      dec currentEnd
      inc futureStart
      currentEndNode = cn[currentEnd]
      futureStartNode = fn[futureStart]
    else:
      var index = cn.find(futureStartNode)
      if index < 0:
        pn.insertBefore(get(toJs(futureStartNode), 1), get(toJs(currentStartNode), 0))
        inc futureStart
        futureStartNode = fn[futureStart]
      else:
        var 
          i = index
          f = futureStart
        while i <= currentEnd and f <= futureEnd and cn[i] == fn[f]:
          inc i
          inc f
        if 1 < i - index:
          dec index
          if index == currentStart:
            pn.removeChild(get(toJs(currentStartNode), -1))
          else:
            remove(get, pn, currentStartNode, cn[index])
          currentStart = i
          futureStart = f
          currentStartNode = cn[i]
          futureStartNode = fn[f]
        else:
          let el = cn[index]
          cn[index] = nil
          pn.insertBefore(get(toJs(el), 1), get(toJs(currentStartNode), 0))
          inc futureStart
          futureStartNode = fn[futureStart]
  
  if currentStart <= currentEnd or futureStart <= futureEnd:
    if currentStart > currentEnd:
      let 
        pin = if len(fn) > futureEnd + 1: fn[futureEnd + 1] else: nil
        place = if pin == nil: before else: get(toJs(pin), 0)
      if futureStart == futureEnd:
        pn.insertBefore(get(toJs(fn[futureStart]), 1), place)
      else:
        let fragment = pn.ownerDocument.createDocumentFragment()
        while futureStart <= futureEnd:
          inc futureStart
          fragment.appendChild(get(toJs(fn[futureStart]), 1))
        pn.insertBefore(fragment, place)
    else:
      if cn[currentStart] == nil: inc currentStart
      if currentStart == currentEnd:
        pn.removeChild(get(toJs(cn[currentStart]), -1))
      else:
        remove(get, pn, cn[currentStart], cn[currentEnd])
  
  return fn





proc canDiff(v: JsObject): bool =
  result = "ELEMENT_NODE" in v or instanceof(v, toJs(wireChildNodes)) or instanceof(v, toJs(component)) 

proc isPromiseish(v: JsObject): bool =
  result = v != nil and "then" in v

proc asHTML(h: JsObject): JsObject =
  result = JsObject{html: h}

proc invokeAtDistance(v: JsObject, cb: proc (v: var JsObject)) =
  var ph = v.placeholder
  cb(ph)
  if "text" in v:
    resolvePromise(v.text).then(jsString).then(cb)
  elif "any" in v:
    resolvePromise(v.any).then(cb)
  elif "html" in v:
    resolvePromise(v.html).then(asHTML).then(cb)
  else:
    resolvePromise(intent.invoke(v, cb)).then(cb)
    
proc setAnyContent(n: Node, childNodes: var seq[Node]): proc(v: var JsObject) =
  var
    diffOptions = JsObject{ node: asNode, before: n }
    fastPath = false
    oldValue: JsObject = nil
  
  proc setAnyContentInner(v: var JsObject) =
    case $typeof(v):
    of "string", "number", "boolean":
      if fastPath:
        if oldValue != v:
          oldValue = v
          childNodes[0].textContent = to(v, cstring)
      else:
        fastPath = true
        oldValue = v
        childNodes = domdiff(n.parentNode, childNodes, @[text(n, to(v, cstring))], diffOptions)
    of "object", "undefined":
      if to(v, JsObject) == nil:
        fastPath = false
        childNodes = domdiff(n.parentNode, childNodes, @[], diffOptions)
    else:
      fastPath = false
      oldValue = v
      if isJsArray(v):
        if to(v.length, cint) == 0:
          if childNodes.len > 0:
            childNodes = domdiff(n.parentNode, childNodes, @[], diffOptions)
        else:
          case $typeof(v[0])
          of "string", "number", "boolean":
            var h = JsObject{html: v}
            setAnyContentInner(h)
          of "object":
            if isJsArray(v[0]):
              v = v.concat.apply(toJs([]), v)
            if isPromiseish(v[0]):
              promiseAll(v).then(setAnyContentInner)
          else:
            childNodes = domdiff(n.parentNode, childNodes, to(v, seq[Node]), diffOptions)
      elif canDiff(v):
        childNodes = 
          if v.nodeType == toJs(DocumentFragmentNode):
            domdiff(
              n.parentNode,
              childNodes, 
              to(slice.call(v.childNodes), seq[Node]),
              diffOptions
            )
          else:
            domdiff(
              n.parentNode,
              childNodes, 
              @[to(v, Node)],
              diffOptions
            )
      elif isPromiseish(v):
        v.then(setAnyContentInner)
      elif "placeholder" in v:
        invokeAtDistance(v, setAnyContentInner)
      elif "text" in v:
        var o = toJs(stringConstructor(v))
        setAnyContentInner(o)
      elif "any" in v:
        setAnyContentInner(v.`any`)
      elif "html" in v:
        childNodes = domdiff(n.parentNode, childNodes, to(slice.call(toJs(createFragment(n, toJs([]).concat(v.html).join("")).childNodes)), seq[Node]), diffOptions)
      elif "length" in v:
        var o = slice.call(v)
        setAnyContentInner(o)
      else:
        var 
          ac = setAnyContentInner
          invoc = intent.invoke(v, ac)
        setAnyContentInner(invoc)
    
  result = setAnyContentInner

proc getChildren(n: Node): JsObject =
  result = toJs([])
  
  for childNode in n.childNodes:
    if childNode.nodeType == ElementNode: result.push(childNode)

proc observe() =
  proc dispatchTarget(n: Node, e: Event) =
    if components.has(n):
      n.dispatchEvent(e)
    
    var children = toJs(n.children) or getChildren(n)
    for child in children:
      dispatchTarget(to(child, Node), e)

  proc dispatchAll(nodes: JsObject, kind: cstring) =
    var event = to(jsNew(newEvent(kind)), Event)
    for node in nodes:
      if to(node, Node).nodeType == ElementNode:
        dispatchTarget(to(node, Node), event)
  
  try:
    newMutationObserver(
      proc (records: JsObject) =
        for record in records:
          dispatchAll(record.removedNodes, disconnected)
          dispatchAll(record.addedNodes, connected)
    ).observe(document, JsObject{ subtree: true, childList: true })
  except:
    document.addEventListener("DOMNodeRemoved", 
      proc(ev: Event) = dispatchAll(toJs([ev.target]), disconnected), false)
    document.addEventListener("DOMNodeInserted", 
      proc(ev: Event) = dispatchAll(toJs([ev.target]), connected), false)

proc setAttribute(n: Node, name: cstring, og: Node): proc(nv: JsObject) =
  var oldValue: JsObject = nil
  if name == "style":
    discard
  elif newRegExp("^on").test(name):
    var kind = to(toJs(name).slice(2), cstring)
    if kind == connected or kind == disconnected:
      if notObserving:
        notObserving = false
        observe()
      components.add(n)
    elif name.toLowerCase() in n:
      kind = kind.toLowerCase()
    return proc(nv: JsObject) =
      if oldValue != nv:
        if oldValue != nil: n.removeEventListener(kind, to(oldValue, proc (ev: Event)), false)
        oldValue = nv
        if nv != nil: n.addEventListener(kind, to(nv, proc (ev: Event)), false)
  elif name == "data" or name in n:
    return proc(nv: JsObject) =
      if oldValue != nv:
        oldValue = nv
        if n[name] != nv:
          n[name] = nv
          if nv == nil:
            n.removeAttribute(name)
  elif name in intent.attributes:
    return proc(o: JsObject) =
      oldValue = toJs(to(intent.attributes[name], proc(n: Node, o: JsObject): JsObject)(n, o))
      n.setAttribute(name, if oldValue == nil: "" else: to(oldValue, string))
  else:
    var
      owner = false
      attr = og.cloneNode(true)
    
    return proc(nv: JsObject) =
      if oldValue != nv:
        oldValue = nv
        if attr.value != nv:
          if nv == nil:
            if owner:
              owner = false
              n.removeAttributeNode(attr)
            attr.value = nv
          else:
            attr.value = nv
            if not owner:
              owner = true
              n.setAttributeNode(attr)

proc setTextContent(n: Node): proc(v: var JsObject) =
  var oldValue: JsObject = nil

  var textContent: (proc (v: var JsObject))
  textContent = proc (v: var JsObject) =
    if oldValue != v:
      oldValue = v
      if typeof(v) == "object" and v != nil:
        if isPromiseish(v):
          v.then(textContent)
        elif "placeholder" in v:
          invokeAtDistance(v, result)
        elif "text" in v:
          var o = toJs(stringConstructor(v.text))
          textContent(o)
        elif "any" in v:
          textContent(v.any)
        elif "html" in v:
          var o = toJs(toJs([]).concat(v.html).join(""))
          textContent(o)
        elif "length" in v:
          var o = toJs(slice.call(v).join(""))
          textContent(o)
        else:
          var o = intent.invoke(v, textContent)
          textContent(o)
      else:
        n.textContent = if v == nil: "" else: to(v, string)
  result = textContent


proc createUpdate(root: var Node, paths: seq[JsObject]): JsObject =
  var updates = toJs([])
  for info in paths:
    var node = findPath(root, to(info.path, seq[cint]))
    case $to(info.kind, cstring):
    of "any":
      var cn: seq[Node] = @[]
      updates.push(setAnyContent(node, cn))
    of "attr":
      updates.push(setAttribute(node, to(info.name, cstring), to(info.node, Node)))
    of "text":
      updates.push(setTextContent(node))
      node.textContent = ""
  return updates

proc updateOne() =
  var this {.nodecl, importc.}: JsObject

  for i in 1 ..< to(jsarguments.length, cint):
    var 
      p: proc(o: var JsObject) = to(this[i - 1], proc(o: var JsObject))
      o = jsarguments[i]
    p(o)
  
proc upgrade(t: JsObject) =
  var
    this {.nodecl, importc.}: Node
    ut = unique(t)
    info = templates.get(ut) or toJs(createTemplate).call(this, ut)
    fragment = impNode(this.ownerDocument, to(info.fragment, Node))
    updates = createUpdate(fragment, to(info.paths, seq[JsObject]))
  known[this] = JsObject{`template`: ut, updates: updates}
  toJs(updateOne).apply(updates, jsarguments)
  this.textContent = ""
  this.appendChild(fragment)

proc renderLit(t: JsObject, tv: varargs[JsObject]): JsObject =
  var 
    this {.nodecl, importc.}: JsObject
  
  let existing = known[this]
  if existing != nil and existing["template"] == unique(t):
    toJs(updateOne).apply(existing["updates"], jsarguments)
  else:
    toJs(upgrade).apply(this, jsarguments)
  return this

proc wireContent(n: Node): JsObject =
  var
    childNodes = n.childNodes
    wireNodes = toJs([])
  for child in childNodes:
    if child.nodeType == ElementNode or to(toJs(trim).call(child.textContent).length, cint) != 0:
      wireNodes.push(child)
  
  result = if to(wireNodes.length, cint) == 1: wireNodes[0] else: jsNew(wireChildNodes(wireNodes))

proc content(kind: cstring): proc(s: JsObject): JsObject =
  var
    wire: JsObject
    container: JsObject
    content: JsObject
    temp: JsObject
    updates: JsObject

  result = proc(s: JsObject): JsObject =
    var u = unique(s)
    var setup = temp != u
    if setup:
      temp = u
      content = toJs(fragment(document))
      container = content # TODO: SVG
      updates = jsBind(toJs(renderLit), container)
    updates.apply(nil, jsarguments)
    if setup:
      wire = wireContent(to(content, Node))
    result = wire

proc weakly(obj: JsObject, kind: JsObject): JsObject =
  let i = to(kind.indexOf(':'), int)
  
  var
    w = wires.get(obj)
    id = kind
    tkind = to(kind, cstring)

  if -1 < i:
    id = kind.slice(i + 1)
    tkind = to(kind.slice(0, i), cstring) or "html"
  
  if w == nil:
    w = newJsObject()
    wires.set(obj, w)
  
  if w[id] != nil:
    return w[id]
  else:
    return retAssgn(w, id, content(tkind))

type
  WiredProc = proc (s: JsObject): JsObject

proc wire*(obj: JsObject, kind: JsObject = nil): WiredProc {.exportc.} =
  if obj == nil:
    result = if kind != nil: content(to(kind, cstring)) else: content("html")
  else:
    result = if kind != nil: to(weakly(obj, kind), WiredProc) else: to(weakly(obj, toJs("html")), WiredProc)

proc setup(content: JsObject) =
  var
    children = newWeakMap()
    create {.nodecl, importc: "Object.create".}: proc(o: JsObject): JsObject 
    createEntry = proc(wm: WeakMap, id: JsObject, component: JsObject): JsObject =
      wm.set(id, component)
      return component
    relate = proc(c: JsObject, info: JsObject): JsObject =
      var relation = JsObject{}
      info.set(c, relation)
      return relation
    get = proc(c: JsObject, info: JsObject, context: JsObject, id: JsObject): JsObject =
      var relation: JsObject = info.get(c) or relate(c, info)
      case $typeof(id)
      of "object", "function":
        var wm = relation.w or retAssgn(relation.w, newWeakMap())
        return wm[id] or createEntry(WeakMap(wm), id, newClass(c, context))
      else:
        var sm: JsObject
        if relation.p != nil:
          sm = relation.p
        else:
          sm = retAssgn(relation.p, create(nil))
        
        return sm[id] or retAssgn(sm, id, newClass(c, context))
    `set` = proc(ctx: JsObject): JsObject =
      var info = newMap()
      children.set(ctx, info)
      return info

setup(toJs(content))

proc bindLit*(e: Element): JsObject {.exportc.} =
  result = jsBind(toJs(renderLit), toJs(e))
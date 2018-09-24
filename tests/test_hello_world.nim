import 
  unittest, dom, jsffi, jsconsole, macros, strutils,
  nes

suite "litz":
  test "Hello World! + Tick":
    class Ticker:
      tickerTempl = html_templ:
        d(data={"key1": "value1", "key2": "value2"}):
          h1: "Hello, World!"
          h2: "It is ${new Date().toLocaleTimeString()}."

    var t = newTicker()
    
    proc tick(r: JsObject) =
      tagTempl(r, t.tickerTempl)
    
    discard window.setInterval(proc () = tick(bindLit(document.body)), 1000)

  test "Basic Component - as Class (not a Custom Element)":
    type 
      WelcomeProps = ref object of JsObject
        name: cstring

    class Welcome:
      props: WelcomeProps
      welcomeTempl = html_templ:
        h1: "Hello, ${this.props.name}"
      render = proc(w: Welcome): Element =
        result = tag(wire, w, w.welcomeTempl)

    var w = newWelcome(WelcomeProps{name: "Carfox!"})
    console.log(w.render())
  
  test "Custom Component":
    class Welcome(HTMLElement):
      args: varargs[JsObject]
      constructorBody:
        this.html = bindLit(this)
      welcomeTempl = html_templ:
        h1: "Hello, ${this.getAttribute('name')}"
      connectedCallback = proc(w: Welcome): Element =
        w.render()
      render = proc(w: Welcome): Element =
        result = tagCustomElement(w.html, w.welcomeTempl, w)

    customElements.define("h-welcome", WelcomeConstructor)
    
    tagTempl(bindLit(document.getElementById("root")), 
      toJs(("""
        <h-welcome name="Sara"></h-welcome>
        <h-welcome name="Cahal"></h-welcome>
        <h-welcome name="Edite"></h-welcome>
      """.unindent()).cstring)
    )
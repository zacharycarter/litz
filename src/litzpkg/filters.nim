import strtabs, strutils

proc lit*(html: var string, val: string) =
  html = "`$1`" % val

proc escape_html*(html: string, val: string, escapeQuotes = false): string =
  ## translates the characters `&`, `<` and `>` to their corresponding
  ## HTML entities. if `escapeQuotes` is `true`, also translates
  ## `"` and `'`.
  result = html

  for c in val:
    case c:
    of '&': result &= "&amp;"
    of '<': result &= "&lt;"
    of '>': result &= "&gt;"
    of '"':
        if escapeQuotes: result &= "&quot;"
        else: result &= "\""
    of '\'':
        if escapeQuotes: result &= "&#39;"
        else: result &= "'"
    else:
      result &= c

proc change_indentation*(html: string, value: string,
  indentation: string): string =
  
  result = html

  var
    in_indentation = false
    initial = true
    consumed_whitespace = false

  for c in value:
    case c
    of '\l':
      if initial:
        initial = false
        consumed_whitespace = true
      if in_indentation:
        result &= "\l"
      else:
        in_indentation = true
    of ' ':
      if initial:
        consumed_whitespace = true
      else:
        if not in_indentation:
          result &= " "
    else:
      if initial:
        initial = false
        if consumed_whitespace and not in_indentation:
          result &= " "
      if in_indentation:
        result &= "\l" & indentation
        in_indentation = false
      result &= c
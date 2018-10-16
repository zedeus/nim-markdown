# To run these tests, simply execute `nimble test`.
# If you have `watchdog`(pip install watchdog), you can run `make test` to watch testing while 

import unittest

import markdownpkg/core

test "escape <tag>":
  check escapeTag("hello <script>") == "hello &lt;script&gt;"

test "escape quote":
  check escapeQuote("hello 'world\"") == "hello &quote;world&quote;"

test "escape & character":
  check escapeAmpersandChar("hello & world") == "hello &amp; world"

test "escape & sequence":
  check escapeAmpersandSeq("hello & world") == "hello &amp; world"
  check escapeAmpersandSeq("hello &amp; world") == "hello &amp; world"

test "headers":
  check markdown("#h1") == "<h1>h1</h1>"
  check markdown("# h1") == "<h1>h1</h1>"
  check markdown(" #h1") == "<h1>h1</h1>"
  check markdown("## h2") == "<h2>h2</h2>"
  check markdown("### h3") == "<h3>h3</h3>"
  check markdown("#### h4") == "<h4>h4</h4>"
  check markdown("##### h5") == "<h5>h5</h5>"
  check markdown("###### h6") == "<h6>h6</h6>"

test "preprocessing":
  check preprocessing("a\n   \nb\n") == "a\n\nb\n"
  check preprocessing("a\tb") == "a    b"
  check preprocessing("a\n   \n   \nb\n") == "a\n\n\nb\n"
  check preprocessing("a\rb") == "a\nb"
  check preprocessing("a\r\nb") == "a\nb"

test "newline":
  check markdown("\n\n\n") == ""

test "indented block code":
  check markdown("    proc helloworld():\n") == "<pre><code>proc helloworld():</code></pre>"
  check markdown("    proc helloworld():\n        echo(\"hello world\")\n"
    ) == "<pre><code>proc helloworld():\n    echo(\"hello world\")</code></pre>"

test "fencing block code":
  check markdown("```nim\nproc helloworld():\n  echo(\"hello world\")\n```"
    ) == "<pre><code lang=\"nim\">proc helloworld():\n  echo(\"hello world\")</code></pre>"
  check markdown("```\nproc helloworld():\n  echo(\"hello world\")\n```"
    ) == "<pre><code lang=\"\">proc helloworld():\n  echo(\"hello world\")</code></pre>"

test "paragraph":
  check markdown("hello world") == "<p>hello world</p>"
  check markdown("p1\np2\n") == "<p>p1\np2</p>"
  check markdown("p1\n") == "<p>p1</p>"
  check markdown("p1\n\np2\n") == "<p>p1</p><p>p2</p>"

test "hrule":
  check markdown("---\n") == "<hr>"
  check markdown("___\n") == "<hr>"
  check markdown("***\n") == "<hr>"
  check markdown("   ---\n") == "<hr>"

test "quote":
  check markdown("> blockquote") == "<blockquote>blockquote</blockquote>"
  check markdown("> block\n> quote\n") == "<blockquote>block\nquote</blockquote>"

test "bulleted item list":
  check markdown("* a\n* b\n") == "<ul><li>a</li><li>b</li></ul>"
  check markdown("+ a\n+ b\n") == "<ul><li>a</li><li>b</li></ul>"
  check markdown("- a\n- b\n") == "<ul><li>a</li><li>b</li></ul>"
  check markdown("1. a\n2. b\n") == "<ol><li>a</li><li>b</li></ol>"

test "define link":
  check markdown("[1]: https://example.com") == ""

test "html block":
  check markdown("<hr>\n\n") == "<hr>"
  check markdown("<!-- comment -->\n\n") == "<!-- comment -->"
  check markdown("<strong>hello world</strong>\n\n") == "<p><strong>hello world</strong></p>"
  check markdown("<strong class='special'>hello world</strong>\n\n") == "<p><strong class='special'>hello world</strong></p>"
  check markdown("<strong class=\"special\">hello world</strong>\n\n") == "<p><strong class=\"special\">hello world</strong></p>"

test "inline autolink":
  check markdown("email to <test@example.com>") == "<p>email to <a href=\"mailto:test@example.com\">test@example.com</a></p>"

(function() {
    function t(t) {
        this.tokens = [];
        this.tokens.links = {};
        this.options = t || f.defaults;
        this.rules = e.normal;
        if (this.options.gfm) {
            if (this.options.tables) {
                this.rules = e.tables
            } else {
                this.rules = e.gfm
            }
        }
    }

    function r(e, t) {
        this.options = t || f.defaults;
        this.links = e;
        this.rules = n.normal;
        if (!this.links) {
            throw new Error("Tokens array requires a `links` property.")
        }
        if (this.options.gfm) {
            if (this.options.breaks) {
                this.rules = n.breaks
            } else {
                this.rules = n.gfm
            }
        } else if (this.options.pedantic) {
            this.rules = n.pedantic
        }
    }

    function i(e) {
        this.tokens = [];
        this.token = null;
        this.options = e || f.defaults
    }

    function s(e, t) {
        return e.replace(!t ? /&(?!#?\w+;)/g : /&/g, "&").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;").replace(/'/g, "&#39;")
    }

    function o(e, t) {
        e = e.source;
        t = t || "";
        return function n(r, i) {
            if (!r) return new RegExp(e, t);
            i = i.source || i;
            i = i.replace(/(^|[^\[])\^/g, "$1");
            e = e.replace(r, i);
            return n
        }
    }

    function u() {}

    function a(e) {
        var t = 1,
            n, r;
        for (; t < arguments.length; t++) {
            n = arguments[t];
            for (r in n) {
                if (Object.prototype.hasOwnProperty.call(n, r)) {
                    e[r] = n[r]
                }
            }
        }
        return e
    }

    function f(e, n, r) {
        if (r || typeof n === "function") {
            if (!r) {
                r = n;
                n = null
            }
            n = a({}, f.defaults, n || {});
            var o = n.highlight,
                u, l, c = 0;
            try {
                u = t.lex(e, n)
            } catch (h) {
                return r(h)
            }
            l = u.length;
            var p = function() {
                var e, t;
                try {
                    e = i.parse(u, n)
                } catch (s) {
                    t = s
                }
                n.highlight = o;
                return t ? r(t) : r(null, e)
            };
            if (!o || o.length < 3) {
                return p()
            }
            delete n.highlight;
            if (!l) return p();
            for (; c < u.length; c++) {
                (function(e) {
                    if (e.type !== "code") {
                        return --l || p()
                    }
                    return o(e.text, e.lang, function(t, n) {
                        if (n == null || n === e.text) {
                            return --l || p()
                        }
                        e.text = n;
                        e.escaped = true;
                        --l || p()
                    })
                })(u[c])
            }
            return
        }
        try {
            if (n) n = a({}, f.defaults, n);
            return i.parse(t.lex(e, n), n)
        } catch (h) {
            h.message += "\nPlease report this to https://github.com/chjj/marked.";
            if ((n || f.defaults).silent) {
                return "<p>An error occured:</p><pre>" + s(h.message + "", true) + "</pre>"
            }
            throw h
        }
    }
    var e = {
        newline: /^\n+/,
        code: /^( {4}[^\n]+\n*)+/,
        fences: u,
        hr: /^( *[-*_]){3,} *(?:\n+|$)/,
        heading: /^ *(#{1,6}) *([^\n]+?) *#* *(?:\n+|$)/,
        nptable: u,
        lheading: /^([^\n]+)\n *(=|-){2,} *(?:\n+|$)/,
        blockquote: /^( *>[^\n]+(\n[^\n]+)*\n*)+/,
        list: /^( *)(bull) [\s\S]+?(?:hr|\n{2,}(?! )(?!\1bull )\n*|\s*$)/,
        html: /^ *(?:comment|closed|closing) *(?:\n{2,}|\s*$)/,
        def: /^ *\[([^\]]+)\]: *<?([^\s>]+)>?(?: +["(]([^\n]+)[")])? *(?:\n+|$)/,
        table: u,
        paragraph: /^((?:[^\n]+\n?(?!hr|heading|lheading|blockquote|tag|def))+)\n*/,
        text: /^[^\n]+/
    };
    e.bullet = /(?:[*+-]|\d+\.)/;
    e.item = /^( *)(bull) [^\n]*(?:\n(?!\1bull )[^\n]*)*/;
    e.item = o(e.item, "gm")(/bull/g, e.bullet)();
    e.list = o(e.list)(/bull/g, e.bullet)("hr", /\n+(?=(?: *[-*_]){3,} *(?:\n+|$))/)();
    e._tag = "(?!(?:" + "a|em|strong|small|s|cite|q|dfn|abbr|data|time|code" + "|var|samp|kbd|sub|sup|i|b|u|mark|ruby|rt|rp|bdi|bdo" + "|span|br|wbr|ins|del|img)\\b)\\w+(?!:/|@)\\b";
    e.html = o(e.html)("comment", /<!--[\s\S]*?-->/)("closed", /<(tag)[\s\S]+?<\/\1>/)("closing", /<tag(?:"[^"]*"|'[^']*'|[^'">])*?>/)(/tag/g, e._tag)();
    e.paragraph = o(e.paragraph)("hr", e.hr)("heading", e.heading)("lheading", e.lheading)("blockquote", e.blockquote)("tag", "<" + e._tag)("def", e.def)();
    e.normal = a({}, e);
    e.gfm = a({}, e.normal, {
        fences: /^ *(`{3,}|~{3,}) *(\S+)? *\n([\s\S]+?)\s*\1 *(?:\n+|$)/,
        paragraph: /^/
    });
    e.gfm.paragraph = o(e.paragraph)("(?!", "(?!" + e.gfm.fences.source.replace("\\1", "\\2") + "|" + e.list.source.replace("\\1", "\\3") + "|")();
    e.tables = a({}, e.gfm, {
        nptable: /^ *(\S.*\|.*)\n *([-:]+ *\|[-| :]*)\n((?:.*\|.*(?:\n|$))*)\n*/,
        table: /^ *\|(.+)\n *\|( *[-:]+[-| :]*)\n((?: *\|.*(?:\n|$))*)\n*/
    });
    t.rules = e;
    t.lex = function(e, n) {
        var r = new t(n);
        return r.lex(e)
    };
    t.prototype.lex = function(e) {
        e = e.replace(/\r\n|\r/g, "\n").replace(/\t/g, "    ").replace(/\u00a0/g, " ").replace(/\u2424/g, "\n");
        return this.token(e, true)
    };
    t.prototype.token = function(t, n) {
        var t = t.replace(/^ +$/gm, ""),
            r, i, s, o, u, a, f, l, c;
        while (t) {
            if (s = this.rules.newline.exec(t)) {
                t = t.substring(s[0].length);
                if (s[0].length > 1) {
                    this.tokens.push({
                        type: "space"
                    })
                }
            }
            if (s = this.rules.code.exec(t)) {
                t = t.substring(s[0].length);
                s = s[0].replace(/^ {4}/gm, "");
                this.tokens.push({
                    type: "code",
                    text: !this.options.pedantic ? s.replace(/\n+$/, "") : s
                });
                continue
            }
            if (s = this.rules.fences.exec(t)) {
                t = t.substring(s[0].length);
                this.tokens.push({
                    type: "code",
                    lang: s[2],
                    text: s[3]
                });
                continue
            }
            if (s = this.rules.heading.exec(t)) {
                t = t.substring(s[0].length);
                this.tokens.push({
                    type: "heading",
                    depth: s[1].length,
                    text: s[2]
                });
                continue
            }
            if (n && (s = this.rules.nptable.exec(t))) {
                t = t.substring(s[0].length);
                a = {
                    type: "table",
                    header: s[1].replace(/^ *| *\| *$/g, "").split(/ *\| */),
                    align: s[2].replace(/^ *|\| *$/g, "").split(/ *\| */),
                    cells: s[3].replace(/\n$/, "").split("\n")
                };
                for (l = 0; l < a.align.length; l++) {
                    if (/^ *-+: *$/.test(a.align[l])) {
                        a.align[l] = "right"
                    } else if (/^ *:-+: *$/.test(a.align[l])) {
                        a.align[l] = "center"
                    } else if (/^ *:-+ *$/.test(a.align[l])) {
                        a.align[l] = "left"
                    } else {
                        a.align[l] = null
                    }
                }
                for (l = 0; l < a.cells.length; l++) {
                    a.cells[l] = a.cells[l].split(/ *\| */)
                }
                this.tokens.push(a);
                continue
            }
            if (s = this.rules.lheading.exec(t)) {
                t = t.substring(s[0].length);
                this.tokens.push({
                    type: "heading",
                    depth: s[2] === "=" ? 1 : 2,
                    text: s[1]
                });
                continue
            }
            if (s = this.rules.hr.exec(t)) {
                t = t.substring(s[0].length);
                this.tokens.push({
                    type: "hr"
                });
                continue
            }
            if (s = this.rules.blockquote.exec(t)) {
                t = t.substring(s[0].length);
                this.tokens.push({
                    type: "blockquote_start"
                });
                s = s[0].replace(/^ *> ?/gm, "");
                this.token(s, n);
                this.tokens.push({
                    type: "blockquote_end"
                });
                continue
            }
            if (s = this.rules.list.exec(t)) {
                t = t.substring(s[0].length);
                o = s[2];
                this.tokens.push({
                    type: "list_start",
                    ordered: o.length > 1
                });
                s = s[0].match(this.rules.item);
                r = false;
                c = s.length;
                l = 0;
                for (; l < c; l++) {
                    a = s[l];
                    f = a.length;
                    a = a.replace(/^ *([*+-]|\d+\.) +/, "");
                    if (~a.indexOf("\n ")) {
                        f -= a.length;
                        a = !this.options.pedantic ? a.replace(new RegExp("^ {1," + f + "}", "gm"), "") : a.replace(/^ {1,4}/gm, "")
                    }
                    if (this.options.smartLists && l !== c - 1) {
                        u = e.bullet.exec(s[l + 1])[0];
                        if (o !== u && !(o.length > 1 && u.length > 1)) {
                            t = s.slice(l + 1).join("\n") + t;
                            l = c - 1
                        }
                    }
                    i = r || /\n\n(?!\s*$)/.test(a);
                    if (l !== c - 1) {
                        r = a.charAt(a.length - 1) === "\n";
                        if (!i) i = r
                    }
                    this.tokens.push({
                        type: i ? "loose_item_start" : "list_item_start"
                    });
                    this.token(a, false);
                    this.tokens.push({
                        type: "list_item_end"
                    })
                }
                this.tokens.push({
                    type: "list_end"
                });
                continue
            }
            if (s = this.rules.html.exec(t)) {
                t = t.substring(s[0].length);
                this.tokens.push({
                    type: this.options.sanitize ? "paragraph" : "html",
                    pre: s[1] === "pre" || s[1] === "script" || s[1] === "style",
                    text: s[0]
                });
                continue
            }
            if (n && (s = this.rules.def.exec(t))) {
                t = t.substring(s[0].length);
                this.tokens.links[s[1].toLowerCase()] = {
                    href: s[2],
                    title: s[3]
                };
                continue
            }
            if (n && (s = this.rules.table.exec(t))) {
                t = t.substring(s[0].length);
                a = {
                    type: "table",
                    header: s[1].replace(/^ *| *\| *$/g, "").split(/ *\| */),
                    align: s[2].replace(/^ *|\| *$/g, "").split(/ *\| */),
                    cells: s[3].replace(/(?: *\| *)?\n$/, "").split("\n")
                };
                for (l = 0; l < a.align.length; l++) {
                    if (/^ *-+: *$/.test(a.align[l])) {
                        a.align[l] = "right"
                    } else if (/^ *:-+: *$/.test(a.align[l])) {
                        a.align[l] = "center"
                    } else if (/^ *:-+ *$/.test(a.align[l])) {
                        a.align[l] = "left"
                    } else {
                        a.align[l] = null
                    }
                }
                for (l = 0; l < a.cells.length; l++) {
                    a.cells[l] = a.cells[l].replace(/^ *\| *| *\| *$/g, "").split(/ *\| */)
                }
                this.tokens.push(a);
                continue
            }
            if (n && (s = this.rules.paragraph.exec(t))) {
                t = t.substring(s[0].length);
                this.tokens.push({
                    type: "paragraph",
                    text: s[1].charAt(s[1].length - 1) === "\n" ? s[1].slice(0, -1) : s[1]
                });
                continue
            }
            if (s = this.rules.text.exec(t)) {
                t = t.substring(s[0].length);
                this.tokens.push({
                    type: "text",
                    text: s[0]
                });
                continue
            }
            if (t) {
                throw new Error("Infinite loop on byte: " + t.charCodeAt(0))
            }
        }
        return this.tokens
    };
    var n = {
        escape: /^\\([\\`*{}\[\]()#+\-.!_>])/,
        autolink: /^<([^ >]+(@|:\/)[^ >]+)>/,
        url: u,
        tag: /^<!--[\s\S]*?-->|^<\/?\w+(?:"[^"]*"|'[^']*'|[^'">])*?>/,
        link: /^!?\[(inside)\]\(href\)/,
        reflink: /^!?\[(inside)\]\s*\[([^\]]*)\]/,
        nolink: /^!?\[((?:\[[^\]]*\]|[^\[\]])*)\]/,
        strong: /^__([\s\S]+?)__(?!_)|^\*\*([\s\S]+?)\*\*(?!\*)/,
        em: /^\b_((?:__|[\s\S])+?)_\b|^\*((?:\*\*|[\s\S])+?)\*(?!\*)/,
        code: /^(`+)\s*([\s\S]*?[^`])\s*\1(?!`)/,
        br: /^ {2,}\n(?!\s*$)/,
        del: u,
        text: /^[\s\S]+?(?=[\\<!\[_*`]| {2,}\n|$)/
    };
    n._inside = /(?:\[[^\]]*\]|[^\[\]]|\](?=[^\[]*\]))*/;
    n._href = /\s*<?([\s\S]*?)>?(?:\s+['"]([\s\S]*?)['"])?\s*/;
    n.link = o(n.link)("inside", n._inside)("href", n._href)();
    n.reflink = o(n.reflink)("inside", n._inside)();
    n.normal = a({}, n);
    n.pedantic = a({}, n.normal, {
        strong: /^__(?=\S)([\s\S]*?\S)__(?!_)|^\*\*(?=\S)([\s\S]*?\S)\*\*(?!\*)/,
        em: /^_(?=\S)([\s\S]*?\S)_(?!_)|^\*(?=\S)([\s\S]*?\S)\*(?!\*)/
    });
    n.gfm = a({}, n.normal, {
        escape: o(n.escape)("])", "~|])")(),
        url: /^(https?:\/\/[^\s<]+[^<.,:;"')\]\s])/,
        del: /^~~(?=\S)([\s\S]*?\S)~~/,
        text: o(n.text)("]|", "~]|")("|", "|https?://|")()
    });
    n.breaks = a({}, n.gfm, {
        br: o(n.br)("{2,}", "*")(),
        text: o(n.gfm.text)("{2,}", "*")()
    });
    r.rules = n;
    r.output = function(e, t, n) {
        var i = new r(t, n);
        return i.output(e)
    };
    r.prototype.output = function(e) {
        var t = "",
            n, r, i, o;
        while (e) {
            if (o = this.rules.escape.exec(e)) {
                e = e.substring(o[0].length);
                t += o[1];
                continue
            }
            if (o = this.rules.autolink.exec(e)) {
                e = e.substring(o[0].length);
                if (o[2] === "@") {
                    r = o[1].charAt(6) === ":" ? this.mangle(o[1].substring(7)) : this.mangle(o[1]);
                    i = this.mangle("mailto:") + r
                } else {
                    r = s(o[1]);
                    i = r
                }
                t += '<a href="' + i + '">' + r + "</a>";
                continue
            }
            if (o = this.rules.url.exec(e)) {
                e = e.substring(o[0].length);
                r = s(o[1]);
                i = r;
                t += '<a href="' + i + '">' + r + "</a>";
                continue
            }
            if (o = this.rules.tag.exec(e)) {
                e = e.substring(o[0].length);
                t += this.options.sanitize ? s(o[0]) : o[0];
                continue
            }
            if (o = this.rules.link.exec(e)) {
                e = e.substring(o[0].length);
                t += this.outputLink(o, {
                    href: o[2],
                    title: o[3]
                });
                continue
            }
            if ((o = this.rules.reflink.exec(e)) || (o = this.rules.nolink.exec(e))) {
                e = e.substring(o[0].length);
                n = (o[2] || o[1]).replace(/\s+/g, " ");
                n = this.links[n.toLowerCase()];
                if (!n || !n.href) {
                    t += o[0].charAt(0);
                    e = o[0].substring(1) + e;
                    continue
                }
                t += this.outputLink(o, n);
                continue
            }
            if (o = this.rules.strong.exec(e)) {
                e = e.substring(o[0].length);
                t += "<strong>" + this.output(o[2] || o[1]) + "</strong>";
                continue
            }
            if (o = this.rules.em.exec(e)) {
                e = e.substring(o[0].length);
                t += "<em>" + this.output(o[2] || o[1]) + "</em>";
                continue
            }
            if (o = this.rules.code.exec(e)) {
                e = e.substring(o[0].length);
                t += "<code>" + s(o[2], true) + "</code>";
                continue
            }
            if (o = this.rules.br.exec(e)) {
                e = e.substring(o[0].length);
                t += "<br>";
                continue
            }
            if (o = this.rules.del.exec(e)) {
                e = e.substring(o[0].length);
                t += "<del>" + this.output(o[1]) + "</del>";
                continue
            }
            if (o = this.rules.text.exec(e)) {
                e = e.substring(o[0].length);
                t += s(this.smartypants(o[0]));
                continue
            }
            if (e) {
                throw new Error("Infinite loop on byte: " + e.charCodeAt(0))
            }
        }
        return t
    };
    r.prototype.outputLink = function(e, t) {
        if (e[0].charAt(0) !== "!") {
            return '<a href="' + s(t.href) + '"' + (t.title ? ' title="' + s(t.title) + '"' : "") + ">" + this.output(e[1]) + "</a>"
        } else {
            return '<img src="' + s(t.href) + '" alt="' + s(e[1]) + '"' + (t.title ? ' title="' + s(t.title) + '"' : "") + ">"
        }
    };
    r.prototype.smartypants = function(e) {
        if (!this.options.smartypants) return e;
        return e.replace(/--/g, /u2013/).replace(/(^|[-\u2014/(\[{"\s])'/g, "$1‘").replace(/'/g, "’").replace(/(^|[-\u2014/(\[{\u2018\s])"/g, "$1“").replace(/"/g, "”").replace(/\.{3}/g, "…")
    };
    r.prototype.mangle = function(e) {
        var t = "",
            n = e.length,
            r = 0,
            i;
        for (; r < n; r++) {
            i = e.charCodeAt(r);
            if (Math.random() > .5) {
                i = "x" + i.toString(16)
            }
            t += "&#" + i + ";"
        }
        return t
    };
    i.parse = function(e, t) {
        var n = new i(t);
        return n.parse(e)
    };
    i.prototype.parse = function(e) {
        this.inline = new r(e.links, this.options);
        this.tokens = e.reverse();
        var t = "";
        while (this.next()) {
            t += this.tok()
        }
        return t
    };
    i.prototype.next = function() {
        return this.token = this.tokens.pop()
    };
    i.prototype.peek = function() {
        return this.tokens[this.tokens.length - 1] || 0
    };
    i.prototype.parseText = function() {
        var e = this.token.text;
        while (this.peek().type === "text") {
            e += "\n" + this.next().text
        }
        return this.inline.output(e)
    };
    i.prototype.tok = function() {
        switch (this.token.type) {
            case "space":
            {
                return ""
            };
            case "hr":
            {
                return "<hr>\n"
            };
            case "heading":
            {
                return "<h" + this.token.depth + ' id="' + this.token.text.toLowerCase().replace(/[^\w]+/g, "-") + '">' + this.inline.output(this.token.text) + "</h" + this.token.depth + ">\n"
            };
            case "code":
            {
                if (this.options.highlight) {
                    var e = this.options.highlight(this.token.text, this.token.lang);
                    if (e != null && e !== this.token.text) {
                        this.token.escaped = true;
                        this.token.text = e
                    }
                }
                if (!this.token.escaped) {
                    this.token.text = s(this.token.text, true)
                }
                return "<pre><code" + (this.token.lang ? ' class="' + this.options.langPrefix + this.token.lang + '"' : "") + ">" + this.token.text + "</code></pre>\n"
            };
            case "table":
            {
                var t = "",
                    n, r, i, o, u;
                t += "<thead>\n<tr>\n";
                for (r = 0; r < this.token.header.length; r++) {
                    n = this.inline.output(this.token.header[r]);
                    t += "<th";
                    if (this.token.align[r]) {
                        t += ' style="text-align:' + this.token.align[r] + '"'
                    }
                    t += ">" + n + "</th>\n"
                }
                t += "</tr>\n</thead>\n";
                t += "<tbody>\n";
                for (r = 0; r < this.token.cells.length; r++) {
                    i = this.token.cells[r];
                    t += "<tr>\n";
                    for (u = 0; u < i.length; u++) {
                        o = this.inline.output(i[u]);
                        t += "<td";
                        if (this.token.align[u]) {
                            t += ' style="text-align:' + this.token.align[u] + '"'
                        }
                        t += ">" + o + "</td>\n"
                    }
                    t += "</tr>\n"
                }
                t += "</tbody>\n";
                return "<table>\n" + t + "</table>\n"
            };
            case "blockquote_start":
            {
                var t = "";
                while (this.next().type !== "blockquote_end") {
                    t += this.tok()
                }
                return "<blockquote>\n" + t + "</blockquote>\n"
            };
            case "list_start":
            {
                var a = this.token.ordered ? "ol" : "ul",
                    t = "";
                while (this.next().type !== "list_end") {
                    t += this.tok()
                }
                return "<" + a + ">\n" + t + "</" + a + ">\n"
            };
            case "list_item_start":
            {
                var t = "";
                while (this.next().type !== "list_item_end") {
                    t += this.token.type === "text" ? this.parseText() : this.tok()
                }
                return "<li>" + t + "</li>\n"
            };
            case "loose_item_start":
            {
                var t = "";
                while (this.next().type !== "list_item_end") {
                    t += this.tok()
                }
                return "<li>" + t + "</li>\n"
            };
            case "html":
            {
                return !this.token.pre && !this.options.pedantic ? this.inline.output(this.token.text) : this.token.text
            };
            case "paragraph":
            {
                return "<p>" + this.inline.output(this.token.text) + "</p>\n"
            };
            case "text":
            {
                return "<p>" + this.parseText() + "</p>\n"
            }
        }
    };
    u.exec = u;
    f.options = f.setOptions = function(e) {
        a(f.defaults, e);
        return f
    };
    f.defaults = {
        gfm: true,
        tables: true,
        breaks: false,
        pedantic: false,
        sanitize: false,
        smartLists: false,
        silent: false,
        highlight: null,
        langPrefix: "lang-",
        smartypants: false
    };
    f.Parser = i;
    f.parser = i.parse;
    f.Lexer = t;
    f.lexer = t.lex;
    f.InlineLexer = r;
    f.inlineLexer = r.output;
    f.parse = f;
    if (typeof exports === "object") {
        module.exports = f
    } else if (typeof define === "function" && define.amd) {
        define(function() {
            return f
        })
    } else {
        this.marked = f
    }
}).call(function() {
        return this || (typeof window !== "undefined" ? window : global)
    }())

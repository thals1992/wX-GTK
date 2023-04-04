// *****************************************************************************
// * Copyright (c) 2020, 2021, 2022 joshua.tee@gmail.com. All rights reserved.
// *
// * Refer to the COPYING file of the official project for license.
// *****************************************************************************

class Text : Widget {

    Gtk.Label textView = new Gtk.Label("");
    string text = "";
    string pre = "";
    string post = "";

    public Text(bool selectable = true) {
        #if GTK4
            textView.set_wrap(true);
        #else
            textView.set_line_wrap(true);
        #endif
        textView.set_justify(Gtk.Justification.LEFT);
        textView.set_halign(Gtk.Align.START);
        textView.set_text(text);
        if (selectable) {
            textView.set_selectable(true);
        }
    }

    string escapeText(string text) {
        var returnText = text;
        returnText = returnText.replace("&", "&amp;");
        returnText = returnText.replace("<", "&lt;");
        returnText = returnText.replace(">", "&gt;");
        return returnText;
    }

    public void setText(string text) {
        textView.set_markup(pre + escapeText(text) + post);
        this.text = text;
    }

    public string text1 {
        get { return this.text; }
        set { this.text = value; }
    }

    public void setWordWrap(bool b) {
        #if GTK4
            textView.set_wrap(b);
        #else
            textView.set_line_wrap(b);
        #endif
    }

    public void setMargin() {
        textView.margin_bottom = UIPreferences.textMargin;
        textView.margin_end = UIPreferences.textMargin;
        textView.margin_start = UIPreferences.textMargin;
        textView.margin_top = UIPreferences.textMargin;
    }

    public void setFixedWidth() {
        pre += "<span font_family='monospace'>";
        post = "</span>" + post;
        textView.set_markup(pre + escapeText(text) + post);
    }

    public void vExpand() {
        textView.set_vexpand(true);
        textView.set_valign(Gtk.Align.START);
    }

    public void hExpand() {
        textView.set_hexpand(true);
        textView.set_halign(Gtk.Align.START);
    }

    public void setBlue() {
        pre += "<span foreground=\"blue\">";
        post = "</span>" + post;
        textView.set_markup(pre + escapeText(text) + post);
    }

    public void setGray() {
        pre += "<span foreground=\"gray\">";
        post = "</span>" + post;
        textView.set_markup(pre + escapeText(text) + post);
    }

    public void setLarge() {
        pre += "<span size=\"large\">";
        post = "</span>" + post;
        textView.set_markup(pre + escapeText(text) + post);
    }

    public void setBold() {
        pre += "<b>";
        post = "</b>" + post;
        textView.set_markup(pre + escapeText(text) + post);
    }

    public Gtk.Label get() { return textView; }

    public Gtk.Widget getView() { return textView; }
}

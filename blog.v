module main

import vweb
import time
import db.sqlite

struct App {
	vweb.Context
	pub mut:
		db     sqlite.DB
		author string
}

fn main() {
	mut app := App {
		db: sqlite.connect('db/blog.db') or { panic(err) }
	}

	sql app.db {
		create table Article
	}

	vweb.run(app, 8081)
}

['/index']
pub fn (app &App) index() vweb.Result {
	articles := app.article_all()
	return $vweb.html()
}

pub fn (mut app App) before_request() {
	app.author = app.get_cookie('author') or { 'Anonim' }
}

['/create']
pub fn (mut app App) create() vweb.Result {
	return $vweb.html()
}

['/store'; post]
pub fn (mut app App) store(title string, text string) vweb.Result {
	if title == '' {
		return app.text('Judul wajib diisi')
	}

	if text == '' {
		return app.text('Konten artikel wajib diisi')
	}

	article := Article {
		title: title
		text: text
		created_at: time.now().format()
		updated_at: time.now().format()
	}


	sql app.db {
		insert article into Article
	}

	// println(article)
	return app.redirect('/')
}


// API ROUTES

['/api/v1/articles'; get]
pub fn (mut app App) articles() vweb.Result {
	return app.json(app.article_all())
}

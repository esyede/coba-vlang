module main

struct Article {
	id         int    [primary; sql: serial]
	title      string
	text       string
	created_at string
	updated_at string
}

pub fn (app &App) article_all() []Article {
	return sql app.db {
		select from Article
	}
}

lint-fasterer:
	bundle exec fasterer

lint-rubocop:
	bundle exec rubocop

lint-rufo:
	bundle exec rufo --check ./**/{*.rb,*.ru}

lint: lint-fasterer lint-rubocop lint-rufo

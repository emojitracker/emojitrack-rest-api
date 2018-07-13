.PHONY: test lint

test:
	bundle exec ruby spec/api_spec.rb

lint-fasterer:
	bundle exec fasterer

lint-rubocop:
	bundle exec rubocop

lint-rufo:
	bundle exec rufo --check ./**/{*.rb,*.ru}

lint: lint-fasterer lint-rubocop lint-rufo

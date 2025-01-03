.PHONY: setup_aider run_aider

setup_aider:
	@if [ ! -f .env.aider ]; then \
		echo "OPENAI_API_KEY=your api key" > .env.aider; \
		@echo "Remember to set your API key"; \
		@read -n 1 -s -r -p "Press any key to continue"; \
	fi
	python3 -m venv .aider-env
	. .aider-env/bin/activate && pip install aider playwright
	. .aider-env/bin/activate && playwright install --with-deps chromium

run_aider:
	. .aider-env/bin/activate && aider .

aider: setup_aider run_aider

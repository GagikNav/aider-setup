.PHONY: setup_aider run_aider create_env_file create_config_file add_aider_files_to_git_ignore clear_aider

# Variables
VENV_DIR = .aider-env
ENV_FILE = .env
CONFIG_FILE = .aider.conf.yml
GITIGNORE = .gitignore
GENERAL_AIDER_FILES = .aider*
PYTHON = python3
PIP = pip
PLAYWRIGHT = playwright

create_env_file:
	@echo "Remember to set your API key in $(ENV_FILE) like so: OPENAI_API_KEY=your api key"
	@read -n 1 -s -r -p "Press any key to continue" && echo

create_config_file:
	@echo "Creating $(CONFIG_FILE)"
	@read 	-p "Do you want to enable auto-commits? (y/n) " AUTO_COMMITS; \
	if [ "$$AUTO_COMMITS" = "y" ]; then \
		echo "auto-commits: true" > $(CONFIG_FILE); \
	else \
		echo "auto-commits: false" > $(CONFIG_FILE); \
	fi
	
	@read -p "Do you want to enable dark mode? (y/n) " DARK_MODE; \
	if [ "$$DARK_MODE" = "y" ]; then \
		echo "dark-mode: true" >> $(CONFIG_FILE); \
	else \
		echo "dark-mode: false" >> $(CONFIG_FILE); \
	fi



add_aider_files_to_git_ignore:

	@if ! grep -qxF $(VENV_DIR) $(GITIGNORE); then \
		echo $(VENV_DIR) >> $(GITIGNORE); \
	fi
	@if ! grep -qxF $(GENERAL_AIDER_FILES) $(GITIGNORE); then \
		echo $(GENERAL_AIDER_FILES) >> $(GITIGNORE); \
	fi

setup_aider:
	@command -v $(PYTHON) >/dev/null 2>&1 || { echo >&2 "$(PYTHON) is not installed. Aborting."; exit 1; }
	@$(PYTHON) -m venv $(VENV_DIR)
	@. $(VENV_DIR)/bin/activate && $(PIP) install aider $(PLAYWRIGHT)
	@. $(VENV_DIR)/bin/activate && $(PLAYWRIGHT) install --with-deps chromium

run_aider:
	@read -p "Run aider? (y/n) " ANSWER; \
	if [ "$$ANSWER" = "y" ]; then \
	. $(VENV_DIR)/bin/activate && aider .; \
	else \
		echo "Skipping..."; \
	fi

aider: add_aider_files_to_git_ignore setup_aider create_env_file create_config_file run_aider

clear_aider:
	@rm -rf $(VENV_DIR) $(CONFIG_FILE) .aider.chat.history.md .aider.tags.cache.v3 .aider.input.history

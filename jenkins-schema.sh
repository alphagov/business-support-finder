#!/bin/bash

export REPO_NAME="alphagov/govuk-content-schemas"
export CONTEXT_MESSAGE="Verify business-support-finder against content schemas"

exec ./jenkins.sh

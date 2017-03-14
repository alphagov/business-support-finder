#!/usr/bin/env groovy

REPOSITORY = 'business-support-finder'
APPLICATION_NAME = 'businesssupportfinder'
DEFAULT_SCHEMA_BRANCH = 'deployed-to-production'

def projectName() {
  JOB_NAME.split('/')[0]
}

// TODO: Delete
def bundleApp() {
  echo 'Bundling'
  sh("bundle install --path ${JENKINS_HOME}/bundles/${projectName()} --deployment --without development")
}

def extractName(input) {
  parts = input.split('/')
  if (parts.length > 2) {
    error("Cannot determine the project name of job '$input'. Expected " +
    "top-level job like 'project_name' or singly nested job like " +
    "'project_name/branch_name'")
  } else {
    parts[0]
  }
}

node {
  def govuk = load '/var/lib/jenkins/groovy_scripts/govuk_jenkinslib.groovy'

  properties([
    buildDiscarder(
      logRotator(numToKeepStr: '10')
      ),
    [$class: 'RebuildSettings', autoRebuild: false, rebuildDisabled: false],
    [$class: 'ThrottleJobProperty',
      categories: [],
      limitOneJobWithMatchingParams: true,
      maxConcurrentPerNode: 1,
      maxConcurrentTotal: 0,
      paramsToUseForLimit: 'business-support-finder',
      throttleEnabled: true,
      throttleOption: 'category'],
    [$class: 'ParametersDefinitionProperty',
      parameterDefinitions: [
        [$class: 'BooleanParameterDefinition',
          name: 'IS_SCHEMA_TEST',
          defaultValue: false,
          description: 'Identifies whether this build is being triggered to test a change to the content schemas'],
        [$class: 'StringParameterDefinition',
          name: 'SCHEMA_BRANCH',
          defaultValue: DEFAULT_SCHEMA_BRANCH,
          description: 'The branch of govuk-content-schemas to test against']]
    ],
  ])

  try {
    govuk.initializeParameters([
      'IS_SCHEMA_TEST': 'false',
      'SCHEMA_BRANCH': DEFAULT_SCHEMA_BRANCH,
    ])

    if (!govuk.isAllowedBranchBuild(env.BRANCH_NAME)) {
      return
    }

    echo "'foo/bar': ${extractName('foo/bar')}"
    echo "'foo': ${extractName('foo')}"
    // echo "'foo/bar/baz': ${extractName('foo/bar/baz')}"
    // echo "'foo/bar/baz/qux': ${extractName('foo/bar/baz/qux')}"
    echo "'': ${extractName('')}"

    sh 'env'

    stage("Configure environment") {
      govuk.setEnvar("RAILS_ENV", "test")
    }

    stage("Checkout") {
      checkout scm
    }

    stage("Clean up workspace") {
      govuk.cleanupGit()
    }

    stage("git merge") {
      govuk.mergeMasterBranch()
    }

    stage("Set up content schema dependency") {
      govuk.contentSchemaDependency(env.SCHEMA_BRANCH)
      govuk.setEnvar("GOVUK_CONTENT_SCHEMAS_PATH", "tmp/govuk-content-schemas")
    }

    stage("bundle install") {
      // TODO: Reinstate
      // govuk.bundleApp()
      bundleApp()
    }

    stage("rubylinter") {
      govuk.rubyLinter()
    }

    stage("Run tests") {
      govuk.runRakeTask("default")
    }

    if (env.BRANCH_NAME == 'master') {
      stage("Push release tag") {
        govuk.pushTag(REPOSITORY, env.BRANCH_NAME, 'release_' + env.BUILD_NUMBER)
      }

      govuk.deployIntegration(APPLICATION_NAME, env.BRANCH_NAME, 'release', 'deploy')
    }

  } catch (e) {
    currentBuild.result = "FAILED"
    step([$class: 'Mailer',
          notifyEveryUnstableBuild: true,
          recipients: 'govuk-ci-notifications@digital.cabinet-office.gov.uk',
          sendToIndividuals: true])
    throw e
  }
}

pipeline {

    agent any

    stages {
        stage('syntax testing') {
            steps {
            sh '/opt/puppetlabs/puppet/bin/rake syntax'
            }
        }
        stage('lint testing'){
            steps {
                sh '/opt/puppetlabs/puppet/bin/rake lint'
            }
        }
        stage('metadata lint'){
            steps {
                sh '/opt/puppetlabs/puppet/bin/rake metadata_lint'
            }
        }
        stage('rspec check'){
            steps {
                sh '/opt/puppetlabs/puppet/bin/rake spec'
            }
        }
    }

    post {
      always {
        echo 'One way or another, I have finished'
          deleteDir() /* clean up our workspace */
      }
      success {
        echo 'posting success to GitLab'
          updateGitlabCommitStatus(name: 'jenkins-build', state: 'success')
      }
      failure {
        echo 'postinng failure to GitLab'
          updateGitlabCommitStatus(name: 'jenkins-build', state: 'failed')
      }

   }

}

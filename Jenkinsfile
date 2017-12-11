podTemplate(
    label: 'mypod',
    containers: [
        containerTemplate(
            name: 'maven',
            image: 'maven:3.3.9-jdk-8-alpine',
            ttyEnabled: true,
            command: 'cat'
        ),
        containerTemplate(
            name: 'golang',
            image: 'golang:1.8.0',
            ttyEnabled: true,
            command: 'cat'
        )
    ],
    volumes: [
        hostPathVolume(hostPath: '/volume/maven', mountPath: '/root/.m2')
        //secretVolume(
        //    secretName: 'maven-settings',
        //    mountPath: '/root/.m2'
        //),
        //persistentVolumeClaim(
        //    claimName: 'maven-local-repo',
        //    mountPath: '/root/.m2nrepo'
        //)
    ]
){

    node('mypod') {

        stage('Get a Maven project') {

            git 'https://github.com/jenkinsci/kubernetes-plugin.git'
            container('maven') {
                stage('Build a Maven project') {
                    sh """
                    pwd
                    echo `pwd`
                    ls `pwd`
                    mvn -B clean install
                    """
                }
            }

        }

        stage('Get a Golang project') {

            git url: 'https://github.com/hashicorp/terraform.git'
            container('golang') {
                stage('Build a Go project') {
                    sh """
                    mkdir -p /go/src/github.com/hashicorp
                    ln -s `pwd` /go/src/github.com/hashicorp/terraform
                    cd /go/src/github.com/hashicorp/terraform && make core-dev
                    """
                }
            }

        }

        stage('Logs') {
            containerLog('golang')
            containerLog('maven')
        }
    }
}
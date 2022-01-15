
/** Builds images for the Grouper Training Env
 *  Each class has a set of images. Each class's image sets are independent, but within
 *  a class each image builds upon the prior exercise. Therefore all images are built
 *  first and then push to the repo. Order of the build is important, but ordering of the
 *  image pushes are not. If an image is missing the extra layers get pushed, then the
 *  missing layers only get tagged when they are pushed.
**/


/** Each class is an associated docker image.
 *  EXERCISE_FOLDERS has the image name and corresponding build folder
**/

TARGET_BRANCH = '202202'

EXERCISE_FOLDERS = [
    "base":       "base",
    "101.1.1":    "ex101/ex101.1.1",
    "201.end":    "ex201/ex201.end",
    "401.end":    "ex401/ex401.end",
    //"201.1.1":    "ex201/ex201.1.1",
    //"201.1.end":  "ex201/ex201.1.end",
    //"201.2.1":    "ex201/ex201.2.1",
    //"201.2.end":  "ex201/ex201.2.end",
    //"201.3.1":    "ex201/ex201.3.1",
    //"201.3.end":  "ex201/ex201.3.end",
    //"201.4.1":    "ex201/ex201.4.1",
    //"201.4.end":  "ex201/ex201.4.end",
    //"201.5.1":    "ex201/ex201.5.1",
    //"201.5.end":  "ex201/ex201.5.end",
    //"211.1.1":    "ex211/ex211.1.1",
    //"301.4.1":    "ex301/ex301.4.1",
    //"401.1.1":    "ex401/ex401.1.1",
    //"401.1.end":  "ex401/ex401.1.end",
    //"401.3.1":    "ex401/ex401.3.1",
    //"401.3.end":  "ex401/ex401.3.end",
    //"full_demo":  "full-demo,",
]

pipeline {
    agent any
    environment {
        maintainer = "t"
        imagename = 'g'
        tag = 'l'
    }
    stages {
        stage('Setting build context') {
            steps {
                script {
                    maintainer = maintain()
                    imagename = imagename()
                    if(env.BRANCH_NAME == "master") {
                       tag = "latest"
                    } else {
                       tag = env.BRANCH_NAME
                    }

                    if(!imagename){
                        echo "You must define an imagename in common.bash"
                        currentBuild.result = 'FAILURE'
                     }
                    sh 'mkdir -p tmp && mkdir -p bin'
                    dir('tmp'){
                      git([ url: "https://github.internet2.edu/docker/util.git", credentialsId: "jenkins-github-access-token" ])
                      sh 'rm -rf ../bin/*'
                      sh 'mv ./bin/* ../bin/.'
                    }
                }
             }
        }
        stage('Clean') {
            steps {
                script {
                   try{
                     sh 'bin/destroy.sh >> debug'
                   } catch(error) {
                     def error_details = readFile('./debug');
                     def message = "BUILD ERROR: There was a problem building the Base Image. \n\n ${error_details}"
                     sh "rm -f ./debug"
                     handleError(message)
                   }
                }
            }
        }
        stage('Build exerciseSets') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com/',   "dockerhub-${maintainer}") {
                        // def tagSet = generateTagSet()
                        // def builds = build(tagSet)

                        if(env.BRANCH_NAME == TARGET_BRANCH) {
                            //builds.each{ k, v -> echo ("push ${k}") } //for local testing
                            // builds.each{ k, v -> v.push(k) } <- not used anymore

                            EXERCISE_FOLDERS.each { exercise, folder ->
                                def build = docker.build("${maintainer}/${imagename}:${exercise}-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} ${folder}")
                                build.push("${exercise}-${tag}")
                            }
                        } else {
                            echo "not building images, since the SCM branch is not ${TARGET_BRANCH}"
                        }
                    }
                }
            }
        }
        stage('Notify') {
            steps{
                echo "$maintainer"
                slackSend color: 'good', message: "${maintainer}/${imagename} version ${tag} pushed to DockerHub"
            }
        }
    }
    post {
        always {
            echo 'Done Building.'
        }
        failure {
            // slackSend color: 'good', message: "Build failed"
            handleError("BUILD ERROR: There was a problem building ${maintainer}/${imagename} version ${tag}.")
        }
    }
}


def maintain() {
  def matcher = readFile('common.bash') =~ 'maintainer="(.+)"'
  matcher ? matcher[0][1] : 'tier'
}

def imagename() {
  def matcher = readFile('common.bash') =~ 'imagename="(.+)"'
  matcher ? matcher[0][1] : null
}

def handleError(String message){
  echo "${message}"
  currentBuild.setResult("FAILED")
  slackSend color: 'danger', message: "${message}"
  //step([$class: 'Mailer', notifyEveryUnstableBuild: true, recipients: 'chubing@internet2.edu', sendToIndividuals: true])
  sh 'exit 1'
}

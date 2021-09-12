
/** Builds images for the Grouper Training Env
 *  Each class has a set of images. Each class's image sets are independent, but within 
 *  a class each image builds upon the prior exercise. Therefore all images are built
 *  first and then push to the repo. Order of the build is important, but ordering of the 
 *  image pushes are not. If an image is missing the extra layers get pushed, then the
 *  missing layers only get tagged when they are pushed.
**/


/** Each class has a set of modules with a set of steps. 
 *  For examples, 101.1.1, 101.1.2, 101.1.3, 101.2.1, 101.2.2, etc.
 *  Each step is an associated docker image.
 *  exerciseSets has the class name and an array of the number of steps for module.     
**/
// TODO unused?
exerciseSets = ['101.1.1', ]

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
        stage('Build Base') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com/',   "dockerhub-${maintainer}") {
                        def baseImg = docker.build("${maintainer}/${imagename}:base-${tag}", "--no-cache --pull base")
                        baseImg.push("base-${tag}")
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

                        if(env.BRANCH_NAME == "202109") {
                            //builds.each{ k, v -> echo ("push ${k}") } //for local testing
                            // builds.each{ k, v -> v.push(k) } <- not used anymore
                            def exerciseFolders = [
                                "base":       "base",
                                "101.1.1":    "ex101/ex101.1.1",
                                "201.end":    "ex201/ex201.end",
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

                            exerciseFolders.each { exercise, folder ->
                                def build = docker.build("${maintainer}/${imagename}:${exercise}-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} ${folder}")
                                build.push("${exercise}-${tag}")
                            }

                            /*
                            def build = docker.build("${maintainer}/${imagename}:101.1.1-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} ex101/ex101.1.1")
                            build.push("101.1.1-${tag}")
                            
                            build = docker.build("${maintainer}/${imagename}:base-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} base")
                            build.push("base-${tag}")
                            
                            build = docker.build("${maintainer}/${imagename}:full_demo-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} full-demo/")
                            build.push("full_demo-${tag}")
                            
                            build = docker.build("${maintainer}/${imagename}:401.1.1-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} ex401/ex401.1.1")
                            build.push("401.1.1-${tag}")
                            
                            build = docker.build("${maintainer}/${imagename}:401.1.end-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} ex401/ex401.1.end")
                            build.push("401.1.end-${tag}")
                            
                            build = docker.build("${maintainer}/${imagename}:401.3.1-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} ex401/ex401.3.1")
                            build.push("401.3.1-${tag}")
                            
                            build = docker.build("${maintainer}/${imagename}:401.3.end-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} ex401/ex401.3.end")
                            build.push("401.3.end-${tag}")
                

                
                build = docker.build("${maintainer}/${imagename}:301.4.1-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} ex301/ex301.4.1")
                            build.push("301.4.1-${tag}")
                

                
                
                
                build = docker.build("${maintainer}/${imagename}:201.1.1-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} ex201/ex201.1.1")
                            build.push("201.1.1-${tag}")
                
                build = docker.build("${maintainer}/${imagename}:201.1.end-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} ex201/ex201.1.end")
                            build.push("201.1.end-${tag}")
                
                build = docker.build("${maintainer}/${imagename}:201.2.1-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} ex201/ex201.2.1")
                            build.push("201.2.1-${tag}")
                
                build = docker.build("${maintainer}/${imagename}:201.2.end-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} ex201/ex201.2.end")
                            build.push("201.2.end-${tag}")
                
                build = docker.build("${maintainer}/${imagename}:201.3.1-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} ex201/ex201.3.1")
                            build.push("201.3.1-${tag}")
                
                build = docker.build("${maintainer}/${imagename}:201.3.end-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} ex201/ex201.3.end")
                            build.push("201.3.end-${tag}")
                
                build = docker.build("${maintainer}/${imagename}:201.4.1-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} ex201/ex201.4.1")
                            build.push("201.4.1-${tag}")
                
                build = docker.build("${maintainer}/${imagename}:201.4.end-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} ex201/ex201.4.end")
                            build.push("201.4.end-${tag}")
                
                build = docker.build("${maintainer}/${imagename}:201.5.1-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} ex201/ex201.5.1")
                            build.push("201.5.1-${tag}")
                
                build = docker.build("${maintainer}/${imagename}:201.5.end-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} ex201/ex201.5.end")
                            build.push("201.5.end-${tag}")
        
                build = docker.build("${maintainer}/${imagename}:211.1.1-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} ex211/ex211.1.1")
                            build.push("211.1.1-${tag}")
                
                
                build = docker.build("${maintainer}/${imagename}:101.1.1-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} ex101/ex101.1.1")
                            build.push("101.1.1-${tag}")
                */
                
                /*
                build = docker.build("${maintainer}/${imagename}:-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} /")
                            build.push("-${tag}")
                
                
                build = docker.build("${maintainer}/${imagename}:-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} /")
                            build.push("-${tag}")
                
                
                build = docker.build("${maintainer}/${imagename}:-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} /")
                            build.push("-${tag}")
                
                
                build = docker.build("${maintainer}/${imagename}:-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} /")
                            build.push("-${tag}")
                
                
                build = docker.build("${maintainer}/${imagename}:-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} /")
                            build.push("-${tag}")
                
                
                
                
                */
                
                
                
                
                /*
                                build = docker.build("${maintainer}/${imagename}:-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} /")
                            build.push("-${tag}")
                                build = docker.build("${maintainer}/${imagename}:-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} /")
                            build.push("-${tag}")
                                build = docker.build("${maintainer}/${imagename}:-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} /")
                            build.push("-${tag}")
                                build = docker.build("${maintainer}/${imagename}:-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} /")
                            build.push("-${tag}")
                                build = docker.build("${maintainer}/${imagename}:-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} /")
                            build.push("-${tag}")
                                build = docker.build("${maintainer}/${imagename}:-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} /")
                            build.push("-${tag}")
                                build = docker.build("${maintainer}/${imagename}:-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} /")
                            build.push("-${tag}")
                                build = docker.build("${maintainer}/${imagename}:-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} /")
                            build.push("-${tag}")
                                build = docker.build("${maintainer}/${imagename}:-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} /")
                            build.push("-${tag}")
                                build = docker.build("${maintainer}/${imagename}:-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} /")
                            build.push("-${tag}")
                                build = docker.build("${maintainer}/${imagename}:-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} /")
                            build.push("-${tag}")
                                build = docker.build("${maintainer}/${imagename}:-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} /")
                            build.push("-${tag}")
                                build = docker.build("${maintainer}/${imagename}:-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} /")
                            build.push("-${tag}")
                                build = docker.build("${maintainer}/${imagename}:-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} /")
                            build.push("-${tag}")
                                build = docker.build("${maintainer}/${imagename}:-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} /")
                            build.push("-${tag}")
                                build = docker.build("${maintainer}/${imagename}:-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} /")
                            build.push("-${tag}")
                
                
                build = docker.build("${maintainer}/${imagename}:-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} /")
                            build.push("-${tag}")
                
                build = docker.build("${maintainer}/${imagename}:$i-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} $i/$i")
                            build.push("$i-${tag}")
                
                build = docker.build("${maintainer}/${imagename}:401.3.end-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} ex401/ex401.3.end")
                            build.push("401.3.end-${tag}")
                
                
                build = docker.build("${maintainer}/${imagename}:401.3.end-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} ex401/ex401.3.end")
                            build.push("401.3.end-${tag}")
                
                build = docker.build("${maintainer}/${imagename}:401.3.end-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} ex401/ex401.3.end")
                            build.push("401.3.end-${tag}")
                */
                
                
                /*
                docker pull "tier/gte:401.3.end-$GROUPER_GTE_DOCKER_BRANCH"
                docker pull "tier/gte:401.3.1-$GROUPER_GTE_DOCKER_BRANCH"
                docker pull "tier/gte:401.1.end-$GROUPER_GTE_DOCKER_BRANCH"
                docker pull "tier/gte:401.1.1-$GROUPER_GTE_DOCKER_BRANCH"
                docker pull "tier/gte:301.4.1-$GROUPER_GTE_DOCKER_BRANCH"
                docker pull "tier/gte:211.1.1-$GROUPER_GTE_DOCKER_BRANCH"
                docker pull "tier/gte:201.5.end-$GROUPER_GTE_DOCKER_BRANCH"
                docker pull "tier/gte:201.5.1-$GROUPER_GTE_DOCKER_BRANCH"
                docker pull "tier/gte:201.4.end-$GROUPER_GTE_DOCKER_BRANCH"
                ocker pull "tier/gte:201.4.1-$GROUPER_GTE_DOCKER_BRANCH"
                docker pull "tier/gte:201.3.end-$GROUPER_GTE_DOCKER_BRANCH"
                docker pull "tier/gte:201.3.1-$GROUPER_GTE_DOCKER_BRANCH"
                docker pull "tier/gte:201.2.end-$GROUPER_GTE_DOCKER_BRANCH"
                docker pull "tier/gte:201.2.1-$GROUPER_GTE_DOCKER_BRANCH"
                docker pull "tier/gte:201.1.end-$GROUPER_GTE_DOCKER_BRANCH"
                docker pull "tier/gte:201.1.1-$GROUPER_GTE_DOCKER_BRANCH"
                docker pull "tier/gte:101.1.1-$GROUPER_GTE_DOCKER_BRANCH"
                docker pull "tier/gte:full_demo-$GROUPER_GTE_DOCKER_BRANCH"
                docker pull "tier/gte:base-$GROUPER_GTE_DOCKER_BRANCH"
                
                
                
                
                            def build = docker.build("${maintainer}/${imagename}:101.1.1-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} ex101/ex101.1.1")
                            build.push("101.1.1-${tag}")

                            build = docker.build("${maintainer}/${imagename}:211.1.1-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} ex211/ex211.1.1")
                            build.push("211.1.1-${tag}")

                            build = docker.build("${maintainer}/${imagename}:301.4.1-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} ex301/ex301.4.1")
                            build.push("301.4.1-${tag}")
                        
                            build = docker.build("${maintainer}/${imagename}:full_demo-${tag}", "--no-cache --pull --build-arg VERSION_TAG=${tag} full-demo")
                            build.push("full_demo-${tag}")
                */

                        } else {
                            echo 'not building images, since the SCM branch is not 202109'
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

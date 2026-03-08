Solution :

1 -- Login into Jenkins UI and go to Manager Jenkins

2 -- Plugins ----------> Available Plugins ---------> Pipeline

3 -- Create a pipeline job named ""

4 -- In pipeline script tab add this script

```
pipeline {
    agent any

    stages {
        stage('Deploy') {
            steps {
                script {
                    echo "Deploying latest code to Storage Server..."

                    sh """
                    sshpass -p 'Bl@kW' ssh -o StrictHostKeyChecking=no natasha@ststor01 'cd /var/www/html && git pull origin master'
                    """
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    echo "Testing application using curl..."
                    def url = "http://stlb01:8091"

                    sh """
                    STATUS=\$(curl -o /dev/null -s -w "%{http_code}" ${url})
                    if [ "\$STATUS" -ne 200 ]; then
                        echo "Application test FAILED with HTTP status \$STATUS"
                        exit 1
                    else
                        echo "Application test SUCCESSFUL: HTTP \$STATUS"
                    fi
                    """
                }
            }
        }
    }
}
```

5 -- Build now

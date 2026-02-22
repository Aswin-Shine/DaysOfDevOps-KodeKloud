A new DevOps Engineer has joined the team and he will be assigned some Jenkins related tasks. Before that, the team wanted to test a simple parameterized job to understand basic functionality of parameterized builds. He is given a simple parameterized job to build in Jenkins. Please find more details below:

Click on the Jenkins button on the top bar to access the Jenkins UI. Login using username admin and password Adm!n321.

1. Create a parameterized job which should be named as parameterized-job
2. Add a string parameter named Stage; its default value should be Build.
3. Add a choice parameter named env; its choices should be Development, Staging and Production.
4. Configure job to execute a shell command, which should echo both parameter values (you are passing in the job).
5. Build the Jenkins job at least once with choice parameter value Production to make sure it passes.

Solution :

1. Login into Jenkins Server

2. Create a new project and name it as parameterized-job (Freestyle Project)

3. Choose option "This Project is Parameterized" & add Parameter name Stage with deafault value Build (String Parameter) and add Parameter name env with Values Staging,Development,Production (Choice Parameter)

4. In Build Steps choose excute shell & and this shell command

```
echo $Stage $env
```

5. Build with parameters

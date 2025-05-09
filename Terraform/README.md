# Terraform


This terraform creates enough infrastructure for the demo application to
function

It will create:

* Networking
* NAT services
* IAM accounts
* Storage buckets for Configuration management and scripts
* Instance groups to manage rabbitMQ 
* Postgresql server for data storage
* Internal DNS records for services


Once this has been provisioned the frontend can be deployed to this project and
run from there.



## Variables

Variables are defined in the `vars.tf` file and should be altered by using the
files contained within the `env` directory as per the environment name

for example:
if the environment you're working with is `test` you'd need to apply your
values to the `env/test.tfvars` file


## Running terraform

All terraform operations are wrapped in a `Makefile` but still follow the
standard terraform process of `init` `plan` and `apply`.

The `destroy` option is available but should be disabled 

The `ENV` variable must be provided to all terraform commands


### Init

This command will initialise the local terraform environment:

```
make ENV=test init
```


### Planning

THis command with initiate a plan of the resources or changes you'd need to
make to the project:

```
make ENV=test plan
```

The resulting plan will be saved to a file named `PLAN-<ENV>.TFPLAN`


### Applying

The saved plan from the planning step above can be applied to the project with
the following command


```
make ENV=test apply
```


## Clean up

When switching between environments or to clean up the working directory
a clean can be performed:

```
make clean
```

This will remove the `.terraform` directory, old plan files and any stray state
files.
Once a clean has been performed you will need to re-run an `init` with your
preferred settings


## Caveats

The Makefile setup assumes you have control of all Google Cloud project ID's in
a certain format. i.e. `example-<ENV>` or `example-<ENV>-app`

As this is a demonstration the variable `GCP_PROJECT_ID` will likely need to be
provided on the command line to override this behaviour, for example:

```
make ENV=test GCP_PROJECT_ID=example-test plan
```

Additionally the value has been omitted from the tfvars files in the `env`
directory

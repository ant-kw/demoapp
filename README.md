# Messaging Application Demo 

This Repo contains an outline of a demonstration app that makes use of
activemq/pubsub messaging to make requests of a database via an agent


```
   Front end <----> RabbitMQ <----> Backend Agent <----> Database

```

## Tooling and resources

To help deploy this the following tooling has been used:

### Google Cloud Platform

GCP has been chosen for this application deployment due to prior experience

### Compute instances

Compute instances have been chosen here to deploy the RabbitMQ service.
Additionally the Postgresql server could also be deployed in to an instance
depending on available budget and requirements.

### Terraform

Terraform is used to deploy and configure services to Google Cloud.
It manages the contents of the Google Cloud project and crates networking,
storage, instances and a database server.

Its deployment method is easily adapted to multiple projects.

### Packer

To allow for the possibility of multiple deployment options packer has been
configured to build potential images for front end and a database servers where
managed services may not be used.

### Containers

Containers have been used to help with building tools and enabling deployment
options for the front and backends.

For the front end and back ends the resulting containers can be used to deploy
the aplication directly to AppEngine on Google Cloud.

### Make

GNU Make has been used to help manual runs of of processes for the purposes of
the demonstration and enables templated commands for each step.



## Monitoring

To ensure proper operation of this deployment items will need to be monitored.

### Back end and front end

In the example this would be deployed to AppEngine where stats can be gathered
and reported on in the metrics explorer. The tool can also be configured to
alert on certain conditions such as latency and response times.

### RabbitMQ

The service is deployed in to an instance in this demo.
Standard monitoring can be deployed here for basic monitoring ( is the service
up etc ) Additional monitoring of the service would be needed here so
prometheus should be deployed to monitor the internal statistics of the server.

Additional monitoring would also need to be put in place to support HA
operations such as failover.

### Postgresql

In this demo the server is deployed as a managed service. Stats from the
deployment can be accessed via the metrics explorer and alerts be placed on
certain metrics. Should the server fail google will work to bring this back up
automatically. Its recommended that an additional replica also be deployed to
assist with HA of the service.


## Deployment

To deploy this demo terraform would first need to be deployed to a project
within GCP.

Once this has been deployed the front end and back end applications would need
to be deployed 

Most of the deployment here is performed via manual command line steps for the
purposes of demonstration.

For live setups the deployment of the front and back end software would be
performed via a CI/CD pipeline where packages can be built automatically on
code commits.

Some examples of this are present in the front and back end where github
actions can be triggered when a new release is created.



## Testing

Testing of the stack can be performed locally by use of containers built and
deployed via docker compose

This would allow a local testing environment but may be lacking in more
advanced networking options such as firewalling.



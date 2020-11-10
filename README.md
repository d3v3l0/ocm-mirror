# Self-hosted Open Charge Map (OCM) Mirror without API rate limitations...
..., forked from the official [**openchargemap/ocm-system**](https://github.com/openchargemap/ocm-system/) project.

**Background**: As per [Issue `#161/api-keys-are-now-required`](https://community.openchargemap.org/t/api-keys-are-now-required/161) the **official** API endpoint got **rate limited**.

This fork **mirrors** official OCM API `https://api-01.openchargemap.io/v3/{poi, ...}`.

It is deployable in the Cloud or in a local developer's environment via `docker-compose`.

After start, the [OCM.API.Worker](./API/OCM.Net/OCM.API.Worker/) will regularly synchronize fresh POI data from the [official master API - https://api-01.openchargemap.io/v3/...](https://api-01.openchargemap.io/v3/) (**every** `300 seconds`).


Courtesy by [@LHaferkamp](https://github.com/LHaferkamp).

For more information see [CS Reply Confluence](https://confluence.comsysto.com/display/DEEP/Self-hosted+OpenChargeMap%28OCM%29+Mirror).


## Development: local installation on developers laptop
Prerequisites: Docker is installed an running.

* Clone this project:
```shell
git clone https://github.com/comsysto/ocm-mirror
```

* Build and launch the required Docker containers with `docker-compose`:
```shell
cd ocm-mirror

docker-compose up

```


----
----
----


# Official docs...

Open Charge Map (OCM)
==========

### About the project

[Open Charge Map](https://openchargemap.org) is the global public registry of electric vehicle charging locations.
OCM was first established in 2011 and aims to crowdsource a high quality, well maintained open data set with the greatest breadth possible. Our data set is a mixture of manually entered information and imported open data sources (such as government-run registries and charging networks with an open data license). OCM provides data to drivers (via hundreds of apps and sites), as well to researchers, EV market analysts, and government policy makers. 

The code in this repository represents the backend systems ([API](https://openchargemap.org/site/develop/), [Web Site](https://openchargemap.org) and server-side import processing) for the project. Server-side code is developed mostly in C#, currently building under Visual Studio 2019 Community Edition with .Net Core 3.1, Data is primarily stored in SQL Server, using Entity Framework Core, with an additional caching layer using MongoDB. Most API reads are services by the MongoDB cache.

Developers can use our [API](https://openchargemap.org/site/develop/) to access the data set and build their own [apps](https://openchargemap.org/site/develop/apps/). The map [app](https://map.openchargemap.io) source (using latest Ionic/Angular/TypeScript) can be found in its own repo at https://github.com/openchargemap/ocm-app


### Basic build prerequisites

- dotnet core 3.1 sdk (windows/linux)

### Deployment 

 - Configure MongoDB as services and initialise ocm_mirror database
 - Enable read/write for app pool user for \Temp folders
 - Configure web.config

 To run an API mirror, see the OCM.API.Worker readme.

### Contributing

Please contribute in any way you can:
  - Improve the data (anyone can do this):
    - Submit comments, checkins, and photos via the website
    - Submit new data, become an editor for your country
  - Grow the user base
    - Advocacy, tell people about [Open Charge Map](https://openchargemap.org) and help them use it.
  - Improve the system:
    - Help translate the system into other languages using the [webtranslateit](https://webtranslateit.com/en/projects/6978-Open-Charge-Map) project 
    - Help write documentation
    - Web App (HTML/CSS/JavaScript)
    - Website development (MVC)
    - Map widget for embedding
    - Sample Code for developers
    - Graphic Design
    - Testing



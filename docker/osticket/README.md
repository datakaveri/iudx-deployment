# osTicket Docker Setup

This directory contains the Docker configuration for setting up osTicket with OAuth2 integration.

## Overview

The Dockerfile sets up osTicket, an open-source support ticket system, with the following features:
- PHP 8.2 with Apache
- OAuth2 authentication plugin
- Required PHP extensions and dependencies

## Prerequisites

- Docker
- Docker Compose (if using docker-compose.yml)
- Git

## Components

The setup includes:
1. Base PHP 8.2 Apache image
2. Required system dependencies
3. PHP extensions (intl, xml, gd, mysqli, zip, opcache)
4. osTicket core installation
5. OAuth2 plugin

## Building the Image

To build the Docker image:

```bash
docker build -t osticket:latest .
```

## Configuration

The setup requires configuration of the following:

1. osTicket configuration file (`ost-config.php`)
2. OAuth2 plugin settings

## Usage

### Running the Container

```bash
docker run -d \
  -p 80:80 \
  -v osticket-data:/var/www/html/include \
  --name osticket \
  osticket:latest
```

### Environment Variables

The following environment variables can be configured:

- `OSTICKET_DB_HOST`: Database host
- `OSTICKET_DB_NAME`: Database name
- `OSTICKET_DB_USER`: Database user
- `OSTICKET_DB_PASSWORD`: Database password

## Directory Structure

```
/var/www/html/
├── include/
│   ├── plugins/
│   │   └── auth-oauth2/
│   └── ost-config.php
└── ... (other osTicket files)
```

## Security Considerations

- The `ost-config.php` file is set to 0666 permissions for initial setup
- After configuration, consider changing the permissions to be more restrictive
- Ensure proper SSL/TLS configuration for production use
- Keep the system and dependencies updated

## Troubleshooting

Common issues and solutions:

1. Permission issues: Ensure proper ownership of files (www-data:www-data)
2. Plugin activation: Check plugin installation in the admin panel
3. OAuth2 configuration: Verify settings in the plugin configuration

## License

This setup is based on osTicket which is released under the GPL v2 license. 
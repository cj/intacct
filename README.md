# Intacct

This gem provides a Ruby wrapper for the Intacct API.

## Installation

Add this line to your application's Gemfile:

    gem 'intacct', github: 'mavenlink-solutions/intacct-ruby', branch: 'mavenlink'

And then execute:

    $ bundle


## Configuration

There are two ways to approach configuration.

1) Add credentials to the `Intacct` module

    Intacct.configure do |config|
        config.xml_sender_id = ...
        config.xml_password  = ...
        config.user_id       = ...
        config.password      = ...
        config.company_id    = ...
    end
    
Then, when instantiating an `Intacct::Client` no arguments are necessary

    client = Intacct::Client.new
    
2) Provide credentials when instantiating an `Intacct::Client`
    
    client = Intacct::Client.new(xml_sender_id: ..., xml_password: ..., user_id: ..., password: ..., company_id: ...)
    
## Supported Objects

Currently, the following objects are supported:

- Class (named ClassDimension) (read-only)
- Department (read-only)
- Employee (read-only)
- Expense
- Location (read-only)
- Project
- Project Status (read-only)
- Project Type (read-only)
- Task
- Timesheet


## Usage
    
Creating a new project

    project = client.projects.build(name: "New Project", projectcategory: "Contract")
    project.create
    
Fetching a project
    
    project = client.projects.read(key: PROJECT_ID)
    
Updating a project
    
    project.name = "Updated Project"
    project.update
    
Querying
    
    client.projects.read_by_query(query: QUERY STRING)

## Bulk Creating Records

This library provides a class method to create multiple records of a single type (e.g. Project) in one transaction.

    bulk_attributes = [ {name: "Project 1", projectcategory: "Contract"}, 
                        {name: "Project 2", projectcategory: "Contract"} ]

    client.projects.bulk_create(bulk_attributes)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

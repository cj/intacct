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

## Usage
    
Creating a new project

    project = client.projects.build(name: "New Project", project_category: "Contract")
    project.create
    
Fetching a project
    
    project = client.projects.get(key: PROJECT_ID)
    
Updating a project
    
    project.name = "Updated Project"
    project.update
    
Querying
    
    client.projects.read_by_query(query: QUERY STRING)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

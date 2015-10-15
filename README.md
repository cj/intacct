# Intacct

This gem provides a Ruby wrapper for the Intacct API.

## Installation

Add this line to your application's Gemfile:

    gem 'intacct-ruby'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install intacct-ruby

## Usage

Create a new instance of `Intacct::Client` with credentials
    
    client = Intacct::Client.new(xml_sender_id: ..., xml_password: ..., user_id: ..., password: ..., company_id: ...)
    
Creating a new project

    project = client.projects.build(name: "New Project", project_category: "Contract")
    project.create
    
Fetching a project
    
    project = client.projects.get(PROJECT_ID)
    
Updating a project
    
    project.name = "Updated Project"
    project.update

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

#!/usr/bin/env ruby

require 'rubygems'
require 'activerecord'
require 'activesupport'
require 'activeresource'
require 'lighthouse'
require 'fastercsv'

# Configure Me... #####################################################
 
# Enter your Lighthouse account and token. The token must have both
# read & write access.
Lighthouse.account = 'ACCOUNT_NAME'
Lighthouse.token = 'TOKEN'

# Your Lighthouse Project ID
PROJECT_ID = 12345

def save_to_lighthouse(record)
  t = Lighthouse::Ticket.new(:project_id => PROJECT_ID,
                             :title => record['title'],
                             :body => record['description'],
                             :state => record['state'],
                             :milestone_id => record['milestone'])  
  p record['title']
  t.tags << taggify(record['tags'])
  t.save
  t
end

def taggify(s)
  return "" if s.nil?
  s.downcase.gsub(/[^a-z0-9\-_@\!' ]/,'').strip
end

def import(fname)
  FasterCSV.foreach(fname, :headers => :first_row) do |row|
    save_to_lighthouse(row)
  end
end

unless ARGV.length > 0
  puts "No file specified."
  Process.exit(1)
else
  import(ARGV[0])
end
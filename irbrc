#!/usr/bin/env ruby

def ignore_exception
  begin
    yield
  rescue Exception
  end
end

blah
ignore_exception { require 'irb/completion' }
ignore_exception { require 'rubygems' }
ignore_exception { require 'pp' }
ignore_exception { require 'awesome_print' }

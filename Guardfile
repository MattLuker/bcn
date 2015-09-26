# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
# directories %w(app lib config test spec features) \
#  .select{|d| Dir.exists?(d) ? d : UI.warning("Directory #{d} does not exist")}

## Note: if you are using the `directories` clause above and you are not
## watching the project directory ('.'), then you will want to move
## the Guardfile to a watched dir and symlink it back, e.g.
#
#  $ mkdir config
#  $ mv Guardfile config/
#  $ ln -s config/Guardfile .
#
# and, you'll have to watch "config/Guardfile" instead of "Guardfile"

## Example 1: Run a single command whenever a file is added
#
#notifier = proc do |title, _, changes|
#  Guard::Notifier.notify(changes * ",", title: title )
#end
#
#guard :yield, { run_on_additions: notifier, object: "Add missing specs!" } do
#  watch(/^(.*)\.rb$/) { |m| "spec/#{m}_spec.rb" }
#end
#
## Example 2: log all kinds of changes
#
#require 'logger'
#yield_options = {
#  object: ::Logger.new(STDERR), # passed to every other call
#
#  start: proc { |logger| logger.level = Logger::INFO },
#  stop: proc { |logger| logger.info "Guard::Yield - Done!" },
#
#  run_on_modifications: proc { |log, _, files| log.info "!! #{files * ','}" },
#  run_on_additions: proc { |log, _, files| log.warn "++ #{files * ','}" },
#  run_on_removals: proc { |log, _, files| log.error "xx #{files * ','}" },
#}
#
#guard :yield, yield_options do
#  watch(/^(.*)\.css$/)
#  watch(/^(.*)\.jpg$/)
#  watch(/^(.*)\.png$/)
#end

# Any files created or modified in the 'source' directory
# will be copied to the 'target' directory. Update the
# guard as appropriate for your needs.

guard :copy, :from => '_drafts/Draft', :to => './_drafts' do
  watch(%r{^(.*)})
end

guard 'process', :name => 'git_commit', :command => './git_commit.rb' do
  watch %r{_drafts/(.*)}
end

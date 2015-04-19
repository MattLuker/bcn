# lib/tasks/sample_data.rake
namespace :db do
  desc 'Drop, create, migrate, seed and populate sample data'
  task prepare: [:drop, :create, :migrate, :seed, :populate_sample_data] do
    puts 'Ready to go!'
  end

  desc 'Populates the database with sample data'
  task populate_sample_data: :environment do
    User.create!({email: 'adam@example.com', password: 'beans'})
    User.create!({email: 'bob@example.com', password: 'barns'})
    User.create!({email: 'cheese@example.com', password: 'beans'})

    Location.create({lat: 36.2168215386211, lon: -81.682448387146})
    Location.create({lat: 36.21991, lon: -81.68261})
    Location.create({lat: 36.22066499490376, lon: -81.67625516653061})

    Community.create({name: 'Boone Community Network',
                      description: 'We are all part of the Boone community!',
                      home_page: 'http://boonecommunitynetwork.com',
                      color: '#333333'
                     })
    Community.create({name: 'Coffee Lovers',
                      description: 'We all love coffee!!',
                      home_page: 'http://www.reddit.com/r/coffee',
                      color: '#4D4444'
                     })

    Post.create({title: 'Testing',
                 description: 'Doing some testing...',
                 user: User.find(1),
                 location: Location.find(1),
                 communities: [Community.find(1)]
                })
    Post.create({title: 'Posty Post Post',
                 description: 'Doing some posting...',
                 user: User.find(2),
                 location: Location.find(3),
                 communities: [Community.find(1)]
                })
    Post.create({title: 'Woo Woo',
                 description: 'Doing some woo wooing...',
                 user: User.find(3),
                 location: Location.find(3),
                 communities: [Community.find(2)]
                })


  end
end
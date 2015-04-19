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
    User.create!({email: 'cheese@example.com', password: 'brains'})

    Location.create({lat: 36.2117382055093,
                     lon: -81.6856241226196,
                     name: 'Kidd Brewer Stadium',
                     address: '1 Stadium Drive',
                     city: 'Boone',
                     state: 'North Carolina',
                     postcode: '28608',
                     county: 'Watauga County',
                     county: 'United States of America'
                    })
    Location.create({lat: 36.2165856654217,
                     lon: -81.686224937439,
                     name: 'Student Recreation Center',
                     address: 'Bodenheimer Drive',
                     city: 'Boone',
                     state: 'North Carolina',
                     postcode: '28608',
                     county: 'Watauga County',
                     county: 'United States of America'
                    })
    Location.create({lat: 36.2165099261701,
                     lon: -81.6720628738403,
                     name: 'East King Street',
                     address: 'East King Street',
                     city: 'Boone',
                     state: 'North Carolina',
                     postcode: '28608',
                     county: 'Watauga County',
                     county: 'United States ogf America'
                    })


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
                 location: Location.find(2),
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
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

    # User.create!({
    #                  first_name: 'Adam',
    #                  last_name: 'Sommer',
    #                  email: 'adam.sommer_fb@placeholder.boonecommunitynetwork.com',
    #                  username: 'adam.sommer_fb@placeholder.boonecommunitynetwork.com',
    #                  password: (0...50).map { ('a'..'z').to_a[rand(26)] }.join,
    #                  facebook_id: '10152906515550983',
    #                  photo: 'https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xap1/v/t1.0-1/c8.0.50.50/p50x50/12126_10152015144330983_923593965_n.jpg?oh=10f722bb1455eb8bad4d7a1116848e15&oe=55DD2BCC&__gda__=1440143610_10f5ba52241c58e81d096f22909f89f8'
    #              })

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
                 locations: [Location.find(1)],
                 communities: [Community.find(1)]
                })
    Post.create({title: 'Posty Post Post',
                 description: 'Doing some posting...',
                 user: User.find(2),
                 locations: [Location.find(2)],
                 communities: [Community.find(1)]
                })
    Post.create({title: 'Woo Woo',
                 description: 'Doing some woo wooing...',
                 user: User.find(3),
                 locations: [Location.find(3)],
                 communities: [Community.find(2)]
                })


  end
end
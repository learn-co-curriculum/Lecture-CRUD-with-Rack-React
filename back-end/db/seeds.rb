puts "Clearing old data..."
Toy.destroy_all

puts "Seeding Toys..."

Toy.create(name: "Woody",image: "http://www.pngmart.com/files/3/Toy-Story-Woody-PNG-Photos.png",likes: 9)
Toy.create(name: "Buzz Lightyear",image: "http://www.pngmart.com/files/6/Buzz-Lightyear-PNG-Transparent-Picture.png",likes: 11)
Toy.create(name: "Mr. Potato Head",image: "https://vignette.wikia.nocookie.net/universe-of-smash-bros-lawl/images/d/d8/Mr-potato-head-toy-story.gif/revision/latest?cb=20151129131217",likes: 3)
Toy.create(name: "Slinky Dog",image: "https://www.freeiconspng.com/uploads/slinky-png-transparent-1.png",likes: 4)
Toy.create(name: "Rex",image: "http://umich.edu/~chemh215/W11HTML/SSG5/ssg5.2/FRex.png",likes: 1)
Toy.create(name: "Bo Peep",image: "http://4.bp.blogspot.com/_OZHbJ8c71OM/Sog43CMFX2I/AAAAAAAADEs/0AKX0XslD4g/s400/bo.png",likes: 2)
Toy.create(name: "Hamm",image: "https://cdn140.picsart.com/244090226021212.png?r1024x1024",likes: 0)
Toy.create(name: "Little Green Men",image: "http://www.pngmart.com/files/3/Toy-Story-Alien-PNG-File.png",likes: -2)

puts "Done!"
# Lecture - CRUD with Rack & React

## Objectives

- [] Understand how rack server is create
- [] Understand rack server and react fron-end is connected

## Outline

```
5 min - Activation - What is a rack server?
5 min - Installation - JSON server and show demo for Toy Tale lab
10 min - Demonstration - Create migrations, model, and seed data
10 min - Demonstration - Create rack server GET route to send all toys from database and test using POSTMAN
15 min - Demonstration - Create rack server routes for POST, PATCH, and DELETE requests and test using POSTMAN
10 min - Demonstration - Make fetch request to rack server from front-end
---
55 min
```
## What is a rack server?

Rack is one of the easiest tools that we can use to build a web server and it's what web server frameworks like Rails and Sinatra use to take in requests and send responses back.

The first that we need for our application is a new directory, and in that directory we'll need a `Gemfile` which will load the `rack` gem into our project.

The second thing that we need is a `config.ru` file. This file tells Rack how to run our webserver. It is both configuration and executable code. We will use it to tell Rack how to start our web application. In this file, we will require the `rack` gem. Let's leave this here while we set up our actual application.

The third thing that we need to do is to create an `app.rb` file which will hold all of our business logic \(meaning the logic that the server will use to receive and respond to requests\). Create an `App` class with a `call` instance method that accepts an environment hash and returns an array of a status code \(as a number or string\), some headers \(as a hash\), and a body \(as an enumerable\).

Lastly, we will require the `app.rb` file in our `config.ru` file and add the line `run App.new`. Now our application is ready to run, so we'll go to our Terminal and use the `rackup` command to run the server and navigate to `localhost:9292`.

> **Note:** Talk about what localhost means and where that address actually points to. Here's also a good place to bring back up the port in the URI. And lastly, bring up the `shotgun` gem and add it to the Gemfile to get automatic server restarts on file changes in the current directory.

Inspect the environment hash by printing it to the console. This is hard to read, so we can use a utility provided by Rack to get some more context. Create a new variable in the `App#call` method called `req` and set it equal to `Rack::Request.new(<your environment hash variable>)`.

Now we can inspect the path with `req.path`, use conditionals to respond to different types of paths with the match method `req.path.match("/")`, write a basic template as the body of the response with HTML, take student suggestions and play around. This is the beginning of actual web development!

## Demo - using JSON server

`cd front-end` folder and run `json-server --watch db.json`

start react app: `npm i && npm start`

Show CRUD with the app:
- Show all toys
- Create a new Toy
- Update toy likes
- Delete/Donate a toy

## Create migrations, model, and seed data

`cd back-end` folder

Create migration:

`rake db:create_migration NAME=create_toys_table`

```ruby
# create_toys_table.rb
class CreateToysTable < ActiveRecord::Migration[5.2]
  def change
    create_table :toys do |t|
      t.string :name
      t.string :image
      t.integer :likes
    end
  end
end
```
Create model:

```ruby
# /app/models/toy.rb
class Toy < ActiveRecord::Base
    
end
```

Seed data:

```ruby
# seeds.rb
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
```

` rake db:seed `

## Create rack server GET route to send all toys from database and test using POSTMAN

```ruby
# /app/application.rb

if req.path.match(/toys/) && req.get?

      toys = Toy.all
      return [200, { 'Content-Type' => 'application/json' }, [ {:toys => toys}.to_json ]]

```

Explain:
- `req.path.match` and `req.get?` returns `true`
- response status code and data send with the response

Open POSTMAN: send `GET` request to `http://localhost:9393/toys` and show response

## Create rack server routes for POST, PATCH, and DELETE requests and test using POSTMAN

```ruby
# /app/application.rb
elsif req.path.match(/toys/) && req.post?

    data = JSON.parse req.body.read
    toy = Toy.create(data)
    return [200, { 'Content-Type' => 'application/json' }, [ {:toy => toy}.to_json ]]

elsif req.path.match(/toys/) && req.patch?

    id = req.path.split("/toys/").last
    toy = Toy.find(id)
    data = JSON.parse req.body.read
    toy.update(data)
    return [200, { 'Content-Type' => 'application/json' }, [ {:toy => toy}.to_json ]]

elsif req.delete?

    id = req.path.split("/toys/").last
    Toy.find(id).delete
    return [200, { 'Content-Type' => 'application/json' }, [ {:message => "Toy donated!"}.to_json ]]
```

from POSTMAN test your code!

## Make fetch request to rack server from front-end

Change URL from fetch requests:

```js
// App.js
    URL = "http://localhost:9393/toys"
```

They way we are sending response back we need to go inside the nested object to retrive the needed data. See below:

```js
// App.js

// GET request for all toys
fetch(URL)
.then(res => res.json())
.then(toyData => {
    this.setState({
    toys: toyData.toys
    })
})

// POST request to create a new toy
let newToy = {
    name: event.target.name.value,
    image: event.target.image.value,
    likes: 0
}

let reqPackage = {
    headers: {"Content-Type":"application/json"},
    method: "POST",
    body: JSON.stringify(newToy)
}

fetch(URL, reqPackage)
.then(res => res.json())
.then(data => {
this.setState({
    toys: [...this.state.toys, data.toy],
    display: !this.state.display
})
})

// PATCH request to like a toy
let updateToy = {likes: toyLike.likes+1}
let reqPackage = {
    headers: {"Content-Type":"application/json"},
    method: "PATCH",
    body: JSON.stringify(updateToy)
}

fetch(`${URL}/${toyLike.id}`, reqPackage)
.then(res => res.json())
.then(data => {
    this.setState({
    toys: [...this.state.toys.map(toy => toy.id === data.toy.id ? data.toy : toy)]
    })
})

// DELETE request to donate a toy
fetch(`${URL}/${toyDelete.id}`, {
    method: "DELETE",
})
.then(res => res.json())
.then(() => {
    this.setState({
    toys: this.state.toys.filter(toy => toy !== toyDelete)
    })
})
```

## NOTE: The response from rack server might be very slow since a lot of database operations are happening which requires more time. However, mention to the students once we start using rails the application would be much more faster.
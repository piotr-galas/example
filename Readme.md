In repository there are two different application.
 
###app_front 

This is asset part of rails application. It is my private clint and I am spending about 5h per week ,
 for that reason code isn't  perfect, also I dont write tests in jasmine. 
 Main part of application is integration with google map. It allows administrator to plan route based on
 zip code and street. Application add few customization. My role in this project is full stack
 
###app_bacend
 
This is application write be team
* 2 person - angular client
* 1-2 - rails api
* 2 - php application
 
 
I started rails application alone, after first 6 months another rails developer came.
Code in this repository i almost 100% written by me and It is related with one domain object Auction.
I didnt change directory of rails structure.
In project i decide to implement all buisnes logic in /lib folder.

Advantages of that purpose is faster run single test. Rails load only necessary files instead of all application.
Disadvantages is we need to restart server every time when we change something. But if we write code started by test like TDD
it is not big minus.
Some guys think that it is antipattern and in /lib directory we should only include class that are pretend to be a gem.
After digging and read few articles about I think that better place to domain objects is /service directory. But I dont think 
refactor this app is necessary.

In acceptance test I use : rspec_api_documentation gem + apitome gem
It change syntax of rspec DLL a little, but allow automatically generate API documentation.
 
Please take a look at /lib/failure.rb, /lib/success.rb, /lib/result.rb  I included below a part of documentation written by me.

Of course i can code more standard rails approach but If I can decide iI prefer below solution 


***

#dci

[Wpis o dci](http://mikepackdev.com/blog_posts/24-the-right-way-to-code-dci-in-ruby)

Jesli logika jest bardziej skomplikowana to w controllerach zamiast wywolywac model, wywolujemy odpowiedni service.
```ruby
  def confirmation_email
    result = UserManagement::EmailConfirmation.new(params).execute
    result.success { |login_success_url| redirect_to login_success_url }
    result.invalid { |login_invalid_url| redirect_to login_invalid_url }
    result.invalid_api { |error_message| render json: error_message, status: :service_unavailable }
  end
```
`lib/result.rb`, `lib/failure.rb`, `lib/result.rb` odpowiadaja za logike. Metoda `execute` musi zwracac jendo z ponizszych:

```ruby
Failure.new(:invalid, failure_url)
Failure.new(:invalid_api, user_api.error_message)
Success.new(success_url)
```

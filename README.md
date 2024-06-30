# SlotMachine

This is the project meant to simulate and solve the available slot issue.  
It contains the models and unit tests necessary to test the specific cases of the exercise

## Installation

The tests of this repository require rspec  
I used bundler to manage the gems of this project

## Note about lucifer

Two json file were provided for this exercise, I added another one (lucifer)  
I feared an oversight on my part midway through the writing of this code about the simulated return of the API, notably the API returning overlapping slots, which made most of my work useless by that point.  
I noticed afterwards that none of the files provided were actually simulating that behavior and that my worries were unwarranted (in this exercise's framework).

Given I still had developped a solution for this issue, I decided to add another file simulating this.
It is probably outside the scope of the exercise and serves as a vanity piece. It can be disregarded.

# Description of the Models

## GetCalendar service (lib/slot_machine/services/calendar_stub.rb)

This model mocks the API call, it takes the name of a user and returns a json containing all the appointement of that user. The user name serves as an identifier, but in a more serious context, an uuid would have been sent instead.

It is very basic as it only parses the provided files and extract their content. If we had a proper model making true API calls, the stub models and data would have been put in the spec folder, but the suspension of disbelief prevails here so pretend it actually makes api calls.  

## User (lib/slot_machine/models/user.rb)

The model has two attributes:  
-a **name** (that doubles as an unique identifier for this exercise)  
-a **calendar** instance (see below) containing all appointements of the user.  

This model does not do much in the context of the exercise. In a proper project it would have many more attributes and methods, but since we separated the calendars and the user logics, the only thing it does here is call the calendar for the method that will be relevant to the exercise.  

There is only one method :
-**get_available_slots** : calls the get_available_slots method of the calendar

## Calendar (lib/slot_machine/models/calendar.rb)

The model has two attributes  
-a **user_name** : the user name (identifier) of the associated user. Initially thought about making it an array for shared calendars, I did not have time for that (and it wasn't par of the exercise)   
-a **first_slot** : the first appointement slot of the calendar. Through it, we can access the other slots as it function as a linked list.  

The calendar object contains the available slots stored as a linked list and has the methods required to interact with it. My initial choice was to store everything in an array but it would have put most of the logic for determining gaps between slots in the calendar method and it felt more logical to have that in the slots models. Making a linked list felt like a cool and good idea at the time, I'm not convinced it really was the case.  
Here are the methods of the calendar model:  

-the **initializer** : it requires a name and calls the fetch_calendar method to obtain the taken slots.  
-**get_slot_array** : a method I developped for testing purposes, it returns the start time of every slot of the calendar in order and in an array. I only use it to check in my unit tests that the calendar json is correctly parsed and that the data is properly stored  
-**fetch_calendar** : a private method that use the name of the user (or multiple users hypothetically) and make the calls through the get calendar service to retrieve the json. The method creates one calendar slot per json object and order them. Initially it simply put one slot after the other, but i added an ordering method to handle the cases of overlapping/oddly ordered slots (this was not relevant and useful in the context of the exercise, a mistake from my part)  
-**get_available_slots** : the core part of the exercise. It recceives a starting time, an end time and a slot duration. It then picks the first of the slot of the calendar with a starting date after the provided start time and iterates through the linked list, concatenating the available slots between each list element along the way. It then returns the array of available slots.  
This method is messier than expected, the (nonexistent) problem of overlapping slots made me add a logic that would be used to skip irrelevant slot which makes the code harder to read.  


## CalendarSlot (lib/slot_machine/models/calendar_slot.rb)

The model has three attributes  
-a **start_time** : received in str format directly from the json  
-a **end_time** : received in str format directly from the json  
-a **next_slot** : which points to the next calendar slot of the linked list.  

This model represent a single slot of the calendar, an appointement already taken. Hypothetically it would contain more informations, such as the nature of the reunion/appointement and the users participating in it.  
It contains the following methods.

-the **initializer** : it requires a start time and end time recieved in str format  
-**available_slots_between** : a private method that can take two times and return the available slots of a given duration between them. This could have been put in the Utils (as described below) as it does not really rely on the attributes of the model to function.  
-**get_available_slots_between** : this method returns the available slots between the current slot and the next one in the linked list. If the two slots are not occuring on the same day, we caclulate the available slots before the end of the day and those between the start of the day and the beginning of the next slot (in order to not take into account the hours were employees are not working)  
-**get_available_slots_before** : this method has been hastily added to handle the case when we need to determine the slots available before the end of the day. It takes a timestamp and provides the available slots between the end time of the current slot and the provided timestamp.  

## Utils (lib/slot_machine/models/common/utils.rb)

Not a model, it should have been put elsewhere

It contains two methods  
**start_workday** : returns the starting hour of a regular workday (9am) for a given time  
**end_workday** : returns the ending hour of a regular workday (6pm) for a given time  

Both of these methods could be altered to reflect different working hours.

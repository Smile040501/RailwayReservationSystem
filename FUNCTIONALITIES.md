# Functionalities of the Railway Reservation System

The below services are always available to the **dbAdmin** role and to the **SuperUser**

## Services for the `station_master` Role

### Add a New Railway Station

![](images/q4.png)

### Add a New Train and its Schedule

![](images/q5.png)

### Update the Delay Time of a Train

![](images/q6.png)

### Other Services

`ALL` permissions on the tables **railway_station**, **train**, **schedule**, **seat**

## Services for the `users` Role (Customers with an account)

### Book Tickets

![](images/q1.png)

The trigger will try to auto-allocate the best possible seat for the passengers if available.

### Cancel Booking

![](images/q2.png)

The trigger will try to auto-allocate the best possible seat for the passengers having ticket status as **Waiting** for the same date and train.

### Other Services

-   `ALL` permissions on the tables **users** and **passenger** with **`Row Level Security`** implemented

    ![](images/q7.png)

    ![](images/q8.png)

-   `SELECT` permissions on the **ticket** table with **`Row Level Security`** implemented

## Services for everyone

### Create a New Account and Register as a Customer

![](images/q9.png)

### Available Trains Between Two Given Stations On a Given Date

![](images/q10.png)

### Full Schedule of a Given Train

![](images/q11.png)

### Schedule of Different Trains at a Given Station

![](images/q12.png)

### Fare of a Given Train Between Two Given Stations

![](images/q13.png)

### Get Details of a Passenger Given PNR

![](images/q14.png)

### Number of Seats Available in a Given Train Between Two Given Stations on a Given Date

![](images/q15.png)

### Check Ticket Status

![](images/q16.png)

### Check Delay Time of a Train

![](images/q17.png)

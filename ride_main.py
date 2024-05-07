import base64
from datetime import datetime
import os
import requests


def add_ride(api_url):
    try:
        # Prompt the user for information
        # owner_id = input("Enter your  ID: ")
        title = input("Enter title: ")
        description = input("Enter description: ")
        category = input("Enter category: ")
        start_location = input("Enter start location: ")
        end_location = input("Enter end location: ")

        # Ask for start date and time separately
        start_date = input("Enter start date (YYYY-MM-DD): ")
        start_time = input("Enter start time (HH:MM): ")
        start_date_time = datetime.strptime(
            f"{start_date} {start_time}", "%Y-%m-%d %H:%M")

        # Convert datetime to string in ISO 8601 format
        start_date_time = start_date_time.isoformat()

        available_seats = input("Enter available seats: ")

        # Construct the payload
        payload = {
            # "owner_id": owner_id,
            "title": title,
            "description": description,
            "category": category,
            "start_location": start_location,
            "end_location": end_location,
            "start_date_time": start_date_time,
            "available_seats": available_seats,
        }

        # Make the POST request
        response = requests.post(api_url, json=payload, headers=headers)

        # Check if the request was successful (status code 200)
        if response.status_code == 200:
            print(response.text)
            # Parse the JSON response
            data = response.json()

            # Display the details
            print("Message:", data.get("message"))
            ride_details = data.get("ride")
            if ride_details:
                print("Ride Details:")
                for key, value in ride_details.items():
                    print(f"{key}: {value}")

        else:
            print("Error:", response.status_code, response.text)

    except Exception as e:
        print("An error occurred:", e)


def add_ride_operation():
    api_url = "https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/add_ride"
    add_ride(api_url)


def list_rides(api_url, payload):
    try:
        response = requests.post(api_url, json=payload, headers=headers)

        if response.status_code == 200:
            data = response.json()
            rides = data.get("rides")

            print("Rides:")
            for ride in rides:
                print("Ride ID:", ride.get("ride_id"))
                print("Title:", ride.get("title"))
                print("Description:", ride.get("description"))
                print("Category:", ride.get("category"))
                print("Created At:", ride.get("created_at"))
                print("Start Date/Time:", ride.get("start_date_time"))
                print("Start Location:", ride.get("start_location"))
                print("End Location:", ride.get("end_location"))
                print("Available Seats:", ride.get("available_seats"))
                print("Joined:", ride.get("joined"))
                print("Owner ID:", ride.get("owner_id"))
                print("Expired:", ride.get("expired"))
                print()

        else:
            print("Error:", response.status_code, response.text)

    except Exception as e:
        print("An error occurred:", e)


def list_rides_operation():
    api_url = "https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/list_rides"

    print("Select list type:")
    print("1. All rides")
    print("2. Available rides")
    print("3. Specific ride")
    print("4. Rides by owner")
    print("q. Quit")

    choice = input("Enter your choice (1/2/3/4/q): ")

    if choice == '1':
        payload = {
            "list_type": "all"
        }
    elif choice == '2':
        payload = {
            "list_type": "available"
        }
    elif choice == '3':
        ride_id = input("Enter ride ID: ")
        payload = {
            "list_type": "specific",
            "ride_id": ride_id
        }
    elif choice == '4':
        owner_id = input("Enter owner ID: ")
        payload = {
            "list_type": "by_owner",
            "owner_id": owner_id
        }
    elif choice == 'q':
        return
    else:
        print("Invalid choice.")
        return

    list_rides(api_url, payload)


def edit_ride(api_url):
    try:
        # Prompt the user for information
        ride_id = input("Enter ride ID: ")
        # owner_id = input("Enter your  ID: ")
        title = input("Enter title: ")
        description = input("Enter description: ")
        category = input("Enter category: ")
        start_location = input("Enter start location: ")
        end_location = input("Enter end location: ")

        # Ask for start date and time separately
        start_date = input("Enter start date (YYYY-MM-DD): ")
        start_time = input("Enter start time (HH:MM): ")
        start_date_time = datetime.strptime(
            f"{start_date} {start_time}", "%Y-%m-%d %H:%M")

        # Convert datetime to string in ISO 8601 format
        start_date_time = start_date_time.isoformat()

        available_seats = input("Enter available seats: ")

        # Construct the payload
        payload = {
            "ride_id": ride_id,
            # "owner_id": owner_id,
            "title": title,
            "description": description,
            "category": category,
            "start_location": start_location,
            "end_location": end_location,
            "start_date_time": start_date_time,
            "available_seats": available_seats,
        }

        # Make the POST request
        response = requests.post(api_url, json=payload, headers=headers)

        # Check if the request was successful (status code 200)
        if response.status_code == 200:
            print(response.text)
            # Parse the JSON response
            data = response.json()

            # Display the details
            print("Message:", data.get("message"))
            ride_details = data.get("ride")
            if ride_details:
                print("Ride Details:")
                for key, value in ride_details.items():
                    print(f"{key}: {value}")

        else:
            print("Error:", response.status_code, response.text)

    except Exception as e:
        print("An error occurred:", e)


def edit_ride_operation():
    api_url = "https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/edit_ride"
    edit_ride(api_url)


def delete_ride(api_url):
    try:
        # Prompt the user for information
        ride_id = input("Enter ride ID: ")

        # Construct the payload
        payload = {
            "ride_id": ride_id
        }

        # Make the POST request
        response = requests.post(api_url, json=payload, headers=headers)

        # Check if the request was successful (status code 200)
        if response.status_code == 200:
            print(response.text)
            # Parse the JSON response
            data = response.json()

            # Display the message
            print("Message:", data.get("message"))

        else:
            print("Error:", response.status_code, response.text)

    except Exception as e:
        print("An error occurred:", e)


def delete_ride_operation():
    api_url = "https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/delete_ride"
    delete_ride(api_url)


def join_ride(api_url):
    try:
        # Prompt the user for information
        ride_id = input("Enter ride ID: ")
        # client_id = input("Enter client ID: ")

        # Construct the payload
        payload = {
            "ride_id": ride_id,
            # "client_id": client_id
        }

        # Make the POST request
        response = requests.post(api_url, json=payload, headers=headers)

        # Check if the request was successful (status code 200)
        if response.status_code == 200:
            print(response.text)
            # Parse the JSON response
            data = response.json()

            # Display the message
            print("Message:", data.get("message"))

        else:
            print("Error:", response.status_code, response.text)

    except Exception as e:
        print("An error occurred:", e)


def join_ride_operation():
    api_url = "https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/join_ride"
    join_ride(api_url)


def list_passengers(api_url, payload):
    try:
        response = requests.post(api_url, json=payload, headers=headers)

        if response.status_code == 200:
            data = response.json()
            passengers = data.get("passengers")

            print("Passengers:")
            for passenger in passengers:
                print("Order ID:", passenger.get("order_id"))
                print("Ride ID:", passenger.get("ride_id"))
                print("Client ID:", passenger.get("client_id"))
                print("Ordered At:", passenger.get("ordered_at"))
                print()

        else:
            print("Error:", response.status_code, response.text)

    except Exception as e:
        print("An error occurred:", e)


def list_passengers_operation():
    api_url = "https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/list_passengers"

    print("Select list type:")
    print("1. All passengers")
    print("2. Specific passenger")
    print("3. rides by client")
    print("q. Go back")

    choice = input("Enter your choice (1/2/3/q): ")

    if choice == '1':
        ride_id = input("Enter ride ID: ")
        payload = {
            "list_type": "all",
            "ride_id": ride_id
        }
    elif choice == '2':
        ride_id = input("Enter ride ID: ")
        client_id = input("Enter client ID: ")
        payload = {
            "list_type": "specific",
            "ride_id": ride_id,
            "client_id": client_id
        }
    elif choice == '3':
        client_id = input("Enter client ID: ")
        payload = {
            "list_type": "by_client",
            "client_id": client_id
        }

    elif choice == 'q':
        return
    else:
        print("Invalid choice.")
        return

    list_passengers(api_url, payload)


def get_token(api_url, payload):
    try:

        # Make the POST request
        response = requests.post(api_url, json=payload)

        # Check if the request was successful (status code 200)
        if response.status_code == 200:
            print(response.text)
            # Parse the JSON response
            data = response.json()

            # Display the details
            print("Message:", data.get("message"))
            user_data = data.get("userData")
            if user_data:
                return data.get("idToken")
                # print("ID Token:", data.get("idToken"))
                # print("User Data:")
                # for key, value in user_data.items():
                #     print(f"{key}: {value}")

        else:
            print("Error:", response.status_code, response.text)

    except Exception as e:
        print("An error occurred:", e)


def get_token_operation(email, password):
    api_url = "https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/get_token"

    payload = {
        "username": email,
        "password": password
    }

    return get_token(api_url, payload)


def change_token():
    # get the email and password from the user
    email = input("Enter your email: ")
    password = input("Enter your password: ")

    # get the id token
    id_token = get_token_operation(email, password)

    global headers
    headers = {
        "Authorization": "Bearer " + id_token
    }


def main():
    change_token()
    while True:
        # Display menu to the user
        print("Select operation:")
        print("1. Add a ride")
        print("2. List rides")
        print("3. Edit a ride")
        print("4. Delete a ride")
        print("5. Join a ride")
        print("6. List passengers")
        print("e. Change token")
        print("q. Quit")

        # Get user input
        choice = input("Enter your choice (1/2/3/4/5/6/7/q):  ")

        if choice == '1':
            add_ride_operation()
        elif choice == '2':
            list_rides_operation()
        elif choice == '3':
            edit_ride_operation()
        elif choice == '4':
            delete_ride_operation()
        elif choice == '5':
            join_ride_operation()
        elif choice == '6':
            list_passengers_operation()
        elif choice == 'e':
            change_token()
        elif choice == 'q':
            print("Exiting program.")
            break
        else:
            print("Invalid choice. Please try again.")


if __name__ == "__main__":
    main()

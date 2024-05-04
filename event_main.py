import base64
from datetime import datetime
import os
import requests

from tkinter import Tk, filedialog  # Import tkinter for GUI
from tkinter import simpledialog, Tk
from tkcalendar import DateEntry, Calendar


def add_event(api_url):
    try:
        # Prompt the user for information
        # owner_id = input("Enter your  ID: ")
        title = input("Enter title: ")
        description = input("Enter description: ")

        # Ask for start date and time separately
        start_date = input("Enter start date (YYYY-MM-DD): ")
        start_time = input("Enter start time (HH:MM): ")
        start_date_time = datetime.strptime(
            f"{start_date} {start_time}", "%Y-%m-%d %H:%M")

        # Ask for end date and time separately
        end_date = input("Enter end date (YYYY-MM-DD): ")
        end_time = input("Enter end time (HH:MM): ")
        end_date_time = datetime.strptime(
            f"{end_date} {end_time}", "%Y-%m-%d %H:%M")

        # Convert datetime to string in ISO 8601 format
        start_date_time = start_date_time.isoformat()
        end_date_time = end_date_time.isoformat()

        building = input("Enter building: ")
        room = input("Enter room: ")
        participants_number = input("Enter participants number: ")

        root = Tk()  # Create a Tkinter root window
        root.withdraw()  # Hide the root window

        files = filedialog.askopenfilenames(
            title="Select Pictures (Max 4)",
            filetypes=[("Image files", "*.jpg;*.png;*.jpeg")],
            multiple=True,
        )
        root.destroy()  # Close the hidden window

        # Ensure max 4 pictures selected
        if len(files) > 4:
            raise ValueError("Please select a maximum of 4 pictures.")

        # Construct the payload
        payload = {
            # "owner_id": owner_id,
            "title": title,
            "description": description,
            "start_date_time": start_date_time,
            "end_date_time": end_date_time,
            "building": building,
            "room": room,
            "participants_number": participants_number,
        }

        # Convert the images to base64 and add them to the payload
        for i, f in enumerate(files):
            with open(f, "rb") as image_file:
                encoded_string = base64.b64encode(
                    image_file.read()).decode('utf-8')
                # Include the file extension
                payload[f"picture_{i+1}"] = {"content": encoded_string,
                                             "extension": os.path.splitext(f)[1][1:]}

        # Make the POST request
        response = requests.post(api_url, json=payload, headers=headers)

        # Check if the request was successful (status code 200)
        if response.status_code == 200:
            print(response.text)
            # Parse the JSON response
            data = response.json()

            # Display the details
            print("Message:", data.get("message"))
            event_details = data.get("event")
            if event_details:
                print("Event Details:")
                for key, value in event_details.items():
                    print(f"{key}: {value}")

        else:
            print("Error:", response.status_code, response.text)

    except Exception as e:
        print("An error occurred:", e)


def add_event_operation():
    api_url = "https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/add_event"
    add_event(api_url)


def list_events(api_url, payload):
    try:
        response = requests.post(api_url, json=payload, headers=headers)

        if response.status_code == 200:
            data = response.json()
            events = data.get("events")

            print("Events:")
            for event in events:
                print("Event ID:", event.get("event_id"))
                print("Title:", event.get("title"))
                print("Description:", event.get("description"))
                print("Created At:", event.get("created_at"))
                print("Start Date/Time:", event.get("start_date_time"))
                print("End Date/Time:", event.get("end_date_time"))
                print("Building:", event.get("building"))
                print("Room:", event.get("room"))
                print("Participants Number:", event.get("participants_number"))
                print("Joined:", event.get("joined"))
                print("Owner ID:", event.get("owner_id"))
                print("Expired:", event.get("expired"))
                print("Pictures:")
                for pic in event.get("pictures", []):
                    print(pic)

                print()

        else:
            print("Error:", response.status_code, response.text)

    except Exception as e:
        print("An error occurred:", e)


def list_events_operation():
    api_url = "https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/list_events"

    print("Select list type:")
    print("1. All events")
    print("2. Available events")
    print("3. Specific event")
    print("4. Events by owner")
    print("5. Go back")

    choice = input("Enter your choice (1/2/3/4/5): ")

    if choice == '1':
        payload = {
            "list_type": "all"
        }
    elif choice == '2':
        payload = {
            "list_type": "available"
        }
    elif choice == '3':
        event_id = input("Enter event ID: ")
        payload = {
            "list_type": "specific",
            "event_id": event_id
        }
    elif choice == '4':
        owner_id = input("Enter owner ID: ")
        payload = {
            "list_type": "by_owner",
            "owner_id": owner_id
        }
    elif choice == '5':
        return
    else:
        print("Invalid choice. Please enter a valid option.")
        return

    list_events(api_url, payload)


def edit_event(api_url):
    try:
        # Prompt the user for information
        event_id = input("Enter event ID: ")
        # owner_id = input("Enter your  ID: ")
        title = input("Enter title: ")
        description = input("Enter description: ")

        # Ask for start date and time separately
        start_date = input("Enter start date (YYYY-MM-DD): ")
        start_time = input("Enter start time (HH:MM): ")
        start_date_time = datetime.strptime(
            f"{start_date} {start_time}", "%Y-%m-%d %H:%M")

        # Ask for end date and time separately
        end_date = input("Enter end date (YYYY-MM-DD): ")
        end_time = input("Enter end time (HH:MM): ")
        end_date_time = datetime.strptime(
            f"{end_date} {end_time}", "%Y-%m-%d %H:%M")

        # Convert datetime to string in ISO 8601 format
        start_date_time = start_date_time.isoformat()
        end_date_time = end_date_time.isoformat()

        building = input("Enter building: ")
        room = input("Enter room: ")
        participants_number = input("Enter participants number: ")

        root = Tk()  # Create a Tkinter root window
        root.withdraw()  # Hide the root window

        files = filedialog.askopenfilenames(
            title="Select Pictures (Max 4)",
            filetypes=[("Image files", "*.jpg;*.png;*.jpeg")],
            multiple=True,
        )
        root.destroy()  # Close the hidden window

        # Ensure max 4 pictures selected
        if len(files) > 4:
            raise ValueError("Please select a maximum of 4 pictures.")

        # Construct the payload
        payload = {
            "event_id": event_id,
            # "owner_id": owner_id,
            "title": title,
            "description": description,
            "start_date_time": start_date_time,
            "end_date_time": end_date_time,
            "building": building,
            "room": room,
            "participants_number": participants_number,
        }

        # Convert the images to base64 and add them to the payload
        for i, f in enumerate(files):
            with open(f, "rb") as image_file:
                encoded_string = base64.b64encode(
                    image_file.read()).decode('utf-8')
                # Include the file extension
                payload[f"picture_{i+1}"] = {"content": encoded_string,
                                             "extension": os.path.splitext(f)[1][1:]}

        # Make the POST request
        response = requests.post(api_url, json=payload, headers=headers)

        # Check if the request was successful (status code 200)
        if response.status_code == 200:
            print(response.text)
            # Parse the JSON response
            data = response.json()

            # Display the details
            print("Message:", data.get("message"))
            event_details = data.get("event")
            if event_details:
                print("Event Details:")
                for key, value in event_details.items():
                    print(f"{key}: {value}")

        else:
            print("Error:", response.status_code, response.text)

    except Exception as e:
        print("An error occurred:", e)


def edit_event_operation():
    api_url = "https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/edit_event"
    edit_event(api_url)


def delete_event(api_url):
    try:
        event_id = input("Enter event ID: ")

        payload = {
            "event_id": event_id
        }

        response = requests.post(api_url, json=payload, headers=headers)

        if response.status_code == 200:
            data = response.json()
            print("Message:", data.get("message"))
            event_details = data.get("event")
            if event_details:
                print("Event Details:")
                for key, value in event_details.items():
                    print(f"{key}: {value}")

        else:
            print("Error:", response.status_code, response.text)

    except Exception as e:
        print("An error occurred:", e)


def delete_event_operation():
    api_url = "https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/delete_event"
    delete_event(api_url)


def join_event(api_url):
    try:
        event_id = input("Enter event ID: ")
        # client_id = input("Enter client ID: ")

        payload = {
            "event_id": event_id,
            # "client_id": client_id
        }

        response = requests.post(api_url, json=payload, headers=headers)

        if response.status_code == 200:
            data = response.json()
            print("Message:", data.get("message"))

        else:
            print("Error:", response.status_code, response.text)

    except Exception as e:
        print("An error occurred:", e)


def join_event_operation():
    api_url = "https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/join_event"
    join_event(api_url)


def list_participations(api_url, payload):
    try:
        response = requests.post(api_url, json=payload, headers=headers)

        if response.status_code == 200:
            data = response.json()
            participations = data.get("participations")

            print("Participations:")
            for participation in participations:
                print("Order ID:", participation.get("order_id"))
                print("Event ID:", participation.get("event_id"))
                print("Client ID:", participation.get("client_id"))
                print("Ordered At:", participation.get("ordered_at"))
                print()

        else:
            print("Error:", response.status_code, response.text)

    except Exception as e:
        print("An error occurred:", e)


def list_participations_operation():
    api_url = "https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/list_participations"

    print("Select list type:")
    print("1. All participations")
    print("2. Specific participation")
    print("3. Participations by client")
    print("4. Go back")

    choice = input("Enter your choice (1/2/3/4): ")

    if choice == '1':
        event_id = input("Enter event ID: ")
        payload = {
            "list_type": "all",
            "event_id": event_id
        }
    elif choice == '2':
        event_id = input("Enter event ID: ")
        client_id = input("Enter client ID: ")
        payload = {
            "list_type": "specific",
            "event_id": event_id,
            "client_id": client_id
        }
    elif choice == '3':
        client_id = input("Enter client ID: ")
        payload = {
            "list_type": "by_client",
            "client_id": client_id
        }
    elif choice == '4':
        return
    else:
        print("Invalid choice. Please enter a valid option.")
        return

    list_participations(api_url, payload)


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
        print("1. Add an event")
        print("2. List events")
        print("3. Edit an event")
        print("4. Delete an event")
        print("5. Join an event")
        print("6. List participations")
        print("e. Change token")
        print("q. Quit")

        # Get user input
        choice = input("Enter your choice (1/2/3/4/5/6/q):  ")

        if choice == "1":
            add_event_operation()
        elif choice == "2":
            list_events_operation()
        elif choice == "3":
            edit_event_operation()
        elif choice == "4":
            delete_event_operation()
        elif choice == "5":
            join_event_operation()
        elif choice == "6":
            list_participations_operation()
        elif choice.lower() == "e":
            change_token()
        elif choice.lower() == "q":
            print("Exiting program...")
            break
        else:
            print("Invalid choice. Please try again.")


if __name__ == "__main__":
    main()

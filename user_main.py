import base64
from datetime import datetime
import json
import os
import requests
from tkinter import Tk, filedialog  # Import tkinter for GUI
from tkinter import simpledialog, Tk


def add_user_info(api_url):
    try:
        # Get user input
        building = input("Enter your building: ")
        room = input("Enter your room: ")

        # Create the payload
        payload = {
            "building": building,
            "room": room
        }

        root = Tk()  # Create a Tkinter root window
        root.withdraw()  # Hide the root window

        files = filedialog.askopenfilenames(
            title="Select Picture",
            filetypes=[("Image files", "*.jpg;*.png;*.jpeg")],
        )
        root.destroy()

        # Check if any file was selected
        if files:
            file = files[0]  # Use the first file

            with open(file, "rb") as image_file:
                encoded_string = base64.b64encode(
                    image_file.read()).decode('utf-8')
                # Include the file extension
                payload["pic"] = {"content": encoded_string,
                                  "extension": os.path.splitext(file)[1][1:]}

        # Make the POST request
        response = requests.post(api_url, json=payload, headers=headers)

        # Check if the request was successful (status code 200)
        if response.status_code == 200:
            print("User info added successfully.")
            print(response.json())
        else:
            print("Error:", response.status_code, response.text)

    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }


def add_user_info_operation():
    api_url = "https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/add_user_info"
    add_user_info(api_url)


def edit_user_info(api_url):
    try:
        # Get user input
        building = input("Enter your building: ")
        room = input("Enter your room: ")

        # Create the payload
        payload = {
            "building": building,
            "room": room
        }

        root = Tk()  # Create a Tkinter root window
        root.withdraw()  # Hide the root window

        files = filedialog.askopenfilenames(
            title="Select Picture",
            filetypes=[("Image files", "*.jpg;*.png;*.jpeg")],
        )
        root.destroy()

        # Check if any file was selected
        if files:
            file = files[0]  # Use the first file

            with open(file, "rb") as image_file:
                encoded_string = base64.b64encode(
                    image_file.read()).decode('utf-8')
                # Include the file extension
                payload["pic"] = {"content": encoded_string,
                                  "extension": os.path.splitext(file)[1][1:]}

        # Make the PUT request
        response = requests.post(api_url, json=payload, headers=headers)

        # Check if the request was successful (status code 200)
        if response.status_code == 200:
            print("User info updated successfully.")
            print(response.json())
        else:
            print("Error:", response.status_code, response.text)

    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }


def edit_user_info_operation():
    api_url = "https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/edit_user_info"
    edit_user_info(api_url)


def list_user_info(api_url):
    try:
        # Make the POST request
        response = requests.get(api_url, headers=headers)

        # Check if the request was successful (status code 200)
        if response.status_code == 200:
            print(response.json())
        else:
            print("Error:", response.status_code, response.text)

    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }


def list_user_info_operation():
    api_url = "https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/list_user_info"
    list_user_info(api_url)


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
        print("1. Add user info")
        print("2. Edit user info")
        print("3. List user info")
        print("e. Change token")
        print("q. Quit")

        # Get user input
        choice = input("Enter your choice (1/2/3/e/q):  ")

        if choice == '1':
            add_user_info_operation()
        elif choice == '2':
            edit_user_info_operation()
        elif choice == '3':
            list_user_info_operation()
        elif choice == 'e':
            change_token()
        elif choice == 'q':
            print("Exiting program.")
            break
        else:
            print("Invalid choice. Please try again.")


if __name__ == "__main__":
    main()

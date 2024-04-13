import base64
from datetime import datetime
import os
import requests
from tkinter import Tk, filedialog  # Import tkinter for GUI


def list(api_url, payload):
    try:
        # Make the POST request
        response = requests.post(api_url, json=payload)

        # Check if the request was successful (status code 200)
        if response.status_code == 200:
            # # Parse the JSON response
            # data = response.json()

            # # Display the details
            # print("Message:", data.get("message"))

            # if "item" in data:
            #     items = data["item"]
            #     for item in items:
            #         print("\nItem Details:")
            #         print("ID:", item.get("item_id"))
            #         print("Title:", item.get("title"))
            #         print("Description:", item.get("description"))
            #         print("Created At:", item.get("created_at"))
            #         print("Owner ID:", item.get("owner_id"))
            #         # print("Requester ID:", item.get("requester_id"))
            #         # print("Contact Number:", item.get("contact_number"))
            #         # print("Requested At:", item.get("requested_at"))
            #         # print("Taken:", item.get("taken"))

            # Display the details
            data = response.json()
            items = data.get("items")
            for item in items:
                print("\nItem Details:")
                print("ID:", item.get("item_id"))
                print("Title:", item.get("title"))
                print("Description:", item.get("description"))
                print("Created At:", item.get("created_at"))
                print("Owner ID:", item.get("owner_id"))
                print("Requester ID:", item.get("requester_id"))
                print("Contact Number:", item.get("contact_number"))
                print("Requested At:", item.get("requested_at"))
                print("Expired:", item.get("expired"))
                print("Pictures:", item.get("pictures"))
                if "pictures" in item:
                    print("Pictures:")
                    for pic in item["pictures"]:
                        print(pic)

        elif response.status_code == 204:
            print("Message:", "No items found.")

        else:
            print("Error:", response.status_code, response.text)

    except Exception as e:
        print("An error occurred:", e)


def update_item(api_url):
    try:
        # Prompt the user for item ID and requester ID
        item_id = input("Enter item ID: ")
        requester_id = input("Enter your ID: ")

        # Construct the payload
        payload = {
            "item_id": item_id,
            "requester_id": requester_id
        }

        # Make the POST request
        response = requests.post(api_url, json=payload)

        # Check if the request was successful (status code 200)
        if response.status_code == 200:
            # Parse the JSON response
            data = response.json()

            # Display the details
            print("Message:", data.get("message"))
            print("Contact Number:", data.get("contact_number"))

        else:
            print("Error:", response.status_code, response.text)

    except Exception as e:
        print("An error occurred:", e)


def get_last_item_id(api_url):
    try:
        # Define the JSON object to send in the request body
        json_data = {
            "key": "value"  # replace with your actual data
        }

        # Make the POST request
        response = requests.post(api_url, json=json_data)

        # Check if the request was successful (status code 200)
        if response.status_code == 200:
            # Parse the JSON response
            data = response.json()

            # Return the last item ID
            return data.get("max_id")

        else:
            print("Error:", response.status_code, response.text)

    except Exception as e:
        print("An error occurred:", e)


# def create_item(api_url, last_item_id):
#     try:
#         # Prompt the user for information
#         owner_id = input("Enter your ID: ")
#         contact_number = input("Enter contact number: ")
#         title = input("Enter title: ")
#         description = input("Enter description: ")

#         # Construct the payload
#         payload = {
#             "item_id": last_item_id + 1,
#             "owner_id": owner_id,
#             "contact_number": contact_number,
#             "title": title,
#             "description": description
#         }

#         # Make the POST request
#         response = requests.post(api_url, json=payload)

#         # Check if the request was successful (status code 200)
#         if response.status_code == 200:
#             # Parse the JSON response
#             data = response.json()

#             # Display the details
#             print("Message:", data.get("message"))
#             item_details = data.get("item")
#             if item_details:
#                 print("\nItem Details:")
#                 print("ID:", item_details.get("item_id"))
#                 print("Created At:", item_details.get("created_at"))
#                 print("Owner  ID:", item_details.get("owner_id"))
#                 print("Contact Number:", item_details.get("contact_number"))
#                 print("Title:", item_details.get("title"))
#                 print("Description:", item_details.get("description"))
#                 # print("Taken:", item_details.get("taken"))
#                 # print("Requester ID:", item_details.get("requester_id"))
#                 # print("Requested At:", item_details.get("requested_at"))

#         else:
#             print("Error:", response.status_code, response.text)

#     except Exception as e:
#         print("An error occurred:", e)

def create_item(api_url):
    try:
        # Prompt the user for information
        owner_id = input("Enter your  ID: ")
        contact_number = input("Enter contact number: ")
        title = input("Enter title: ")
        description = input("Enter description: ")

        # # generate a unique id
        # desired_length = 10
        # generated_id = str(uuid.uuid4())[:desired_length]

        root = Tk()
        root.withdraw()  # Hide the main window
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
            # "item_id": generated_id,
            "owner_id": owner_id,
            "contact_number": contact_number,
            "title": title,
            "description": description,
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
        response = requests.post(api_url, json=payload)

        # Check if the request was successful (status code 200)
        if response.status_code == 200:
            print(response.text)
            # Parse the JSON response
            data = response.json()

            # Display the details
            print("Message:", data.get("message"))
            item_details = data.get("item")
            if item_details:
                print("\nItem Details:")
                print("ID:", item_details.get("item_id"))
                print("Created At:", item_details.get("created_at"))
                print("Owner ID:", item_details.get("owner_id"))
                print("Contact Number:", item_details.get("contact_number"))
                print("Title:", item_details.get("title"))
                print("Description:", item_details.get("description"))
                # print("Taken:", item_details.get("taken"))
                # print("Requester ID:", item_details.get("requester_id"))
                # print("Requested At:", item_details.get("requested_at"))

        else:
            print("Error:", response.status_code, response.text)

    except Exception as e:
        print("An error occurred:", e)


def list_operation():
    api_url = "https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/list_items"

    print("Select operation:")
    print("1. list all items")
    print("2. List available items")
    print("3. list a specific item")
    print("4. Exit")

    choice = input("Enter your choice (1/2/3/4): ")

    if choice == '1':
        payload = {
            "list_type": "all"
        }
    elif choice == '2':
        payload = {
            "list_type": "available"
        }
    elif choice == '3':
        item_id = input("Enter item ID: ")
        payload = {
            "list_type": "specific",
            "item_id": item_id
        }
    elif choice == '4':
        return
    else:
        print("Invalid choice. Please enter a valid option.")
        return

    list(api_url, payload)


def request_operation():
    api_url = "https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/request_item"
    update_item(api_url)


def add_operation():
    # Example usage
    api_url_last_id = "https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/last"
    api_url_create_item = "https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/add_item"

    # last_item_id = get_last_item_id(api_url_last_id)

    # if last_item_id is not None:
    #     create_item(api_url_create_item, last_item_id)
    create_item(api_url_create_item)


def main():
    while True:
        # Display menu to the user
        print("Select operation:")
        print("1. List items")
        print("2. Request an item")
        print("3. Add an item")
        print("4. Exit")

        # Get user input
        choice = input("Enter your choice (1/2/3/4): ")

        if choice == '1':
            list_operation()
        elif choice == '2':
            request_operation()
        elif choice == '3':
            add_operation()
        elif choice == '4':
            print("Exiting the program. Goodbye!")
            break
        else:
            print("Invalid choice. Please enter a valid option.")


if __name__ == "__main__":
    main()

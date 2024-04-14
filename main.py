import base64
from datetime import datetime
import os
import requests

from tkinter import Tk, filedialog  # Import tkinter for GUI


def list_items(api_url, payload):
    try:
        # Make the POST request
        response = requests.post(api_url, json=payload)

        # Check if the request was successful (status code 200)
        if response.status_code == 200:
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
                print("item_type:", item.get("item_type"))
                print("Contact Number:", item.get("contact_number"))
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


def order_item(api_url):
    try:
        # Prompt the user for item ID and requester ID
        item_id = input("Enter item ID: ")
        client_id = input("Enter your ID: ")

        # Construct the payload
        payload = {
            "item_id": item_id,
            "client_id": client_id
        }

        # Make the POST request
        response = requests.post(api_url, json=payload)

        # Check if the request was successful (status code 200)
        if response.status_code == 200:
            # Parse the JSON response
            data = response.json()

            # Display the details
            print("Message:", data.get("message"))

        else:
            print("Error:", response.status_code, response.text)

    except Exception as e:
        print("An error occurred:", e)


def list_orders(api_url, payload):
    try:
        # Make the POST request
        response = requests.post(api_url, json=payload)

        # Check if the request was successful (status code 200)
        if response.status_code == 200:
            # Display the details
            data = response.json()
            orders = data.get("orders")
            for order in orders:
                print("\nOrder Details:")
                print("Order ID:", order.get("order_id"))
                print("Item ID:", order.get("item_id"))
                print("Client ID:", order.get("client_id"))
                print("Ordered At:", order.get("ordered_at"))
                print("Accepted:", order.get("accepted"))
                print("Accepted At:", order.get("accepted_at"))

        elif response.status_code == 204:
            print("Message:", "No orders found.")

        else:
            print("Error:", response.status_code, response.text)

    except Exception as e:
        print("An error occurred:", e)


def accept_order(api_url, payload):
    try:
        # Make the POST request
        response = requests.post(api_url, json=payload)

        # Check if the request was successful (status code 200)
        if response.status_code == 200:
            # Parse the JSON response
            data = response.json()

            # Display the details
            print("Message:", data.get("message"))

        else:
            print("Error:", response.status_code, response.text)

    except Exception as e:
        print("An error occurred:", e)


def add_item(api_url):
    try:
        # Prompt the user for information
        owner_id = input("Enter your  ID: ")
        contact_number = input("Enter contact number: ")
        title = input("Enter title: ")
        description = input("Enter description: ")

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

        else:
            print("Error:", response.status_code, response.text)

    except Exception as e:
        print("An error occurred:", e)


def list_items_operation():
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

    list_items(api_url, payload)


def order_operation():
    api_url = "https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/order_item"
    order_item(api_url)


def list_orders_operation():
    api_url = "https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/list_orders"

    print("Select operation:")
    print("1. List all orders")
    print("2. List non-accepted orders")
    print("3. List accepted orders")
    print("4. List specific order")
    print("5. Exit")

    choice = input("Enter your choice (1/2/3/4/5): ")

    if choice != '5':
        item_id = input("Enter item ID: ")

    if choice == '1':
        payload = {
            "list_type": "all",
            "item_id": item_id
        }
    elif choice == '2':
        payload = {
            "list_type": "not_accepted",
            "item_id": item_id
        }
    elif choice == '3':
        payload = {
            "list_type": "accepted",
            "item_id": item_id
        }
    elif choice == '4':
        client_id = input("Enter client ID: ")
        payload = {
            "list_type": "specific",
            "item_id": item_id,
            "client_id": client_id
        }
    elif choice == '5':
        return
    else:
        print("Invalid choice. Please enter a valid option.")
        return

    list_orders(api_url, payload)


def accept_order_operation():
    api_url_accept_order = "https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/accept_order"

    # Prompt the user for item ID and client ID
    item_id = input("Enter item ID: ")
    client_id = input("Enter client ID: ")

    # Construct the payload
    payload = {
        "item_id": item_id,
        "client_id": client_id
    }

    accept_order(api_url_accept_order, payload)


def add_item_operation():
    api_url_create_item = "https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/add_item"
    add_item(api_url_create_item)


def main():
    while True:
        # Display menu to the user
        print("Select operation:")
        print("1. Add an item")
        print("2. List items")
        print("3. Order an item")
        print("4. List orders")
        print("5. Accept an order")
        print("6. Exit")

        # Get user input
        choice = input("Enter your choice (1/2/3/4/5/6): ")

        if choice == '1':
            add_item_operation()
        elif choice == '2':
            list_items_operation()
        elif choice == '3':
            order_operation()
        elif choice == '4':
            list_orders_operation()
        elif choice == '5':
            accept_order_operation()
        elif choice == '6':
            print("Exiting the program. Goodbye!")
            break
        else:
            print("Invalid choice. Please enter a valid option.")


if __name__ == "__main__":
    main()

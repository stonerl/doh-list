# DoH DNS Block Filter

This repository contains a script and two lists for blocking publicly available DNS-over-HTTPS (DoH) servers. The script automatically updates the lists with the latest DoH server URLs, ensuring the block list is always up-to-date.

## How It Works

The `doh-update.sh` script fetches a list of publicly available DoH servers from a Markdown file in the [curl/curl.wiki](https://github.com/curl/curl/wiki/DNS-over-HTTPS#publicly-available-servers) GitHub repository and [AdGuards list of known DNS providers](https://adguard-dns.io/kb/general/dns-providers/). It then extracts the base URLs of these DoH servers and compiles them into two block list, which can be used to prevent access to these servers.

The block lists are updated once a week through a GitHub Actions workflow, ensuring that new entries from the sources are included and that the lists remains current.

## Subscribing to the Block List

To use this block list, you can subscribe to it in various applications that support external block lists. Here's a general guide on how to subscribe:

1. **Find the Subscription Option**: Open the settings of your application (e.g., AdGuard Home, Pi-hole) and locate the section where you can add or subscribe to block lists.

2. **Add the Block List URL**: Use one of the following URLs to subscribe to the block list:

#### List with domains only (e.g. for Pi-hole)
```
https://raw.githubusercontent.com/stonerl/doh-list/main/doh-servers.list
```

#### List with full URLs
```
https://raw.githubusercontent.com/stonerl/doh-list/main/doh-list.txt
```

These URLs point to the raw `doh-servers.list` and `doh-list.txt` files in this repository.

3. **Save and Update**: After adding the URL, save the changes and update your block lists. The application should fetch the latest version of the file.

4. **Regular Updates**: Depending on your application settings, the list will be updated regularly to ensure that new DoH server URLs are blocked as they become available.

## Contributions and Feedback

Contributions to this project are welcome. If you have suggestions or feedback, feel free to open an issue or submit a pull request.

## License

This project is licensed under the terms of the [MIT License](https://github.com/MohamedElashri/doh-list/blob/master/LICENSE).

## Disclaimer

This block list is provided "as is", and its effectiveness in blocking DoH servers may vary. The list is compiled based on publicly available information and might not cover all existing DoH servers.

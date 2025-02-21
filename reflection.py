import requests
import threading
import argparse
from urllib.parse import urlparse, parse_qs, urlunparse, urlencode
import time

# Set the timeout limit (in seconds)
TIMEOUT = 10

# Global variables to track progress
total_urls = 0
processed_urls = 0

# ANSI escape sequences for color
BOLD = '\033[1m'
RED = '\033[91m'
BOLD_RED = '\033[1;91m'
GREEN = '\033[92m'
BLUE = '\033[94m'
RESET = '\033[0m'

def print_banner():
    banner = f"""
    {GREEN}#########################################{RESET}
    {GREEN}#                                       #{RESET}
    {GREEN}#        {BOLD}XSS Reflection Checker V2 {RESET}{GREEN}        #{RESET}
    {GREEN}#        {BOLD}Developed by Ibrahim{RESET}{GREEN}        #{RESET}
    {GREEN}#                                       #{RESET}
    {GREEN}#########################################{RESET}
    {BOLD}Usage:{RESET}                                #
    python reflection.py urls.txt --threads 2
    """
    print(banner)

def save_reflected_url(original_url, param_name, modified_params, output_file):
    """Save the modified URL with {payload} replacing the specific parameter."""
    temp_params = modified_params.copy()

    # Save with {payload} in place of the current parameter without encoding
    temp_params[param_name] = "{payload}"
    query = "&".join(f"{k}={','.join(v)}" if isinstance(v, list) else f"{k}={v}" for k, v in temp_params.items())
    payload_url = urlunparse(urlparse(original_url)._replace(query=query))

    # Save the clean payload URL to the output file
    with open(output_file, 'a') as f:
        f.write(payload_url + '\n')

    print(f"{GREEN}[SAVED] {payload_url}{RESET}")

def check_reflection(url, output_file):
    global processed_urls

    try:
        parsed_url = urlparse(url)
        query_params = parse_qs(parsed_url.query)

        # Ensure empty parameters are handled
        for param in parsed_url.query.split("&"):
            key_value = param.split("=")
            if len(key_value) == 1 or key_value[1] == "":
                query_params[key_value[0]] = ["ibrahimXSS"]

        # Process each parameter individually
        for param in query_params:
            # Make a deep copy of query parameters to modify only one at a time
            modified_params = {k: v[:] for k, v in query_params.items()}

            # Temporarily set the current parameter to `ibrahimXSS`
            modified_params[param] = ['ibrahimXSS']

            # Reconstruct the modified URL
            query = "&".join(f"{k}={','.join(v)}" if isinstance(v, list) else f"{k}={v}" for k, v in modified_params.items())
            modified_url = urlunparse(parsed_url._replace(query=query))

            # Make a request with a timeout
            response = requests.get(modified_url, timeout=TIMEOUT)

            # Check if 'ibrahimXSS' is reflected in the response
            if 'ibrahimXSS' in response.text:
                print(f"{GREEN}[+] Reflection found on {modified_url} for parameter '{BOLD_RED}{param}{RESET}'")

                # Save URL with {payload} replacing only the current parameter
                save_reflected_url(url, param, modified_params, output_file)

    except requests.exceptions.Timeout:
        print(f"{RED}[!] Connection Timeout: {url}{RESET}")
        time.sleep(2)
    except requests.exceptions.RequestException:
        print(f"{RED}[!] Connection Timeout: {url}{RESET}")
        time.sleep(2)
    finally:
        processed_urls += 1
        print(f"{BLUE}[INFO] Progress: {processed_urls}/{total_urls} URLs processed.{RESET}")

def main():
    global total_urls

    print_banner()

    parser = argparse.ArgumentParser(description="Reflection Checker")
    parser.add_argument("file_path", type=str, help="Path to the text file containing URLs")
    parser.add_argument("--threads", type=int, default=5, help="Number of threads to use (default: 5)")

    args = parser.parse_args()

    # Read URLs from the file
    try:
        with open(args.file_path, 'r') as f:
            urls = [line.strip() for line in f if line.strip()]
        total_urls = len(urls)
    except Exception as e:
        print(f"{RED}Error reading file: {str(e)}{RESET}")
        return

    # Set the output file
    output_file = 'xss.txt'

    # Clear previous results in the output file
    open(output_file, 'w').close()

    threads = []
    for url in urls:
        while threading.active_count() - 1 >= args.threads:
            pass  # Wait for available thread slot

        thread = threading.Thread(target=check_reflection, args=(url, output_file))
        threads.append(thread)
        thread.start()

    for thread in threads:
        thread.join()

if __name__ == "__main__":
    main()

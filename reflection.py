import requests
import threading
import argparse
from urllib.parse import urlparse, parse_qs, urlunparse, urlencode
import time

# Set the timeout limit (in seconds)
TIMEOUT = 10

# Global variables to track progress and save URLs only once
total_urls = 0
processed_urls = 0
saved_urls = set()  # Set to track saved URLs

# ANSI escape sequences for color
BOLD = '\033[1m'
RED = '\033[91m'
BOLD_RED = '\033[1;91m'  # Bold red
GREEN = '\033[92m'
YELLOW = '\033[93m'
BLUE = '\033[94m'
CYAN = '\033[96m'
WHITE = '\033[97m'
RESET = '\033[0m'

def print_banner():
    banner = f"""
    {GREEN}#########################################{RESET}
    {GREEN}#                                       #{RESET}
    {GREEN}#        {BOLD}{CYAN}XSS Reflection Checker{RESET}{GREEN}        #{RESET}
    {GREEN}#        {BOLD}{CYAN}Developed by Ibrahim{RESET}{GREEN}        #{RESET}
    {GREEN}#                                       #{RESET}
    {GREEN}#########################################{RESET}
    {BOLD}{WHITE}# Usage:{RESET}                                #
    {CYAN}python reflection.py urls.txt --threads 2{RESET}
    {GREEN}#                                       #{RESET}
    {GREEN}#########################################{RESET}
    """
    print(banner)

def check_reflection(url, output_file):
    global processed_urls

    try:
        parsed_url = urlparse(url)
        query_params = parse_qs(parsed_url.query)
        base_url = parsed_url._replace(query="").geturl()

        found_reflection = False

        for param in query_params:
            modified_params = query_params.copy()
            modified_params[param] = ['ibrahimXSS']

            modified_url = urlunparse(parsed_url._replace(query=urlencode(modified_params, doseq=True)))

            # Make a request with a timeout
            response = requests.get(modified_url, timeout=TIMEOUT)

            if 'ibrahimXSS' in response.text:
                found_reflection = True
                # Highlight reflected parameter in bold red
                print(f"{GREEN}[+] Reflection found on {modified_url} for parameter '{BOLD_RED}{param}{RESET}'")

        if found_reflection and base_url not in saved_urls:
            with open(output_file, 'a') as f:
                f.write(url + '\n')
            saved_urls.add(base_url)  # Add the base URL to the set to prevent duplicates

    except requests.exceptions.Timeout:
        print(f"{RED}[!] Timeout: The request to {url} took longer than {TIMEOUT} seconds. Moving to the next URL in 5 seconds.{RESET}")
        time.sleep(5)  # Wait before continuing to the next URL
    except requests.exceptions.RequestException as e:
        print(f"{RED}[!] Error scanning {url}: {str(e)}. Moving to the next URL in 5 seconds.{RESET}")
        time.sleep(5)  # Wait before continuing to the next URL
    finally:
        processed_urls += 1
        print(f"{BLUE}[INFO] Scanning progress: {processed_urls}/{total_urls} URLs processed.{RESET}")

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

import requests
import threading
import argparse
from urllib.parse import urlparse, urlunparse
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
    {GREEN}#                                       #
    {GREEN}#        {BOLD}{CYAN}XSS Reflection Checker{RESET}{GREEN}        #
    {GREEN}#        {BOLD}{CYAN}Developed by Ibrahim{RESET}{GREEN}        #
    {GREEN}#                                       #
    {GREEN}#########################################{RESET}
    {BOLD}{WHITE}# Usage:{RESET}                                #
    {CYAN}python path-reflection.py urls.txt --threads 2{RESET}
    {GREEN}#########################################{RESET}
    """
    print(banner)

def check_reflection(url, output_file):
    global processed_urls

    try:
        parsed_url = urlparse(url)
        path_segments = parsed_url.path.strip('/').split('/')
        found_reflection = False

        # Check reflection in each path segment one by one
        for i, segment in enumerate(path_segments):
            modified_segments = path_segments.copy()

            # Replace the current segment with 'ibrahimXSS'
            if '.' in segment:
                # Handle file names with extensions (e.g., 'test.php')
                base, ext = segment.rsplit('.', 1)
                modified_segments[i] = f'ibrahimXSS.{ext}'
            else:
                modified_segments[i] = 'ibrahimXSS'

            # Build the modified URL with replaced segment
            modified_path = '/' + '/'.join(modified_segments)
            modified_url = urlunparse(parsed_url._replace(path=modified_path))

            # Make a request with a timeout
            response = requests.get(modified_url, timeout=TIMEOUT)

            if 'ibrahimXSS' in response.text:
                found_reflection = True
                print(f"{GREEN}[+] Reflection found on {modified_url} for path segment '{BOLD_RED}{segment}{RESET}'")

                # Save the modified URL (with ibrahimXSS) for each reflected segment
                if modified_url not in saved_urls:
                    with open(output_file, 'a') as f:
                        f.write(modified_url + '\n')
                    saved_urls.add(modified_url)  # Save the modified URL to avoid duplicates

        # Test with 'ibrahimXSS' added at the end of the path, ensuring no extra slashes
        if parsed_url.path.endswith('/'):
            appended_url = urlunparse(parsed_url._replace(path=parsed_url.path + 'ibrahimXSS'))
        else:
            appended_url = urlunparse(parsed_url._replace(path=parsed_url.path + '/ibrahimXSS'))

        response = requests.get(appended_url, timeout=TIMEOUT)
        if 'ibrahimXSS' in response.text:
            found_reflection = True
            print(f"{GREEN}[+] Reflection found on {appended_url} for appended 'ibrahimXSS' in the path")

            # Save the appended URL (with ibrahimXSS) for appended reflection
            if appended_url not in saved_urls:
                with open(output_file, 'a') as f:
                    f.write(appended_url + '\n')
                saved_urls.add(appended_url)

        # Always append 'ibrahimXSS' to URLs that contain a fragment (#), even if no reflection
        if parsed_url.fragment:
            modified_fragment_url = urlunparse(parsed_url._replace(fragment=f'{parsed_url.fragment}ibrahimXSS'))

            # Save the modified fragment URL, marking it as reflective
            print(f"{GREEN}[+] Appending 'ibrahimXSS' to fragment: {modified_fragment_url}")
            if modified_fragment_url not in saved_urls:
                with open(output_file, 'a') as f:
                    f.write(modified_fragment_url + '\n')
                saved_urls.add(modified_fragment_url)

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
    output_file = 'path-xss.txt'

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

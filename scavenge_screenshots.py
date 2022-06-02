#!/usr/bin/env python3
"""
#############################################################
# This script will delete stale screenshots from ~/Pictures #
# Using ctime from the picture file it will only keep those #
# created within a predefined range.                        #
#############################################################
"""

import time
import tarfile
from pathlib import Path
from datetime import datetime as dt

now = time.time()
delta = time.time() - (
    7 * 86400
)  # time is in seconds/86400 seconds in a day.  this is 7 days

picture_directory = "/home/comet/Pictures"
archive_directory = "/home/comet/Pictures/Screenshot_Archive"

# build a path object of files
def grab_stale(directory, delta):
    path_list = Path(directory).glob("Screenshot*.png")
    stale_files = [file for file in path_list if Path(file).stat().st_ctime <= delta]
    return stale_files


# define a function to create a tarball
def make_tarfile(output, source_files):
    current_date = dt.today().strftime("%Y-%m-%d")
    with tarfile.open(f"{output}/{current_date}.tar.gz", "w:gz") as tar:
        for file in source_files:
            tar.add(file, arcname=Path(file).name)


# delete stale files
def remove_stale(source_files):
    for file in source_files:
        Path(file).unlink()


def main():
    stale_files = grab_stale(picture_directory, delta)
    make_tarfile(archive_directory, stale_files)
    remove_stale(stale_files)


if __name__ == "__main__":
    main()

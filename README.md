# Excel Converter and Database Importer

This C++20 project converts Excel files to CSV and imports the data into an external database.

## Prerequisites

-   C++20 compatible compiler (GCC 10+, Clang 10+, or MSVC 2019+)
-   Make build system
-   CMake (for building OpenXLSX)
-   Git (for cloning the repository and submodules)

## Installation

1. Clone the repository and its submodules:

    ```
    git clone --recurse-submodules https://github.com/Awhux/sheet-importer-converter.git
    cd excel-converter-importer
    ```

    If you've already cloned the repository without submodules, run:

    ```
    git submodule update --init --recursive
    ```

## Building the Project

1. Ensure you're in the project root directory.

2. Run make to build the project:

    ```
    make
    ```

    This will automatically build OpenXLSX and then build your project.

The compiled program will be in the `out` directory.

## Running the Program

Execute the program from the command line:

```
./out/program <input_file.xlsx>
```

Replace `<input_file.xlsx>` with the path to your Excel file.

## Cleaning up

To remove all built files and start fresh:

```
make clean
```

## Troubleshooting

-   If you encounter issues with submodules, ensure you've initialized them with `git submodule update --init --recursive`.
-   For database connection issues, verify your connection string and database server status.

## Contributing

Please read CONTRIBUTING.md for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the LICENSE.md file for details.
